//
//  Second115TableViewCell.h
//  HongQiC229
//
//  Created by 李卓轩 on 2020/1/17.
//  Copyright © 2020 Parry. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Second115TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
- (void)loadWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
