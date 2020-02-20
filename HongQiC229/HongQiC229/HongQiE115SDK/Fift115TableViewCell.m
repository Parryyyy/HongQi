//
//  Fift115TableViewCell.m
//  HongQiC229
//
//  Created by 李卓轩 on 2020/1/20.
//  Copyright © 2020 Parry. All rights reserved.
//

#import "Fift115TableViewCell.h"

@implementation Fift115TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)loadWithData:(NSDictionary *)dic andStr:(NSString *)keyWords{
    NSString *title = [NSString stringWithFormat:@"%@",dic[@"title"]];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
    NSRange range = [title rangeOfString:keyWords];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:158/255.0f green:123/255.0f blue:237/255.0f alpha:1.0f] range:range];
    [_titleLabel setAttributedText:attributedString];
}

@end
