//
//  Second115TableViewCell.m
//  HongQiC229
//
//  Created by 李卓轩 on 2020/1/17.
//  Copyright © 2020 Parry. All rights reserved.
//

#import "Second115TableViewCell.h"

@implementation Second115TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)loadWithDic:(NSDictionary *)dic{
    _titleLabel.text = [NSString stringWithFormat:@"%@",dic[@"catname"]];
}
@end
