//
//  BFConventToFormatAddressHandle.m
//  libWeexAppNative
//
//  Created by 张逸阳 on 2019/4/10.
//  Copyright © 2019年 毕方. All rights reserved.
//

#import "BFConventToFormatAddressHandle.h"
#import "AMapSearchAPI.h"
#import "MAMapView.h"
@interface BFConventToFormatAddressHandle () <AMapSearchDelegate>
@property (nonatomic ,strong)AMapSearchAPI *search;



@end

@implementation BFConventToFormatAddressHandle

- (void )conventToFormatAddressWithLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude callback:(nonnull AddressBlcok)callback
{
    self.callBlcok = callback;
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
     [self searchReGeocodeWithCoordinate:(CLLocationCoordinate2D){latitude,longitude}];
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"地图POI搜索错误");
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    
    __weak typeof(self) weakSelf = self;
    if (response.regeocode != nil) {
        NSDictionary *res = @{
                              @"province": response.regeocode.addressComponent.province,
                              @"city": response.regeocode.addressComponent.city,
                              @"district":response.regeocode.addressComponent.district,
                              @"address":response.regeocode.formattedAddress
                              };
        weakSelf.callBlcok(res, YES);
    }
}

- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location                    = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension            = YES;
    
    [self.search AMapReGoecodeSearch:regeo];
}
@end
