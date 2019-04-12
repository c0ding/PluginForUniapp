//
//  BFLocationVC.h
//  libWeexAppNative
//
//  Created by 张逸阳 on 2019/4/3.
//  Copyright © 2019年 毕方. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BFLocationVCCallback)(NSDictionary *result, BOOL keepAlive);
NS_ASSUME_NONNULL_BEGIN

@interface BFLocationVC : UIViewController



- (instancetype)initWithOptions:(NSDictionary *)options callback:(BFLocationVCCallback)callback;
@end

NS_ASSUME_NONNULL_END
