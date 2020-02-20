//
//  ForthViewE115.h
//  HongQiC229
//
//  Created by 李卓轩 on 2020/1/16.
//  Copyright © 2020 Parry. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ForthViewE115 : UIView<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, copy)void(^push)(NSDictionary *);

@end

NS_ASSUME_NONNULL_END
