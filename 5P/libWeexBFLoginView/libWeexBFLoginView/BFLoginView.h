//
//  BFLoginView.h
//  libWeexBFLoginView
//
//  Created by 张逸阳 on 2019/3/14.
//  Copyright © 2019年 毕方. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BFLoginViewCallback)(NSDictionary *result);

typedef void(^BtnBlock)(NSDictionary *result);

NS_ASSUME_NONNULL_BEGIN

@interface BFLoginView : UIView

@property (nonatomic, copy)  BtnBlock btnBlock;
+ (BFLoginView *)loginWithOptions:(NSDictionary *)options callback:(BFLoginViewCallback)callback;

- (void)showWithView:(UIView *)view;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
