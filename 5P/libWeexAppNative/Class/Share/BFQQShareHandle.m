//
//  BFQQShareHandle.m
//  libWeexAppNative
//
//  Created by 张逸阳 on 2019/4/3.
//  Copyright © 2019年 毕方. All rights reserved.
//

#import "BFQQShareHandle.h"
#import  "QQApiInterfaceObject.h"
#import "QQApiInterface.h"
@interface  BFQQShareHandle () 

@end
@implementation BFQQShareHandle

- (BOOL)webpageWithTitle:(NSString *)title description:(NSString *)description url:(NSString *)url
{
    
    NSString *previewPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"res2.jpg"];
    
    //图片
    NSData *previewData = [NSData dataWithContentsOfFile:previewPath];

    
    NSString *utf8String = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    
    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:utf8String ? : @""]
                                                        title:title ? : @""
                                                  description:description ? : @""
                                             previewImageData:nil];
    [newsObj setCflag:0];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];

    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    
    
        
    
    [self handleSendResult:sent];
    
    
    return YES;
}




- (BOOL)fileWithFilePath:(NSString* )filePath andFileName:(NSString *)fileName
{
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    
    QQApiFileObject *fileObj = [QQApiFileObject objectWithData:fileData
                                              previewImageData:nil
                                                         title: @"titleBB"
                                                  description : @"descriptionBB"];

    fileObj.fileName = fileName;
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:fileObj];
//    kQQAPICtrlFlagQQShareDataline = 16;

    fileObj.cflag = 16;
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    
    return 1;
    
//    [self handleSendResult:sent];
}



- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {

    }
}
@end
