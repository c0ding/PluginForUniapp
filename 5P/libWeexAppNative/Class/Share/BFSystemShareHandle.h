//
//  BFSystemShareHandle.h
//  libWeexAppNative
//
//  Created by 张逸阳 on 2019/4/19.
//  Copyright © 2019 毕方. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BFSystemShareHandle : NSObject
-(void) systemShare:(NSURL *)fileURL;
@end

NS_ASSUME_NONNULL_END
