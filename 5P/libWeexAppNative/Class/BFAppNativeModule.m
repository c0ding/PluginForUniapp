//
//  BFAppNativeModule.m
//  libWeexAppNative
//
//  Created by 张逸阳 on 2019/4/3.
//  Copyright © 2019年 毕方. All rights reserved.
//

#import "BFAppNativeModule.h"


#import "BFCacheHandle.h"

#import "BFLocationVC.h"
#import "BFNearbyVC.h"

#define CachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]



@implementation BFAppNativeModule
@synthesize weexInstance;

WX_EXPORT_METHOD(@selector(shareFile:callback:))
WX_EXPORT_METHOD(@selector(gotoNotificationSetting:callback:))
WX_EXPORT_METHOD(@selector(getCacheSize:callback:))
WX_EXPORT_METHOD(@selector(clearCache:callback:))
WX_EXPORT_METHOD(@selector(videoCompression:callback:))
WX_EXPORT_METHOD(@selector(location:callback:))
WX_EXPORT_METHOD(@selector(locationPOI:callback:))

WX_EXPORT_METHOD(@selector(login:callback:))

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}


- (void)login:(NSDictionary *)options callback:(WXModuleKeepAliveCallback)callback
{
    NSLog(@"123");
    [self location:options callback:callback];
}

#pragma mark - Export Method
- (void)shareFile:(NSDictionary *)options callback:(WXModuleKeepAliveCallback)callback
{
    //        回传消息 code 0表示成功 1表示取消 其他值代表失败
    NSInteger code = -1;
    if ([options[@"target"] isEqualToString:@"weixin"]) {
        code =  [self _weixinFileShare];
    }
    
    if([options[@"target"] isEqualToString:@"qq"]) {
        code = [self _qqFileShare];
    }
}

- (void)gotoNotificationSetting:(NSDictionary *)options callback:(WXModuleKeepAliveCallback)callback
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

- (void)getCacheSize:(NSDictionary *)options callback:(WXModuleKeepAliveCallback)callback
{
    [BFCacheHandle getFileSize:CachePath completion:^(NSInteger totalSize) {
        NSLog(@"==> %ld",totalSize);
    }];
}

- (void)clearCache:(NSDictionary *)options callback:(WXModuleKeepAliveCallback)callback
{
    [BFCacheHandle removeDirectoryPath:CachePath];
}

- (void)videoCompression:(NSDictionary *)options callback:(WXModuleKeepAliveCallback)callback
{
    
}

- (void)location:(NSDictionary *)options callback:(WXModuleKeepAliveCallback)callback
{
    BFLocationVC *locVC = [[BFLocationVC alloc] initWithOptions:options callback:callback];
    [self _presentViewController:locVC options:options callback:callback];
}

- (void)locationPOI:(NSDictionary *)options callback:(WXModuleKeepAliveCallback)callback
{
    BFNearbyVC *locVC = [[BFNearbyVC alloc] initWithOptions:options callback:callback];
    [self _presentViewController:locVC options:options callback:callback];
}

- (void)_presentViewController:(UIViewController *)vc options:(NSDictionary *)options callback:(WXModuleKeepAliveCallback)callback
{
    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topRootViewController.presentedViewController)
    {
        topRootViewController = topRootViewController.presentedViewController;
    }
    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:vc];
    [topRootViewController presentViewController:navc animated:YES completion:nil];
}

#pragma mark - Internal Method
- (NSInteger)_weixinFileShare
{
    
    return 1;
}

- (NSInteger)_qqFileShare
{
    return 1;
}
@end
