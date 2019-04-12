//
//  BFNearbyVC.m
//  libWeexAppNative
//
//  Created by 张逸阳 on 2019/4/9.
//  Copyright © 2019年 毕方. All rights reserved.
//

#import "BFNearbyVC.h"

@interface BFNearbyVC ()
@property (nonatomic, copy) BFNearbyVCCallback callback;
@property (nonatomic, strong) NSDictionary *options;
@end

@implementation BFNearbyVC

- (instancetype)initWithOptions:(NSDictionary *)options callback:(BFNearbyVCCallback)callback
{
    self = [super init];
    if (self) {
        self.options = [NSDictionary dictionaryWithDictionary:options];
        self.callback = callback;
        self.view.backgroundColor = [UIColor whiteColor];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
        
    }
    return self;
}

- (void)dismiss
{
    if (self.callback) {
//        NSDictionary *res = @{
//                              @"province": _dataSource[_lastPath.row].province,
//                              @"city": _dataSource[_lastPath.row].city,
//                              @"district":_dataSource[_lastPath.row].district,
//                              @"address":_dataSource[_lastPath.row].address,
//                              @"latitude":@(_dataSource[_lastPath.row].location.latitude),
//                              @"longitude":@(_dataSource[_lastPath.row].location.longitude)
//                              };
//        self.callback(res,YES);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


@end
