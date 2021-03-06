//
//  MessageTableViewCell.h
//  RainbowSampleProject
//
//  Created by Asal Tech on 8/6/17.
//  Copyright © 2017 Asaltech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *MessageImageView;
@property (weak, nonatomic) IBOutlet UIImageView *contactImageView;
@property (weak, nonatomic) IBOutlet UILabel *messagebodyLabel;

@property (weak, nonatomic) IBOutlet UIImageView *myUserImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *seenImageView;
@end
