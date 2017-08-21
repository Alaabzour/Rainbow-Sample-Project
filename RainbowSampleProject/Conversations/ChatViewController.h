//
//  ChatViewController.h
//  RainbowSampleProject
//
//  Created by Asal Tech on 8/6/17.
//  Copyright © 2017 Asaltech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Rainbow/Rainbow.h>

@interface ChatViewController : UIViewController
@property (nonatomic,weak) Contact* aContact;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet UITextView *MessageTextView;
@property (weak, nonatomic) IBOutlet UIButton *attachementButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewBottomConstraint;
@end
