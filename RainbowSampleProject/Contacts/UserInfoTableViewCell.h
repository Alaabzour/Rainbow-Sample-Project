//
//  UserInfoTableViewCell.h
//  RainbowSampleProject
//
//  Created by Asal Tech on 7/26/17.
//  Copyright © 2017 Asaltech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contactImageView;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactTitle;
@property (weak, nonatomic) IBOutlet UILabel *contactJobTitle;

@end
