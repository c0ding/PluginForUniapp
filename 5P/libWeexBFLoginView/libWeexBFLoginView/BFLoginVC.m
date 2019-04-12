//
//  BFLoginVC.m
//  libWeexBFLoginView
//
//  Created by 张逸阳 on 2019/3/15.
//  Copyright © 2019年 毕方. All rights reserved.
//

#import "BFLoginVC.h"
#import "BFLoginView.h"

@interface BFLoginVC ()
@property (nonatomic ,strong) BFLoginView *loginView;
@end

@implementation BFLoginVC

- (instancetype)initWithOptions:(NSDictionary *)options callback:(BFLoginVCCallback)callback
{
    self = [super init];
    if (self) {
        BFLoginView *loginView = [BFLoginView
                                  loginWithOptions:options
                                  callback:^(NSDictionary *result) {
                                      if (callback) {
                                            callback(result,YES);
                                      }
                                  }];
        
        self.loginView = loginView;
        [self.loginView showWithView:self.view];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    
    
}

- (void)dismiss {
    [self.loginView dismiss];
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
