//
//  ConversationTableViewCell.h
//  RainbowSampleProject
//
//  Created by Asal Tech on 8/6/17.
//  Copyright © 2017 Asaltech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConversationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ConversationImageView;
@property (weak, nonatomic) IBOutlet UILabel *conversationNameLabel
;
@property (weak, nonatomic) IBOutlet UILabel *ConversationLastMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *conversationTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *unreadMessagesCountLabel;

@end
