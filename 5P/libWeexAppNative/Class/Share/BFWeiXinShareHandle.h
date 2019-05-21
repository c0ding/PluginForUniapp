//
//  BFWeiXinShareHandle.h
//  libWeexAppNative
//
//  Created by 张逸阳 on 2019/4/3.
//  Copyright © 2019年 毕方. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BFWeiXinShareHandle : NSObject
- (BOOL)fileWithFilePath:(NSString* )filePath andFileName:(NSString *)fileName;

- (BOOL)webpageWithTitle:(NSString *)title description:(NSString *)description url:(NSString *)url;
@end

NS_ASSUME_NONNULL_END
