//
//  SharedDataObject.m
//  RainbowSampleProject
//
//  Created by Asal Tech on 8/30/17.
//  Copyright © 2017 Asaltech. All rights reserved.
//

#import "SharedDataObject.h"
#import "ContactsViewController.h"
#import "ConversationsViewController.h"
#import "SettingsViewController.h"
#import "RecentViewController.h"
#import "LoginViewController.h"

@implementation SharedDataObject

+ (void) registerAllRainbowNotifications {
    
    ContactsViewController * contactsViewController = [[ContactsViewController alloc]init];
    
    [[ServicesManager sharedInstance].contactsManagerService requestAddressBookAccess];
    
     [[NSNotificationCenter defaultCenter] addObserver:contactsViewController selector:@selector(didAddContact:) name:kContactsManagerServiceDidAddContact object:nil];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:loginViewController selector:@selector(willLogin:) name:kLoginManagerWillLogin object:nil];
//    
//    
//    [[NSNotificationCenter defaultCenter] addObserver:loginViewController selector:@selector(didLogin:) name:kLoginManagerDidLoginSucceeded object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:loginViewController selector:@selector(failedToConnect:) name:kLoginManagerDidFailedToAuthenticate object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateConversation:) name:kConversationsManagerDidUpdateConversation object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNewMessage:) name:kConversationsManagerDidReceiveNewMessageForConversation object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateConversation:) name:kConversationsManagerDidUpdateConversation object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAckMessageNotification:) name:kConversationsManagerDidAckMessageNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateMessagesUnreadCount:) name:kConversationsManagerDidUpdateMessagesUnreadCount object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCallSuccess:) name:kRTCServiceDidAddCallNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateCall:) name:kRTCServiceDidUpdateCallNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusChanged:) name:kRTCServiceCallStatsNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRemoveCall:) name:kRTCServiceDidRemoveCallNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAllowMicrophone:) name:kRTCServiceDidAllowMicrophoneNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRefuseMicrophone:) name:kRTCServiceDidRefuseMicrophoneNotification object:nil];
//    
   
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReciveInvitaion:) name:kContactsManagerServiceDidAddInvitation object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdadeContact:) name:kContactsManagerServiceDidUpdateContact object:nil];
    
    
}

+ (UITabBarController *) setupTabbarController{
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
    
    
    [tabBarController setViewControllers:[NSArray arrayWithObjects:conversationsNavigationViewController,contactsNavigationViewCntroller,settingsNavigationViewController,nil]];
    
    return tabBarController;
    
}

@end
