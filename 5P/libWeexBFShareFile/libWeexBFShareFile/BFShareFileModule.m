//
//  BFShareFileModule.m
//  libWeexBFShareFile
//
//  Created by 张逸阳 on 2019/4/2.
//  Copyright © 2019年 毕方. All rights reserved.
//

#import "BFShareFileModule.h"

#import "WXUtility.h"


#import "WXApiObject.h"
#import "WXApi.h"
#import "SendMessageToWXReq+requestWithTextOrMediaMessage.h"
#import "WXMediaMessage+messageConstruct.h"

@interface BFShareFileModule( )
@property (nonatomic) enum WXScene currentScene;
@end

@implementation BFShareFileModule
@synthesize weexInstance;
@synthesize currentScene = _currentScene;
WX_EXPORT_METHOD(@selector(shareFile:callback:))
- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - Export Method
- (void)shareFile:(NSDictionary *)options callback:(WXModuleKeepAliveCallback)callback
{
    [self _shareFile:options callback:callback];
}

- (void)_shareFile:(NSDictionary *)options callback:(WXModuleKeepAliveCallback)callback
{
    //    DCloud-AppNative.shareFile({target:’xxx' ,filePath:’xxx', fileName:’xxx'}, callback)
    //
    //        分享文件完成native回传信息 {“code”:”xxx", “message”:”xxx"}
    //
    //        target包含 weixin qq
    //        回传消息 code 0表示成功 1表示取消 其他值代表失败
    if ([options[@"target"] isEqualToString:@"weixin"]) {
        [self _weixinFileShare];
    }
    
    if([options[@"target"] isEqualToString:@"qq"]) {
        
    }
}

- (NSInteger)_weixinFileShare
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
    
    
    return 1;
    
}

- (NSInteger)_qqFileShare
{
    return 1;
}

- (void)sendFileContent
{
    
    

    
    
}




@end
