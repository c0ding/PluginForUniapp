//
//  UITableView+BFEmptyData.h
//  libWeexAppNative
//
//  Created by 张逸阳 on 2019/4/16.
//  Copyright © 2019年 毕方. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (BFEmptyData)
- (void) tableViewDisplayWitMsg:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount;

@end

NS_ASSUME_NONNULL_END
