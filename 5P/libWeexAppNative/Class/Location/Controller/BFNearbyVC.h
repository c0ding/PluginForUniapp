//
//  BFNearbyVC.h
//  libWeexAppNative
//
//  Created by 张逸阳 on 2019/4/9.
//  Copyright © 2019年 毕方. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^BFNearbyVCCallback)(NSDictionary *result, BOOL keepAlive);
NS_ASSUME_NONNULL_BEGIN

@interface BFNearbyVC : UIViewController
- (instancetype)initWithOptions:(NSDictionary *)options callback:(BFNearbyVCCallback)callback;
@end

NS_ASSUME_NONNULL_END
