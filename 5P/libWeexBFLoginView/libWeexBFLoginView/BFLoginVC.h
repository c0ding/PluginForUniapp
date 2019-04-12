//
//  BFLoginVC.h
//  libWeexBFLoginView
//
//  Created by 张逸阳 on 2019/3/15.
//  Copyright © 2019年 毕方. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BFLoginVCCallback)(id result, BOOL keepAlive);
NS_ASSUME_NONNULL_BEGIN

@interface BFLoginVC : UIViewController
- (instancetype)initWithOptions:(NSDictionary *)options callback:(BFLoginVCCallback)callback;
@end

NS_ASSUME_NONNULL_END
