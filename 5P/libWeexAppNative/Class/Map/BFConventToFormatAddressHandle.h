//
//  BFConventToFormatAddressHandle.h
//  libWeexAppNative
//
//  Created by 张逸阳 on 2019/4/10.
//  Copyright © 2019年 毕方. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BFConventToFormatAddressHandle : NSObject

typedef void (^AddressBlcok)(id result, BOOL keepAlive);

@property (nonatomic ,copy)AddressBlcok callBlcok;
- ( void)conventToFormatAddressWithLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude callback:(AddressBlcok)callback;
@end

NS_ASSUME_NONNULL_END
