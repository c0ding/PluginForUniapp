//
//  BFLoginViewModule.m
//  libWeexBFLoginView
//
//  Created by 张逸阳 on 2019/3/14.
//  Copyright © 2019年 毕方. All rights reserved.
//

#import "BFLoginViewModule.h"
#import "BFLoginView.h"
#import "WXUtility.h"

@interface BFLoginViewModule()
@property (nonatomic ,strong) BFLoginView *loginView;
@end


@implementation BFLoginViewModule
@synthesize weexInstance;
WX_EXPORT_METHOD(@selector(login:callback:))
WX_EXPORT_METHOD(@selector(login:call:))
WX_EXPORT_METHOD(@selector(dismiss))
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    if (self = [super init]) {
        /* 监听App停止运行事件，如果alert存在，调一下dismiss方法移除 */
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"PDRCoreAppDidStopedKey" object:nil];
    }
    return self;
}


- (void)_login:(NSDictionary *)options callback:(WXModuleKeepAliveCallback)callback
{
    BFLoginView *loginView = [BFLoginView
                              loginWithOptions:options
                              callback:^(NSDictionary *result) {
                                                              if (callback) {
                                                                  callback(result,YES);
                                                              }
                                                          }];
    self.loginView = loginView;
    [loginView show];
}


#pragma mark - Export Method
- (void)login:(NSDictionary *)options callback:(WXModuleKeepAliveCallback)callback
{
    [self _login:options callback:callback];
}

- (void)login:(NSDictionary *)options call:(WXModuleKeepAliveCallback)callback
{
    [self _login:options callback:callback];
}

- (void)dismiss
{
    [self.loginView dismiss];
}

@end
