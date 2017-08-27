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
    _onlineStatusLabel.backgroundColor = ONLINE_STATUS_COLOR;
    
    _awayStatusLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    _awayStatusLabel.layer.borderWidth = 2.0;
    _awayStatusLabel.backgroundColor = AWAY_STATUS_COLOR;
    
    _invisibleStatusLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _invisibleStatusLabel.layer.borderWidth = 2.0;
    _invisibleStatusLabel.backgroundColor = INVISIBLE_STATUS_COLOR;
    
    _notDistrubStatusLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    _notDistrubStatusLabel.layer.borderWidth = 2.0;
    _notDistrubStatusLabel.backgroundColor = BUSY_STATUS_COLOR;
    
    _onlineButton.hidden     = YES;
    _awayButton.hidden       = YES;
    _invisibleButton.hidden  = YES;
    _notDistrubButton.hidden = YES;
    
    _onlineStatusButton.tag     = ONLINE_STATUS_TAG;
    _awayStatusButton.tag       = AWAY_STATUS_TAG;
    _invisibleStatusButton.tag  = INVISIBLE_STATUS_TAG;
    _notDistrubStatusButton.tag = BUSY_STATUS_TAG;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
