//
//  ContactStatusTableViewCell.h
//  RainbowSampleProject
//
//  Created by Asal Tech on 8/1/17.
//  Copyright © 2017 Asaltech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactStatusTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *onlineStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;

@property (weak, nonatomic) IBOutlet UILabel *awayStatusLabel;

@property (weak, nonatomic) IBOutlet UILabel *awayLabel;

@property (weak, nonatomic) IBOutlet UILabel *invisibleStatusLabel;

@property (weak, nonatomic) IBOutlet UILabel *invisibleLabel;

@property (weak, nonatomic) IBOutlet UILabel *notDistrubStatusLabel;

@property (weak, nonatomic) IBOutlet UILabel *notDistrubLabel;

@property (weak, nonatomic) IBOutlet UIButton *onlineButton;
@property (weak, nonatomic) IBOutlet UIButton *awayButton;
@property (weak, nonatomic) IBOutlet UIButton *invisibleButton;
@property (weak, nonatomic) IBOutlet UIButton *notDistrubButton;

@property (weak, nonatomic) IBOutlet UIButton *onlineStatusButton;
@property (weak, nonatomic) IBOutlet UIButton *awayStatusButton;
@property (weak, nonatomic) IBOutlet UIButton *invisibleStatusButton;

@property (weak, nonatomic) IBOutlet UIButton *notDistrubStatusButton;
@end
