//
//  ContactsTableViewCell.h
//  RainbowSampleProject
//
//  Created by Asal Tech on 7/23/17.
//  Copyright © 2017 Asaltech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contactImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *showInfoButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoButtonWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *declineButton;
@property (weak, nonatomic) IBOutlet UILabel *statusTextLabel;


@end
