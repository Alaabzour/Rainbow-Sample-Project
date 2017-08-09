//
//  ContactStatusTableViewCell.m
//  RainbowSampleProject
//
//  Created by Asal Tech on 8/1/17.
//  Copyright © 2017 Asaltech. All rights reserved.
//

#import "ContactStatusTableViewCell.h"

@implementation ContactStatusTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _onlineStatusLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    _onlineStatusLabel.layer.borderWidth = 2.0;
    _onlineStatusLabel.backgroundColor = [UIColor colorWithRed:97.0/255.0 green:189.0/255.0 blue:80.0/255.0 alpha:1];
    
    _awayStatusLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    _awayStatusLabel.layer.borderWidth = 2.0;
    _awayStatusLabel.backgroundColor = [UIColor orangeColor];
    
    _invisibleStatusLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _invisibleStatusLabel.layer.borderWidth = 2.0;
    _invisibleStatusLabel.backgroundColor = [UIColor whiteColor];
    
    _notDistrubStatusLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    _notDistrubStatusLabel.layer.borderWidth = 2.0;
    _notDistrubStatusLabel.backgroundColor = [UIColor redColor];
    
    _onlineButton.hidden = YES;
    _awayButton.hidden = YES;
    _invisibleButton.hidden = YES;
    _notDistrubButton.hidden = YES;
    
    _onlineStatusButton.tag = 1;
    _awayStatusButton.tag = 4;
    _invisibleStatusButton.tag = 5;
    _notDistrubStatusButton.tag = 2;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
