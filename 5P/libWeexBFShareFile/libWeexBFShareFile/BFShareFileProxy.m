//
//  BFShareFileProxy.m
//  libWeexBFShareFile
//
//  Created by 张逸阳 on 2019/4/2.
//  Copyright © 2019年 毕方. All rights reserved.
//

#import "BFShareFileProxy.h"

@implementation BFShareFileProxy
-(void)onCreateUniPlugin{
    NSLog(@"2222 TestPlugin 有需要初始化的逻辑可以放这里！");
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    NSLog(@"22222 TestPlugin 有需要didFinishLaunchingWithOptions可以放这里！");
    return YES;
}
@end
