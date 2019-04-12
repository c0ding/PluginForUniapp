//
//  BFAppNativeProxy.m
//  libWeexAppNative
//
//  Created by 张逸阳 on 2019/4/3.
//  Copyright © 2019年 毕方. All rights reserved.
//

#import "BFAppNativeProxy.h"

#import "TencentOAuth.h"

#import "AMapFoundationKit.h"
#import "AMapLocationKit.h"
const static NSString *AMapKey = @"0b6dc5e1ab190a976cf234ba2cef5f9d";

@implementation BFAppNativeProxy



-(void)onCreateUniPlugin
{
    NSLog(@"3333 init");

    [AMapServices sharedServices].apiKey = (NSString *)AMapKey;
    [AMapServices sharedServices].enableHTTPS = YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"3333 didFinishLaunching");

     [[TencentOAuth alloc] initWithAppId:@"QQKey" andDelegate:nil];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [TencentOAuth HandleOpenURL:url];
}


@end
