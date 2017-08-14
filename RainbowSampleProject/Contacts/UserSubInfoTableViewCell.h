//
//  UserSubInfoTableViewCell.h
//  RainbowSampleProject
//
//  Created by Asal Tech on 7/26/17.
//  Copyright © 2017 Asaltech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserSubInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *iconButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTopConstraint;

@end
