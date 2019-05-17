//
//  BFLocationVC.m
//  libWeexAppNative
//
//  Created by 张逸阳 on 2019/4/3.
//  Copyright © 2019年 毕方. All rights reserved.
//

#import "BFLocationVC.h"
#import "MAMapKit.h"
#import "AMapLocationKit.h"
#import "AMapSearchAPI.h"

#define kMapHeight 0.39

@interface BFLocationVC ()<MAMapViewDelegate, AMapSearchDelegate,AMapLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) BFLocationVCCallback callback;
@property (nonatomic, strong) NSDictionary *options;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) MAPointAnnotation *annotation;
//@property (nonatomic, strong) AMapReGeocodeSearchRequest *regeo;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, assign) CLLocationCoordinate2D currentLockedLocation;
@property (nonatomic, strong) MAPointAnnotation *lockedAnnotation;


@property (nonatomic, strong) NSMutableArray <AMapPOI *> *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic,strong)NSIndexPath *lastPath;
@end

@implementation BFLocationVC

//
//屏幕中间 大头针：注释
//[mapView addAnnotation:self.lockedAnnotation];
//手势移动 回调

- (instancetype)initWithOptions:(NSDictionary *)options callback:(BFLocationVCCallback)callback
{
    self = [super init];
    if (self) {
        self.options = [NSDictionary dictionaryWithDictionary:options];
        self.callback = callback;
        
        
        
    }
    return self;
}

- (void)confirm
{
    if (_dataSource.count<1) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//        self.callback(nil,YES);
        return;
    }
    
    if (self.callback) {
        
        NSDictionary *res = @{
                              @"province": _dataSource[_lastPath.row].province,
                              @"city": _dataSource[_lastPath.row].city,
                              @"district":_dataSource[_lastPath.row].district,
                              @"address":_dataSource[_lastPath.row].address,
                              @"latitude":@(_dataSource[_lastPath.row].location.latitude),
                              @"longitude":@(_dataSource[_lastPath.row].location.longitude),
                              
                              @"uid":_dataSource[_lastPath.row].uid,
                              @"name":_dataSource[_lastPath.row].name,
                              
                              
                              };
        self.callback(res,YES);
        
        [res writeToFile:kCurrentAddressPlistPath atomically:YES];
        [self dismiss];
    }
}



- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.view addSubview:self.mapView];
    [self.navigationController.navigationBar navBarBackGroundColor:[UIColor blackColor] image:nil isOpaque:YES];//颜色
    [self.navigationController.navigationBar navBarBottomLineHidden:YES];//隐藏底线
    
    self.view.backgroundColor = [UIColor whiteColor];

 
    
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"resource" ofType:@"bundle"] ];
    
    
    
    
    UIImage *img = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"asd" ofType:@"png"]];
    
//    UIImageView *leftBtn = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    leftBtn.image = img;
//
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [leftBtn setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
//    [leftBtn setImage:img forState:UIControlStateNormal];

    [leftBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.frame = CGRectMake(0, 0, 50,  50);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
   
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:RGBA(242, 169, 73, 1) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(0, 0, 50,  50);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initSearchPOIWithLatitude:_currentLocation.coordinate.latitude andLongitude:_currentLocation.coordinate.longitude];
    
}


// 获取s定位位置,经纬度
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    _currentLocation = userLocation.location;
    [self initSearchPOIWithLatitude:_currentLocation.coordinate.latitude andLongitude:_currentLocation.coordinate.longitude];
    [self initSearchActionWithLatitude:_currentLocation.coordinate.latitude andLongitude:_currentLocation.coordinate.longitude];
}



// 点击定位 进行反地理编码查询
//- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
//{
//    if ([view.annotation isKindOfClass:[MAUserLocation class]]) {
//        [self initSearchActionWithLatitude:_currentLocation.coordinate.latitude andLongitude:_currentLocation.coordinate.longitude];
//    }
//}

///----
// 监听地图手势移动，获取当前地图中心点坐标
//- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction
//{
//
//    _lastPath = [NSIndexPath indexPathForRow:0 inSection:0];
//
//    [self initSearchPOIWithLatitude:mapView.centerCoordinate.latitude andLongitude:mapView.centerCoordinate.longitude];
////    [self initSearchActionWithLatitude:mapView.centerCoordinate.latitude andLongitude:mapView.centerCoordinate.longitude];
//}
///----

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
    _dataSource = [NSMutableArray arrayWithArray:response.pois];
    [self.tableView reloadData];
}

//- (AMapReGeocodeSearchRequest *)regeo {
//    if (!_regeo) {
//        _regeo = [[AMapReGeocodeSearchRequest alloc]init];
//        _regeo.requireExtension = YES;
//    }
//    return _regeo;
//}

- (AMapSearchAPI *)search {
    if (!_search) {
        _search = [[AMapSearchAPI alloc]init];
        _search.delegate = self;
    }
    return _search;
}





-(void)initSearchActionWithLatitude:(CGFloat )latitude andLongitude:(CGFloat)longitude
{
//    if (_currentLocation == nil ) {
//        return;
//    }
//    self.regeo.location = [AMapGeoPoint locationWithLatitude:latitude longitude:longitude];
//    [self.search AMapReGoecodeSearch:self.regeo];
}



-(void)initSearchPOIWithLatitude:(CGFloat )latitude andLongitude:(CGFloat)longitude
{
    if (_currentLocation == nil || self.search == nil) {
        return;
    }
    
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:latitude longitude:longitude];
    request.types = @"商务住宅";
    request.sortrule = 0;
    request.requireExtension = YES;
    request.radius = 200;
    [_search AMapPOIAroundSearch:request];
    
}


- (MAMapView *)mapView
{
    if (!_mapView) {
        _mapView = ({
            MAMapView *mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight*kMapHeight)];
            mapView.delegate = self;
            mapView.showsCompass = NO;
            mapView.zoomLevel = 16;
            mapView.maxZoomLevel = 18;
            mapView.showsUserLocation = YES;
            mapView.userTrackingMode = MAUserTrackingModeFollow;//实时
//            [mapView addAnnotation:self.lockedAnnotation];
            mapView;
        });
    }
    return _mapView;
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    cell.textLabel.text = _dataSource[indexPath.row].name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row].address];
    cell.tintColor = RGBA(242, 169, 73, 1);
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    if (_lastPath == nil) {
        _lastPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    NSInteger oldRow = _lastPath.row;
    if (indexPath.row == oldRow && _lastPath!=nil) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger newRow = indexPath.row;
    NSInteger oldRow = (_lastPath !=nil)?[_lastPath row]:-1;
    if (newRow != oldRow) {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:_lastPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        _lastPath = indexPath;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UITableView*)tableView
{
    if (!_tableView) {
        CGFloat Y = CGRectGetMaxY(_mapView.frame);
        UITableView *tableView =  [[UITableView alloc] initWithFrame:CGRectMake(0  ,Y, kScreenWidth, kScreenHeight*(1-kMapHeight)) style:UITableViewStylePlain];
        [self.view addSubview:tableView];
        
        tableView.delegate = self;
        tableView.dataSource = self;
        //        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        tableView.backgroundColor =  [UIColor clearColor];
        tableView.rowHeight = kHeight(59);
        _tableView = tableView;

    }
    return _tableView;
}
@end

