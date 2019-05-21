//
//  PlayViewController.m
//  WAVideoBox
//
//  Created by 黄锐灏 on 2019/1/6.
//  Copyright © 2019 黄锐灏. All rights reserved.
//

#import "PlayViewController.h"
#import <AVKit/AVKit.h>

@interface PlayViewController ()

@property(nonatomic,strong) AVPlayerViewController *playerController;
@property (nonatomic , strong) NSString *url;

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _playerController = [[AVPlayerViewController alloc] init];
    
//    NSURL * url = [NSURL fileURLWithPath:self.filePath];
    NSURL * url = [NSURL URLWithString:self.url];
    
    _playerController.player = [AVPlayer playerWithURL:url];
    _playerController.view.frame = self.view.bounds;
    _playerController.showsPlaybackControls = YES;
  
    [self.view addSubview:_playerController.view];
 
    
    
    
    
    [self.navigationController.navigationBar navBarBackGroundColor:[UIColor blackColor] image:nil isOpaque:YES];//颜色
            [self.navigationController.navigationBar navBarBottomLineHidden:YES];//隐藏底线
    

    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [leftBtn setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.frame = CGRectMake(0, 0, 50,  50);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    
    
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[_playerController player] play];
}

- (void)loadWithUrl:(NSString *)Url {
    self.url = Url;
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
