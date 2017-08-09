//
//  ContactInfoViewController.h
//  RainbowSampleProject
//
//  Created by Asal Tech on 7/25/17.
//  Copyright © 2017 Asaltech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Rainbow/Rainbow.h>
@interface ContactInfoViewController : UIViewController
@property (nonatomic,weak) Contact* aContact;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end
