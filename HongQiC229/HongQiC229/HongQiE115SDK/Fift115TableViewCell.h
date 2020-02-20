//
//  Fift115TableViewCell.h
//  HongQiC229
//
//  Created by 李卓轩 on 2020/1/20.
//  Copyright © 2020 Parry. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Fift115TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
- (void)loadWithData:(NSDictionary *)dic andStr:(NSString *)keyWords;
@end

NS_ASSUME_NONNULL_END
