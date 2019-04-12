//
//  BFWeiXinShareHandle.m
//  libWeexAppNative
//
//  Created by 张逸阳 on 2019/4/3.
//  Copyright © 2019年 毕方. All rights reserved.
//

#import "BFWeiXinShareHandle.h"
#import "WXUtility.h"

#import "WXApiObject.h"
#import "WXApi.h"
#import "SendMessageToWXReq+requestWithTextOrMediaMessage.h"
#import "WXMediaMessage+messageConstruct.h"

@interface BFWeiXinShareHandle()
@property (nonatomic) enum WXScene currentScene;
@end

@implementation BFWeiXinShareHandle

@synthesize currentScene = _currentScene;//微信分享

- (void)test
{
    NSString *kFileName = @"";
    NSString *kFileExtension = @"";
    UIImage *thumbImage = [UIImage imageNamed:@"res2.jpg"];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:kFileName
                                                         ofType:kFileExtension];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = kFileName;
    message.description = kFileName;
    [message setThumbImage:thumbImage];
    
    WXFileObject *ext = [WXFileObject object];
    ext.fileExtension = @"pdf";
    ext.fileData = fileData;
    
    message.mediaObject = ext;
    
    
    
    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
                                                   OrMediaMessage:message
                                                            bText:NO
                                                          InScene:_currentScene];
    BOOL res = [WXApi sendReq:req];
}

@end
