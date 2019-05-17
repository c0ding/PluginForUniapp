//
//  BFAppNativeProxy.m
//  libWeexAppNative
//
//  Created by 张逸阳 on 2019/4/3.
//  Copyright © 2019年 毕方. All rights reserved.
//

#import "BFAppNativeProxy.h"

#import "TencentOAuth.h"
#import "WXApi.h"
#import "AMapFoundationKit.h"
#import "AMapLocationKit.h"
const static NSString *AMapKey = @"c18ef6f066ac524a3181f0eafc493c93";
const static NSString *WeiXinAppID = @"wx3c5ad4a102d0022a";
@implementation BFAppNativeProxy



-(void)onCreateUniPlugin
{
    NSLog(@"3333 init");

    [AMapServices sharedServices].apiKey = (NSString *)AMapKey;
    [AMapServices sharedServices].enableHTTPS = YES;
    
    [WXApi registerApp:(NSString *)WeiXinAppID];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"3333 didFinishLaunching");

     [[TencentOAuth alloc] initWithAppId:@"1108816762" andDelegate:nil];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    [TencentOAuth HandleOpenURL:url];
    return [WXApi handleOpenURL:url delegate:nil];
//    return [TencentOAuth HandleOpenURL:url];
}

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [TencentOAuth HandleOpenURL:url];
         return [WXApi handleOpenURL:url delegate:nil];
}

@end
