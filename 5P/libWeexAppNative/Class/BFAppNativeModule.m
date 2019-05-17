//
//  BFAppNativeModule.m
//  libWeexAppNative
//
//  Created by 张逸阳 on 2019/4/3.
//  Copyright © 2019年 毕方. All rights reserved.
//


#import "BFAppNativeModule.h"

#import "BFCacheHandle.h"
#import "BFWeiXinShareHandle.h"
#import "BFQQShareHandle.h"
#import "BFLocationVC.h"
#import "BFNearbyVC.h"
#import "BFConventToFormatAddressHandle.h"
#import "PlayViewController.h"
#import "WAVideoBox.h"
#import "BFSystemShareHandle.h"
@interface BFAppNativeModule()<UIDocumentInteractionControllerDelegate>
@property (nonatomic ,strong)BFConventToFormatAddressHandle *address;
@property (nonatomic , strong) WAVideoBox *videoBox;
@end


@implementation BFAppNativeModule
@synthesize weexInstance;

WX_EXPORT_METHOD(@selector(shareFile:callback:))

WX_EXPORT_METHOD(@selector(gotoNotificationSetting:callback:))
WX_EXPORT_METHOD(@selector(getCacheSize:callback:))
WX_EXPORT_METHOD(@selector(clearCache:callback:))
WX_EXPORT_METHOD(@selector(getVersionName:callback:))

WX_EXPORT_METHOD(@selector(playVideo:callback:))
WX_EXPORT_METHOD(@selector(videoCompression:callback:))

WX_EXPORT_METHOD(@selector(location:callback:))
WX_EXPORT_METHOD(@selector(locationPOI:callback:))
WX_EXPORT_METHOD(@selector(conventToFormatAddress:callback:))

WX_EXPORT_METHOD(@selector(getImgPath:callback:))

WX_EXPORT_METHOD(@selector(statusBarColor:callback:))
// eg:
WX_EXPORT_METHOD(@selector(login:callback:))

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

// eg:
- (void)login:(NSDictionary *)options callback:(WXModuleKeepAliveCallback)callback
{
    [self location:options callback:callback];
}

#pragma mark - Export Method



- (void)statusBarColor:(NSDictionary *)options callback:(WXModuleKeepAliveCallback)callback
{
    
    if ([options[@"isBlack"] isEqualToString:@"yes"]) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    
}



- (void)getImgPath:(NSArray *)options callback:(WXModuleKeepAliveCallback)callback
{
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSString *str in options) {
        NSLog(@"%@",str);
        NSString *srcFilePath = [str stringByReplacingOccurrencesOfString:@"_doc" withString:@"doc"];
        
        
//        srcFilePath = [str stringByReplacingOccurrencesOfString:@"PNG" withString:@"png"];
        
        if ([srcFilePath hasPrefix:@"file://"]) {
            srcFilePath = [str stringByReplacingOccurrencesOfString:@"file://" withString:@""];
        }else {
            srcFilePath = [@"/Pandora/apps/__UNI__3C18621/" stringByAppendingString:srcFilePath];
            srcFilePath = [kLibraryPath stringByAppendingString:srcFilePath];
        }
        
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:srcFilePath];
        
        
       NSData *data =  [self resetSizeOfImageData:image maxSize:50];
        
//        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%zd.png",i]];

        
        srcFilePath = [kCachePath stringByAppendingString:[NSString stringWithFormat:@"/%f.png", [[NSDate date] timeIntervalSinceReferenceDate]]];
        
        
        [data writeToFile:srcFilePath atomically:YES];

        NSLog(@"%@",srcFilePath);
        
        
      
        
         [arr addObject:[NSString stringWithFormat:@"%@",srcFilePath]];
        [arr addObject:[NSString stringWithFormat:@"file://%@",srcFilePath]];
    }
    
    callback(@{@"paths":arr},YES);
    
}

#pragma mark - 图片压缩
- (NSData *)resetSizeOfImageData:(UIImage *)sourceImage maxSize:(NSInteger)maxSize {
    //先判断当前质量是否满足要求，不满足再进行压缩
    __block NSData *finallImageData = UIImageJPEGRepresentation(sourceImage,1.0);
    NSUInteger sizeOrigin   = finallImageData.length;
    NSUInteger sizeOriginKB = sizeOrigin / 1000;
    
    if (sizeOriginKB <= maxSize) {
        return finallImageData;
    }
    
    //获取原图片宽高比
    CGFloat sourceImageAspectRatio = sourceImage.size.width/sourceImage.size.height;
    //先调整分辨率
    CGSize defaultSize = CGSizeMake(1024, 1024/sourceImageAspectRatio);
    UIImage *newImage = [self newSizeImage:defaultSize image:sourceImage];
    
    finallImageData = UIImageJPEGRepresentation(newImage,1.0);
    
    //保存压缩系数
    NSMutableArray *compressionQualityArr = [NSMutableArray array];
    CGFloat avg   = 1.0/250;
    CGFloat value = avg;
    for (int i = 250; i >= 1; i--) {
        value = i*avg;
        [compressionQualityArr addObject:@(value)];
    }
    
    /*
     调整大小
     说明：压缩系数数组compressionQualityArr是从大到小存储。
     */
    //思路：使用二分法搜索
    finallImageData = [self halfFuntion:compressionQualityArr image:newImage sourceData:finallImageData maxSize:maxSize];
    //如果还是未能压缩到指定大小，则进行降分辨率
    while (finallImageData.length == 0) {
        //每次降100分辨率
        CGFloat reduceWidth = 100.0;
        CGFloat reduceHeight = 100.0/sourceImageAspectRatio;
        if (defaultSize.width-reduceWidth <= 0 || defaultSize.height-reduceHeight <= 0) {
            break;
        }
        defaultSize = CGSizeMake(defaultSize.width-reduceWidth, defaultSize.height-reduceHeight);
        UIImage *image = [self newSizeImage:defaultSize
                                      image:[UIImage imageWithData:UIImageJPEGRepresentation(newImage,[[compressionQualityArr lastObject] floatValue])]];
        finallImageData = [self halfFuntion:compressionQualityArr image:image sourceData:UIImageJPEGRepresentation(image,1.0) maxSize:maxSize];
    }
    return finallImageData;
}


#pragma mark 调整图片分辨率/尺寸（等比例缩放）
- (UIImage *)newSizeImage:(CGSize)size image:(UIImage *)sourceImage {
    CGSize newSize = CGSizeMake(sourceImage.size.width, sourceImage.size.height);
    
    CGFloat tempHeight = newSize.height / size.height;
    CGFloat tempWidth = newSize.width / size.width;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempWidth, sourceImage.size.height / tempWidth);
    } else if (tempHeight > 1.0 && tempWidth < tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempHeight, sourceImage.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [sourceImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark 二分法
- (NSData *)halfFuntion:(NSArray *)arr image:(UIImage *)image sourceData:(NSData *)finallImageData maxSize:(NSInteger)maxSize {
    NSData *tempData = [NSData data];
    NSUInteger start = 0;
    NSUInteger end = arr.count - 1;
    NSUInteger index = 0;
    
    NSUInteger difference = NSIntegerMax;
    while(start <= end) {
        index = start + (end - start)/2;
        
        finallImageData = UIImageJPEGRepresentation(image,[arr[index] floatValue]);
        
        NSUInteger sizeOrigin = finallImageData.length;
        NSUInteger sizeOriginKB = sizeOrigin / 1024;
        NSLog(@"当前降到的质量：%ld", (unsigned long)sizeOriginKB);
        NSLog(@"\nstart：%zd\nend：%zd\nindex：%zd\n压缩系数：%lf", start, end, (unsigned long)index, [arr[index] floatValue]);
        
        if (sizeOriginKB > maxSize) {
            start = index + 1;
        } else if (sizeOriginKB < maxSize) {
            if (maxSize-sizeOriginKB < difference) {
                difference = maxSize-sizeOriginKB;
                tempData = finallImageData;
            }
            if (index<=0) {
                break;
            }
            end = index - 1;
        } else {
            break;
        }
    }
    return tempData;
}

- (void)getVersionName:(NSDictionary *)options callback:(WXModuleKeepAliveCallback)callback
{
    NSString *versionName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    callback(@{@"versionName":versionName},YES);
}




- (void)conventToFormatAddress:(NSDictionary *)options callback:(WXModuleKeepAliveCallback)callback
{
    self.address = [[BFConventToFormatAddressHandle alloc] init];
    CGFloat lat = [options[@"latitude"] floatValue];
    CGFloat lon = [options[@"longitude"] floatValue];
//    lat = 30.24878581;
//    lon = 120.21590169;
    [self.address conventToFormatAddressWithLatitude:lat andLongitude:lon callback:callback];
    
}

- (void)shareFile:(NSDictionary *)options callback:(WXModuleKeepAliveCallback)callback
{
    NSString *filePath = [options[@"filePath"] stringByReplacingOccurrencesOfString:@"_doc" withString:@"doc"];
    filePath = [@"/Pandora/apps/__UNI__3C18621/" stringByAppendingString:filePath];
    filePath = [kLibraryPath stringByAppendingString:filePath];
    
    
    NSInteger code = -1;
    if ([options[@"target"] isEqualToString:@"weixin"]) {
        code =  [self _weixinFileShareWithFilePath:filePath andFileName:options[@"fileName"]];
        callback(@{@"code":@(code)},YES);
        
    }
    else if([options[@"target"] isEqualToString:@"qq"]) {
        code = [self _qqFileShareWithFilePath:filePath andFileName:options[@"fileName"]];
        callback(@{@"code":@(code)},YES);
    }
}

- (void)gotoNotificationSetting:(NSDictionary *)options callback:(WXModuleKeepAliveCallback)callback
{
//    [self _goToPlayVideoByUrl:@"http://hj-images.b0.upaiyun.com/dd/1555296710963"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

- (void)getCacheSize:(NSDictionary *)options callback:(WXModuleKeepAliveCallback)callback
{
    [BFCacheHandle getFileSize:kCachePath completion:^(NSInteger totalSize) {
        callback(@{@"size":@(totalSize)},YES);
    }];
}

- (void)clearCache:(NSDictionary *)options callback:(WXModuleKeepAliveCallback)callback
{
    [BFCacheHandle removeDirectoryPath:kCachePath];
}

- (void)videoCompression:(NSDictionary *)options callback:(WXModuleKeepAliveCallback)callback
{
    
    NSString *srcFilePath = [options[@"srcFilePath"] stringByReplacingOccurrencesOfString:@"_doc" withString:@"doc"];
    
    if ([srcFilePath hasPrefix:@"file://"]) {
        srcFilePath = [options[@"srcFilePath"] stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    }else {
        srcFilePath = [@"/Pandora/apps/__UNI__3C18621/" stringByAppendingString:srcFilePath];
        srcFilePath = [kLibraryPath stringByAppendingString:srcFilePath];
    }
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:srcFilePath])
    {
        callback(@{@"code":@"-1",@"message":@"未找到文件"},YES);
        return;
    }
    self.videoBox = [[WAVideoBox alloc] init];
    [_videoBox clean];
    
    
    [_videoBox appendVideoByPath:srcFilePath];
    _videoBox.ratio = WAVideoExportRatio960x540;
    _videoBox.videoQuality = 1; // 有两种方法可以压缩
    
    NSString *desFilePath = [self _buildVideoFilePath];
    
//    @WeakSelf(self);
    [_videoBox asyncFinishEditByFilePath:desFilePath complete:^(NSError *error) {
        
        if (!error) {
            
            callback(@{@"code":@"0",@"message":@"压缩成功",@"desFilePath":[NSString stringWithFormat:@"file://%@",desFilePath]},YES);
            
        }else {
            callback(@{@"code":@"-1",@"message":@"压缩失败"},YES);
        }
        
    }];
}

- (void)playVideo:(NSDictionary *)options callback:(WXModuleKeepAliveCallback)callback
{
    [self _goToPlayVideoByUrl:options[@"videoPath"]];
}

- (void)_goToPlayVideoByUrl:(NSString *)Url{
    PlayViewController *playVc = [PlayViewController new];
    [playVc loadWithUrl:Url];
    [self _presentViewController:playVc options:nil callback:nil];
}

- (void)location:(NSDictionary *)options callback:(WXModuleKeepAliveCallback)callback
{
    BFLocationVC *locVC = [[BFLocationVC alloc] initWithOptions:options callback:callback];
    [self _presentViewController:locVC options:options callback:callback];
    
    
//    BFNearbyVC *locVC = [[BFNearbyVC alloc] initWithOptions:options callback:callback];
//    [self _presentViewController:locVC options:options callback:callback];
}

- (void)locationPOI:(NSDictionary *)options callback:(WXModuleKeepAliveCallback)callback
{
    BFNearbyVC *locVC = [[BFNearbyVC alloc] initWithOptions:options callback:callback];
    [self _presentViewController:locVC options:options callback:callback];
}

#pragma mark - Internal Method

- (NSString *)_buildVideoFilePath
{
    
   return [kCachePath stringByAppendingString:[NSString stringWithFormat:@"/%f.mp4", [[NSDate date] timeIntervalSinceReferenceDate]]];
    
//    return [NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"%f.mp4", [[NSDate date] timeIntervalSinceReferenceDate]]];
}

- (void)_presentViewController:(UIViewController *)vc options:(NSDictionary *)options callback:(WXModuleKeepAliveCallback)callback
{
    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topRootViewController.presentedViewController)
    {
        topRootViewController = topRootViewController.presentedViewController;
    }
    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:vc];
    [topRootViewController presentViewController:navc animated:YES completion:nil];
}


- (NSInteger)_weixinFileShareWithFilePath:(NSString* )filePath andFileName:(NSString *)fileName
{
    BFWeiXinShareHandle *wxShare = [[BFWeiXinShareHandle alloc] init];
    return [wxShare fileWithFilePath:filePath andFileName:fileName];
}

- (NSInteger)_qqFileShareWithFilePath:(NSString* )filePath andFileName:(NSString *)fileName
{
//    BFQQShareHandle *qqShare = [[BFQQShareHandle alloc] init];
//    return [qqShare fileWithFilePath:filePath andFileName:fileName];

    [self _systemShare:[ NSURL fileURLWithPath:filePath]];
    return 1;
}

-(void)_systemShare:(NSURL *)fileURL
{
    
    [[[BFSystemShareHandle alloc] init] systemShare:fileURL];
    
}

@end
