//
//  BFLoginViewProxy.m
//  libWeexBFLoginView
//
//  Created by 张逸阳 on 2019/3/14.
//  Copyright © 2019年 毕方. All rights reserved.
//

#import "BFLoginViewProxy.h"

@implementation BFLoginViewProxy
-(void)onCreateUniPlugin{
    NSLog(@"11111 TestPlugin 有需要初始化的逻辑可以放这里！");
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    NSLog(@"11111 TestPlugin 有需要didFinishLaunchingWithOptions可以放这里！");
    return YES;
}
@end
