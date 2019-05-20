//
//  BFNearbyVC.m
//  libWeexAppNative
//
//  Created by 张逸阳 on 2019/4/9.
//  Copyright © 2019年 毕方. All rights reserved.
//

#import "BFNearbyVC.h"
#import "MAMapKit.h"
#import "AMapLocationKit.h"
#import "AMapSearchAPI.h"
#import "BFWeiXinShareHandle.h"
#import "BFQQShareHandle.h"
#import "LoadDataListContainerListViewController.h"

#define kMapHeight 0.45

@interface BFNearbyVC () <MAMapViewDelegate, AMapSearchDelegate,AMapLocationManagerDelegate,JXCategoryViewDelegate,JXCategoryListContainerViewDelegate,UIActionSheetDelegate>
@property (nonatomic, copy) BFNearbyVCCallback callback;
@property (nonatomic, strong) NSDictionary *options;

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) MAPointAnnotation *annotation;
@property (nonatomic, strong) AMapReGeocodeSearchRequest *regeo;
@property (nonatomic, strong) CLLocation *currentLocation;
//@property (nonatomic, assign) CLLocationCoordinate2D currentLockedLocation;
@property (nonatomic, strong) MAPointAnnotation *lockedAnnotation;

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, strong) NSArray <NSString *> *titles;

//@property (nonatomic,assign) BOOL isShowTableView;
//@property (nonatomic, strong) NSMutableArray <AMapPOI *> *dataSource;
@end
@implementation BFNearbyVC

// 屏幕中心大头针注释
// [self.mapView addAnnotation:self.lockedAnnotation];
//监听地图手势移动，获取当前地图中心点坐标
//[self initSearchPOIWithLatitude:self.mapView.centerCoordinate.latitude andLongitude:self.mapView.centerCoordinate.longitude];


- (instancetype)initWithOptions:(NSDictionary *)options callback:(BFNearbyVCCallback)callback
{
    self = [super init];
    if (self) {
        self.options = [NSDictionary dictionaryWithDictionary:options];
        self.callback = callback;
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)share
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"分享位置"
                                                                                      delegate:self
                                                                            cancelButtonTitle:@"不分享了"
                                                                      destructiveButtonTitle:nil
                                                                            otherButtonTitles:@"分享给微信好友",@"分享给QQ好友", nil];
         [action showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0 && buttonIndex != 1) {
        return;
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:kCurrentAddressPlistPath];
    
    NSString *uid = dict[@"uid"];
    double lat = [dict[@"latitude"] doubleValue];
    double lon = [dict[@"longitude"] doubleValue];
    NSString *name = dict[@"name"];
    NSString *address = dict[@"address"];
    
    NSString *str = [NSString stringWithFormat:@"&src=app_share&callnative=1&callapp=0&poiid=%@",uid];
    
    NSString *url = [NSString stringWithFormat:@"https://m.amap.com/search/mapview/__p=%@,%f,%f,%@,%@%@",uid,lat,lon,name,address,str];
    
    
    if (buttonIndex == 0 ) {
        [self _shareToWechat:dict Url:url];
    }else if (buttonIndex == 1) {
        [self _shareToQQ:dict Url:url];
    }
        
    
}

- (void)_shareToQQ:(NSDictionary *)dict Url:(NSString *)url
{
    BFQQShareHandle *qqShare = [[BFQQShareHandle alloc] init];
    [qqShare  webpageWithTitle:dict[@"name"] description:dict[@"address"] url:url];
}

- (void)_shareToWechat:(NSDictionary *)dict Url:(NSString *)url
{
    
    BFWeiXinShareHandle *wxShare = [[BFWeiXinShareHandle alloc] init];
    [wxShare webpageWithTitle:dict[@"name"] description:dict[@"address"] url:url];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initMapView];
    [self search];
    
    self.titles = @[@"政府部门",@"商圈",@"医院",@"学校",@"地铁口",@"高速路口"];
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0 ,CGRectGetMaxY(_mapView.frame), kScreenWidth, kHeight(53))];
    self.categoryView.delegate = self;
    [self.view addSubview:self.categoryView];
    self.categoryView.titles = self.titles;
    self.categoryView.titleSelectedColor = RGBA(242, 169, 73, 1);
    self.categoryView.defaultSelectedIndex = 0;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineViewColor = RGBA(242, 169, 73, 1);
    lineView.indicatorLineWidth = JXCategoryViewAutomaticDimension;
    self.categoryView.indicators = @[lineView];
    
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithDelegate:self];
    self.listContainerView.defaultSelectedIndex = 0;
    
    
    [self.view addSubview:self.listContainerView];
    
    self.categoryView.contentScrollView = self.listContainerView.scrollView;
    
    self.listContainerView.frame = CGRectMake(0, CGRectGetMaxY(self.categoryView.frame), kScreenWidth, kScreenHeight - CGRectGetMaxY(self.categoryView.frame) );
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [self.categoryView addGestureRecognizer:recognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;//实时
    
    
    [self initSearchPOIWithLatitude:_currentLocation.coordinate.latitude andLongitude:_currentLocation.coordinate.longitude];
    //    [self.mapView addAnnotation:self.lockedAnnotation];
    
    [self _setNavi];
}

- (void)_setNavi
{
    [self.navigationController.navigationBar navBarBackGroundColor:[UIColor blackColor] image:nil isOpaque:YES];//颜色
    [self.navigationController.navigationBar navBarBottomLineHidden:YES];//隐藏底线
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [leftBtn setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.frame = CGRectMake(0, 0, 50,  50);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"分享" forState:UIControlStateNormal];
    [rightBtn setTitleColor:RGBA(242, 169, 73, 1) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(0, 0, 50,  50);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (void)handleSwipeFrom {
//    [self _showTableView:self.isShowTableView];
}

#pragma mark - JXCategoryViewDelegate

//点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，不关心具体是点击还是滚动选中的。
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index
{
    
    [self initSearchPOIWithLatitude:_currentLocation.coordinate.latitude andLongitude:_currentLocation.coordinate.longitude];
}


- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    [self.listContainerView didClickSelectedItemAtIndex:index];
    
    [self _showTableView:YES];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    [self.listContainerView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio selectedIndex:categoryView.selectedIndex];
}

#pragma mark - JXCategoryListContainerViewDelegate

-(id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    
    LoadDataListContainerListViewController *listVC = [[LoadDataListContainerListViewController alloc] init];
    listVC.naviController = self.navigationController;
    
    return listVC;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}


// 获取s定位位置,经纬度
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (!_currentLocation) {
        _currentLocation = userLocation.location;
    }
}

// 点击地图
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self _showTableView:NO];
}

- (void)_showTableView:(BOOL )isShow
{
    if (isShow) {
        self.mapView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight*kMapHeight);
        self.categoryView.frame = CGRectMake(0 ,CGRectGetMaxY(_mapView.frame), kScreenWidth, kHeight(53));
        self.listContainerView.frame = CGRectMake(0, CGRectGetMaxY(self.categoryView.frame), kScreenWidth, kScreenHeight - CGRectGetMaxY(self.categoryView.frame) );
    }else {
        self.mapView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-kHeight(53));
        self.categoryView.frame = CGRectMake(0 ,CGRectGetMaxY(_mapView.frame), kScreenWidth, kHeight(53));
        self.listContainerView.frame = CGRectMake(0, CGRectGetMaxY(self.categoryView.frame), kScreenWidth, kScreenHeight - CGRectGetMaxY(self.categoryView.frame) );
    }
    
//    self.isShowTableView = !self.isShowTableView;
}



// 点击定位 进行反地理编码查询
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[MAUserLocation class]]) {
        [self initSearchActionWithLatitude:_currentLocation.coordinate.latitude andLongitude:_currentLocation.coordinate.longitude];
    }
}

// 监听地图手势移动，获取当前地图中心点坐标
//- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction
//{
////
////    NSLog(@"%lf",mapView.centerCoordinate.latitude);
////    NSLog(@"%lf",mapView.centerCoordinate.longitude);
//
//    [self initSearchPOIWithLatitude:mapView.centerCoordinate.latitude andLongitude:mapView.centerCoordinate.longitude];
//    [self initSearchActionWithLatitude:mapView.centerCoordinate.latitude andLongitude:mapView.centerCoordinate.longitude];
//}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil) {
        //        AMapReGeocode *reocode = response.regeocode;
        //地图标注的点的位置信息全在reoceode里面了
        NSString *str = response.regeocode.addressComponent.city;
        str = response.regeocode.addressComponent.province;
        _mapView.userLocation.title = str;//主标题
        _mapView.userLocation.subtitle = response.regeocode.formattedAddress;//子标题
        
        
        
        
        
        
    }
    
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
//    NSLog(@"=== %@",response.pois);
//    _dataSource = [NSMutableArray arrayWithArray:response.pois];
    
    [self _writeToFileWithArrar:response.pois];
//    [self.categoryView reloadData];
    [self.listContainerView reloadData];

}

- (void)_writeToFileWithArrar:(NSArray *)data {
    NSMutableArray *arr = [NSMutableArray array];
    for (AMapPOI *obj in data) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:obj.name forKey:@"name"];
        [dict setValue:@(obj.distance) forKey:@"distance"];
        [arr addObject:dict];
    }
    
//    if ([[NSFileManager defaultManager] fileExistsAtPath:kPoisPlistPath])
//    {
//        [[NSFileManager defaultManager] removeItemAtPath:kPoisPlistPath error:nil];
//    }
    
    [arr writeToFile:kPoisPlistPath atomically:YES];
}


- (AMapReGeocodeSearchRequest *)regeo {
    if (!_regeo) {
        _regeo = [[AMapReGeocodeSearchRequest alloc]init];
        _regeo.requireExtension = YES;
    }
    return _regeo;
}

- (AMapSearchAPI *)search {
    if (!_search) {
        _search = [[AMapSearchAPI alloc]init];
        _search.delegate = self;
    }
    return _search;
}

-(void)initSearchActionWithLatitude:(CGFloat )latitude andLongitude:(CGFloat)longitude
{
    if (_currentLocation == nil ) {
        return;
    }
    self.regeo.location = [AMapGeoPoint locationWithLatitude:latitude longitude:longitude];
    [_search AMapReGoecodeSearch:self.regeo];
}



-(void)initSearchPOIWithLatitude:(CGFloat )latitude andLongitude:(CGFloat)longitude
{
    const  NSArray * keysPOI = @[@"政府机关",@"购物服务",@"医疗保健服务",@"学校",@"地铁站",@"收费站"];
    
    if (_currentLocation == nil || _search == nil) {
        return;
    }
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:latitude longitude:longitude];
    request.sortrule = 0;
    request.requireExtension = YES;
    request.keywords = keysPOI [self.categoryView.selectedIndex];
    request.radius = 5000;
    [_search AMapPOIAroundSearch:request];
    
}



- (void)initMapView
{
    _mapView = ({
        MAMapView *mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight*kMapHeight)];
        mapView.delegate = self;
        //        mapView.compassOrigin = CGPointMake(mapView.compassOrigin.x, 22);
        //        mapView.scaleOrigin = CGPointMake(mapView.scaleOrigin.x, 22);
        mapView.showsCompass = NO;
        mapView.zoomLevel = 16;
        mapView.maxZoomLevel = 18;
        [self.view addSubview:mapView];
        mapView;
    });
}

- (MAPointAnnotation *)lockedAnnotation
{
    if (!_lockedAnnotation) {
        _lockedAnnotation = [[MAPointAnnotation alloc] init];
        _lockedAnnotation.lockedToScreen = YES;
        _lockedAnnotation.lockedScreenPoint = self.mapView.center;
    }
    return _lockedAnnotation;
}

@end
