//
//  CallTableViewCell.m
//  RainbowSampleProject
//
//  Created by Asal Tech on 9/6/17.
//  Copyright © 2017 Asaltech. All rights reserved.
//

#import "CallTableViewCell.h"

@implementation CallTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _bgView.layer.borderWidth = 0.5;

    // Configure the view for the selected state
}

@end
