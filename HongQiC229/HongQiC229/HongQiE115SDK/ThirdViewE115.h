//
//  ThirdViewE115.h
//  HongQiC229
//
//  Created by 李卓轩 on 2020/1/16.
//  Copyright © 2020 Parry. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ThirdViewE115 : UIView<UIWebViewDelegate>
@property(nonatomic,  copy)void(^jumpToDetail)(NSDictionary *);

@end

NS_ASSUME_NONNULL_END
