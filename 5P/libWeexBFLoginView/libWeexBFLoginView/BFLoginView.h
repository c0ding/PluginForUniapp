//
//  BFLoginView.h
//  libWeexBFLoginView
//
//  Created by 张逸阳 on 2019/3/14.
//  Copyright © 2019年 毕方. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BFLoginViewCallback)(NSDictionary *result);

NS_ASSUME_NONNULL_BEGIN

@interface BFLoginView : UIView

+ (BFLoginView *)loginWithOptions:(NSDictionary *)options callback:(BFLoginViewCallback)callback;

- (void)show;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
