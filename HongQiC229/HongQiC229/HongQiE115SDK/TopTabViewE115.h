//
//  TopTabViewE115.h
//  HongQiC229
//
//  Created by 李卓轩 on 2020/1/16.
//  Copyright © 2020 Parry. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TopTabViewE115 : UIView
@property (nonatomic, copy)void(^seleced)(NSInteger);
- (void)reset;
@end

NS_ASSUME_NONNULL_END
