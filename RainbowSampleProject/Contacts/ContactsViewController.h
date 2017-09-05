//
//  ContactsViewController.h
//  RainbowSampleProject
//
//  Created by Asal Tech on 7/23/17.
//  Copyright © 2017 Asaltech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UISegmentedControl *contactsSegmentController;

-(void) didAddContact:(NSNotification *) notification;
@end
