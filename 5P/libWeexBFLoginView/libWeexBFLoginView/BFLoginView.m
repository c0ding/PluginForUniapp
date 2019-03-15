//
//  BFLoginView.m
//  libWeexBFLoginView
//
//  Created by 张逸阳 on 2019/3/14.
//  Copyright © 2019年 毕方. All rights reserved.
//

#import "BFLoginView.h"
#import "WXConvert.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface BFLoginView()
@property (nonatomic, assign) BOOL mIsShowing;
@property (nonatomic, copy) BFLoginViewCallback callback;
@property (nonatomic, strong) UITextField *nameText;
@property (nonatomic, strong) UITextField *pwdText;
@property (nonatomic, strong) UIButton *loginBtn;
@end


@implementation BFLoginView
- (instancetype)init
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
        
        _nameText = ({
            UITextField * textView = [[UITextField alloc] init];
            textView.textAlignment = NSTextAlignmentLeft;
            textView.backgroundColor = [UIColor grayColor];
            [self addSubview:textView];
            textView.frame = CGRectMake(0, 80, 100, 44);
            textView;
        });
        
        _pwdText = ({
            UITextField * textView = [[UITextField alloc] init];
            textView.textAlignment = NSTextAlignmentLeft;
            textView.backgroundColor = [UIColor grayColor];
            [self addSubview:textView];
            textView.frame = CGRectMake(0, 180, 100, 44);
            textView;
        });
        
        _loginBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:@"登录" forState:UIControlStateNormal];
            [btn setBackgroundColor: [UIColor blueColor]];
            [self addSubview:btn];
            [btn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(0, 250, 100, 44);
            btn;
        });
    }
    return self;
}

- (void)loginBtnClick:(UIButton *)sender{
    if (self.callback) {
        NSDictionary *res = @{
                              @"userToken": @"1234567890",
                              @"name": @"simo",
                              @"mobile":@"13099999999"
                              };
        self.callback(res);
    }
}


- (void)parseOption:(NSDictionary *)option
{
    NSLog(@"%@",option);
    // 走网络请求
    
    if (option[@"userName"]) {
        NSString *name = [WXConvert NSString:option[@"userName"]];
        _nameText.text = name;
    }
    
    if (option[@"password"]) {
        NSString *pwd = [WXConvert NSString:option[@"password"]];
        _pwdText.text = pwd;
    }
}

- (UIWindow *)findVisibleWindow
{
    return [UIApplication sharedApplication].keyWindow;
}


+ (BFLoginView *)loginWithOptions:(NSDictionary *)options callback:(BFLoginViewCallback)callback
{
    BFLoginView *loginView = [[BFLoginView alloc] init];
    loginView.callback = callback;
    [loginView parseOption:options];
    return loginView;
}

- (void)show
{
    [self showInView:nil];
}

- (void)showInView:(UIView *)view
{
    
    if (self.mIsShowing) {
        return;
    }
    
    if (!view) {
        view = [self findVisibleWindow];
    }
    
    [view addSubview:self];
    
    self.mIsShowing = YES;
}
- (void)dismiss
{
    self.mIsShowing = NO;
    self.callback = nil;
    [self removeFromSuperview];
}

@end
