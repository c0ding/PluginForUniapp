//
//  BFLoginViewModule.m
//  libWeexBFLoginView
//
//  Created by 张逸阳 on 2019/3/14.
//  Copyright © 2019年 毕方. All rights reserved.
//

#import "BFLoginViewModule.h"

#import "WXUtility.h"
#import "BFLoginVC.h"

//#import "WXApiObject.h"
//#import "WXApi.h"
//#import "SendMessageToWXReq+requestWithTextOrMediaMessage.h"
//#import "WXMediaMessage+messageConstruct.h"


@interface BFLoginViewModule()

@end

@implementation BFLoginViewModule
@synthesize weexInstance;

WX_EXPORT_METHOD(@selector(login:callback:))
//WX_EXPORT_METHOD(@selector(dismiss))
- (instancetype)init
{
    if (self = [super init]) {
       
    }
    return self;
}


- (void)_login:(NSDictionary *)options callback:(WXModuleKeepAliveCallback)callback
{
    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topRootViewController.presentedViewController)
    {
        topRootViewController = topRootViewController.presentedViewController;
    }
    
    BFLoginVC *loginVC = [[BFLoginVC alloc] initWithOptions:options callback:callback];
    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [topRootViewController presentViewController:navc animated:YES completion:nil];
}


#pragma mark - Export Method
- (void)login:(NSDictionary *)options callback:(WXModuleKeepAliveCallback)callback
{
    [self _login:options callback:callback];
}



//- (void)sendFileContent {
//    NSString *kFileName = @"";
//    NSString *kFileExtension = @"";
//    UIImage *thumbImage = [UIImage imageNamed:@"res2.jpg"];
//    NSString* filePath = [[NSBundle mainBundle] pathForResource:kFileName
//                                                         ofType:kFileExtension];
//    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
//
//    WXMediaMessage *message = [WXMediaMessage message];
//    message.title = kFileName;
//    message.description = kFileName;
//    [message setThumbImage:thumbImage];
//
//    WXFileObject *ext = [WXFileObject object];
//    ext.fileExtension = @"pdf";
//    ext.fileData = fileData;
//
//    message.mediaObject = ext;
//
//
//
//    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
//                                                   OrMediaMessage:message
//                                                            bText:NO
//                                                          InScene:_currentScene];
//    BOOL rep =  [WXApi sendReq:req];
//
//
//}



@end
