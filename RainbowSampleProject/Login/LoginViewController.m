//
//  LoginViewController.m
//  RainbowSampleProject
//
//  Created by Asal Tech on 8/8/17.
//  Copyright © 2017 Asaltech. All rights reserved.
//

#import "LoginViewController.h"
#import <Rainbow/Rainbow.h>
#import "ContactsViewController.h"
#import "ConversationsViewController.h"
#import "SettingsViewController.h"

@interface LoginViewController () <UITextFieldDelegate>

@end

@implementation LoginViewController{
    int selectedIndex;
}
#pragma mark - Application LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void) setup {
    selectedIndex = 0;
    _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIImageView * passwordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,6,8,22)];
   // passwordImageView.image = [UIImage imageNamed:@"password-icon"];
    _passwordTextField.leftView = passwordImageView;
    _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView * emailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,6,8,22)];
   // emailImageView.image = [UIImage imageNamed:@"contacts-selected-icon"];
    _emailTextField.leftView = emailImageView;
    _emailTextField.leftViewMode = UITextFieldViewModeAlways;
  
    
}
#pragma mark - Keyboaed Notification

- (void)keyboardDidShow:(NSNotification *)notification
{
     [self.view layoutIfNeeded];
   
    dispatch_async(dispatch_get_main_queue(), ^{
         [self.view setFrame:CGRectMake(0,-30,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)];
    });
    
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
     [self.view layoutIfNeeded];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view setFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)];
    });
    
    
    
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self.view endEditing:YES];
     return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0){
    [textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
     return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    if (textField == _emailTextField) {
        
        [_passwordTextField becomeFirstResponder];
        
    } else {
        
        [textField resignFirstResponder];
    }
    return NO;
}

#pragma mark - Manage Contacts Methods

- (void) connectToRainbowServer {
   
    [[ServicesManager sharedInstance].loginManager setUsername:_emailTextField.text andPassword:_passwordTextField.text];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin:) name:kLoginManagerDidLoginSucceeded object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failedToConnect:) name:kLoginManagerDidFailedToAuthenticate object:nil];
    
    [[ServicesManager sharedInstance].loginManager connect];
    
    
}

- (void) connectToSandboxServer {
  
    
    [[ServicesManager sharedInstance].loginManager setUsername:_emailTextField.text andPassword:_passwordTextField.text];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin:) name:kLoginManagerDidLoginSucceeded object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failedToConnect:) name:kLoginManagerDidFailedToAuthenticate object:nil];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kChangeServerURLNotification object:@{@"serverURL": @"sandbox.openrainbow.com"}];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[ServicesManager sharedInstance].loginManager connect];
        
    });
}

#pragma mark - UISegmentedControl Method
- (IBAction)changeHostName:(UISegmentedControl *)segment {
    if(segment.selectedSegmentIndex == 0)
    {
        selectedIndex = 0;
        
    }
    else{
        selectedIndex = 1;
    }
    
}

#pragma mark - Login Methods
- (IBAction)doLogin:(id)sender {
    [self.activityIndicator startAnimating];
    if (selectedIndex == 1) {
        [self connectToSandboxServer];
    }
    else{
        [self connectToRainbowServer];
    }
}

-(void) didLogin:(NSNotification *) notification {
    [self.activityIndicator stopAnimating];
    // go to main pages
    [self setupTabbarFunction];
    
  
}

- (void) getContactFunction{
    
}

- (void) getConversationFunction {
    
}

- (void) setupTabbarFunction {
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    UIViewController *contactsViewCntroller = [[ContactsViewController alloc] init];
    UINavigationController *contactsNavigationViewCntroller = [[UINavigationController alloc]initWithRootViewController:contactsViewCntroller];
    
    contactsNavigationViewCntroller.tabBarItem.title = @"Contacts" ;
    contactsNavigationViewCntroller.tabBarItem.image = [UIImage imageNamed:@"contacts-icon"];
    contactsNavigationViewCntroller.tabBarItem.selectedImage=[UIImage imageNamed:@"contacts-selected-icon"];
    
    UIViewController *conversationsViewController = [[ConversationsViewController alloc] init];
    UINavigationController *conversationsNavigationViewController = [[UINavigationController alloc]initWithRootViewController:conversationsViewController];
    
    conversationsNavigationViewController.tabBarItem.title= @"Conversations" ;
    conversationsNavigationViewController.tabBarItem.image = [UIImage imageNamed:@"conversations-icon"];
    conversationsNavigationViewController.tabBarItem.selectedImage=[UIImage imageNamed:@"conversations-selected-icon"];
    
    
    UIViewController *settingsViewController = [[SettingsViewController alloc] init];
    UINavigationController *settingsNavigationViewController = [[UINavigationController alloc]initWithRootViewController:settingsViewController];
    
    settingsNavigationViewController.tabBarItem.title= @"Settings" ;
    settingsNavigationViewController.tabBarItem.image = [UIImage imageNamed:@"settings-icon"];
    settingsNavigationViewController.tabBarItem.selectedImage=[UIImage imageNamed:@"settings-selected-icon"];
    
    
    [tabBarController setViewControllers:[NSArray arrayWithObjects:contactsNavigationViewCntroller,conversationsNavigationViewController,settingsNavigationViewController,nil]];
    
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:39.0/255.0 green:129.0/255.0 blue:187.0/255.0 alpha:1.0]];
    
    [self.navigationController pushViewController:tabBarController animated:YES];
}

-(void) failedToConnect:(NSNotification *) notification {
   
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        dispatch_async(dispatch_get_main_queue(), ^(void){
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:nil
                                         message:@"Email or Password are wrong,Try again!"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"ok"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                             [self.activityIndicator stopAnimating];
                                        }];
            
            
            
            [alert addAction:yesButton];
            
            
            [self presentViewController:alert animated:YES completion:nil];
        });
    });
    
    
    
}

#pragma mark - Reset Passeord Method
- (IBAction)resetPassword:(id)sender {
}
@end
