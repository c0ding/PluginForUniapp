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

- (BOOL)webpageWithTitle:(NSString *)title description:(NSString *)description url:(NSString *)url
{
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:[UIImage imageNamed:@"res2.png"]];//设置预览图
    
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = url;
    message.mediaObject = webObj;
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;//不使用文本信息
    sendReq.message = message;
    sendReq.scene = WXSceneSession;//分享到好友会话
    return [WXApi sendReq:sendReq];//发送对象实例
}

- (BOOL)fileWithFilePath:(NSString* )filePath andFileName:(NSString *)fileName
{
    NSString *kFileExtension = @"pdf";
//    UIImage *thumbImage = [UIImage imageNamed:@"res2.jpg"];

    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
//    NSData *fileData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://hj-images.b0.upaiyun.com/pledge/upload/verify_1_1554175644019.pdf"]];

    WXMediaMessage *message = [WXMediaMessage message];
    message.title = fileName;
    message.description = fileName;
//    [message setThumbImage:thumbImage];

    WXFileObject *ext = [WXFileObject object];
    ext.fileExtension = kFileExtension;
    ext.fileData = fileData;

    message.mediaObject = ext;

    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
                                                   OrMediaMessage:message
                                                            bText:NO
                                                          InScene:_currentScene];
    return  [WXApi sendReq:req];
}

@end
