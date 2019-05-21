//
//  BFSystemShareHandle.m
//  libWeexAppNative
//
//  Created by 张逸阳 on 2019/4/19.
//  Copyright © 2019 毕方. All rights reserved.
//

#import "BFSystemShareHandle.h"

@implementation BFSystemShareHandle
-(void) systemShare:(NSURL *)fileURL
{
    NSArray *urls=@[fileURL];
    
    
    UIActivityViewController *activituVC=[[UIActivityViewController alloc]initWithActivityItems:urls applicationActivities:nil];
    NSArray *cludeActivitys=@[UIActivityTypePostToFacebook,
                              UIActivityTypePostToTwitter,
                              UIActivityTypePostToWeibo,
                              UIActivityTypePostToVimeo,
                              UIActivityTypeMessage,
                              UIActivityTypeMail,
                              UIActivityTypeCopyToPasteboard,
                              UIActivityTypePrint,
                              UIActivityTypeAssignToContact,
                              UIActivityTypeSaveToCameraRoll,
                              UIActivityTypeAddToReadingList,
                              UIActivityTypePostToFlickr,
                              UIActivityTypePostToTencentWeibo];
    activituVC.excludedActivityTypes=cludeActivitys;
    
    //显示分享窗口
    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topRootViewController.presentedViewController)
    {
        topRootViewController = topRootViewController.presentedViewController;
    }
    [topRootViewController presentViewController:activituVC animated:YES completion:nil];
}
@end
