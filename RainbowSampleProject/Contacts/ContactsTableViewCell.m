//
//  ContactsTableViewCell.m
//  RainbowSampleProject
//
//  Created by Asal Tech on 7/23/17.
//  Copyright © 2017 Asaltech. All rights reserved.
//

#import "ContactsTableViewCell.h"

@implementation ContactsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _statusLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    _statusLabel.layer.borderWidth = 2.0;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
