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
#import "RecentViewController.h"

@interface LoginViewController () <UITextFieldDelegate>

@end

@implementation LoginViewController{
    int selectedIndex;
    
    NSMutableArray *contactsArray;
    NSMutableArray *allContactsArray;
}
#pragma mark - Application LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
    
    [[ServicesManager sharedInstance].contactsManagerService requestAddressBookAccess];
    
    
    [[ServicesManager sharedInstance].loginManager setUsername:_emailTextField.text andPassword:_passwordTextField.text];
   
    [[ServicesManager sharedInstance].loginManager connect];
    
    
}

- (void) connectToSandboxServer {
  
    
    [[ServicesManager sharedInstance].loginManager setUsername:_emailTextField.text andPassword:_passwordTextField.text];
    

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willLogin:) name:kLoginManagerWillLogin object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin:) name:kLoginManagerDidLoginSucceeded object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failedToConnect:) name:kLoginManagerDidFailedToAuthenticate object:nil];
    
    
    
    if (selectedIndex == 1) {
        [self connectToSandboxServer];
    }
    else{
        [self connectToRainbowServer];
    }
}



-(void) didLogin:(NSNotification *) notification {
   
    // go to main pages
    [self setupTabbarFunction];
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


-(void) willLogin:(NSNotification *) notification {
      
    
}

- (void) getContactFunction{
    
}

- (void) getConversationFunction {
    
}

#pragma mark - setup Functions

- (void) setup {
    
    selectedIndex = 0;
    
    _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIImageView * passwordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,6,8,22)];
    _passwordTextField.leftView = passwordImageView;
    _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView * emailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,6,8,22)];
    _emailTextField.leftView = emailImageView;
    _emailTextField.leftViewMode = UITextFieldViewModeAlways;
    
    contactsArray = [NSMutableArray array];
    allContactsArray = [NSMutableArray array];
    
    // Hide Navigation bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    
    // addObserver for Keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
}

- (void) setupTabbarFunction {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UITabBarController *tabBarController = [[UITabBarController alloc] init];
        
        UIViewController *contactsViewCntroller = [[ContactsViewController alloc] init];
        UINavigationController *contactsNavigationViewCntroller = [[UINavigationController alloc]initWithRootViewController:contactsViewCntroller];
        
        contactsNavigationViewCntroller.tabBarItem.title = CONTACTS ;
        contactsNavigationViewCntroller.tabBarItem.image = [UIImage imageNamed:@"contacts-icon"];
        contactsNavigationViewCntroller.tabBarItem.selectedImage=[UIImage imageNamed:@"contacts-selected-icon"];
        
        UIViewController *conversationsViewController = [[ConversationsViewController alloc] init];
        UINavigationController *conversationsNavigationViewController = [[UINavigationController alloc]initWithRootViewController:conversationsViewController];
        
        conversationsNavigationViewController.tabBarItem.title= CONVERSATIONS ;
        conversationsNavigationViewController.tabBarItem.image = [UIImage imageNamed:@"conversations-icon"];
        conversationsNavigationViewController.tabBarItem.selectedImage=[UIImage imageNamed:@"conversations-selected-icon"];
        
        
        UIViewController *recentsViewController = [[RecentViewController alloc] init];
        UINavigationController *recentsNavigationViewController = [[UINavigationController alloc]initWithRootViewController:recentsViewController];
        
        recentsNavigationViewController.tabBarItem.title= RECENTS ;
        recentsNavigationViewController.tabBarItem.image = [UIImage imageNamed:@"past-not-selected-icon"];
        recentsNavigationViewController.tabBarItem.selectedImage=[UIImage imageNamed:@"past-selected-icon"];
        
        UIViewController *settingsViewController = [[SettingsViewController alloc] init];
        UINavigationController *settingsNavigationViewController = [[UINavigationController alloc]initWithRootViewController:settingsViewController];
        
        settingsNavigationViewController.tabBarItem.title= SETTINGS ;
        settingsNavigationViewController.tabBarItem.image = [UIImage imageNamed:@"settings-icon"];
        settingsNavigationViewController.tabBarItem.selectedImage=[UIImage imageNamed:@"settings-selected-icon"];
        
        
        [tabBarController setViewControllers:[NSArray arrayWithObjects:contactsNavigationViewCntroller,conversationsNavigationViewController,settingsNavigationViewController,nil]];
        
        
        [[UITabBar appearance] setTintColor:APPLICATION_BLUE_COLOR];
        
        
        [SharedDataObject registerAllRainbowNotifications];
        
        
        self.navigationController.navigationBarHidden = YES;
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [[UINavigationBar appearance] setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]];
        [self.activityIndicator stopAnimating];
        [self.navigationController pushViewController:tabBarController animated:YES];

    });
    
   
}


#pragma mark - Reset Passeord Method

- (IBAction)resetPassword:(id)sender {
    
}
@end
