//
//  LoginViewController.h
//  RainbowSampleProject
//
//  Created by Asal Tech on 8/8/17.
//  Copyright © 2017 Asaltech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *serverSegmentControl;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
