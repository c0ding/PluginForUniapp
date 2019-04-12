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
@implementation BFQQShareHandle

- (void)test {

    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"test.txt"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];


    QQApiFileObject *fileObj = [QQApiFileObject objectWithData:fileData
                                              previewImageData:nil
                                                         title: @""
                                                   description : @""];

    fileObj.fileName = @"fileName";
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:fileObj];

    QQApiSendResultCode sent = [QQApiInterface sendReq:req];

    [self handleSendResult:sent];

}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {

    }
}
@end
