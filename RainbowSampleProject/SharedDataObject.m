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
#import "CallViewController.h"

@implementation SharedDataObject

+ (void) registerAllRainbowNotifications {
    
    ContactsViewController * contactsViewController = [[ContactsViewController alloc]init];
    CallViewController     * callViewController     = [[CallViewController alloc]init];
    
    // Request Address Book Access
    [[ServicesManager sharedInstance].contactsManagerService requestAddressBookAccess];
    
    // Add Observer for Adding Contacts
    [[NSNotificationCenter defaultCenter] addObserver:contactsViewController selector:@selector(didAddContact:) name:kContactsManagerServiceDidAddContact object:nil];
    // Add Observers for Audio/Video Calls
    [[NSNotificationCenter defaultCenter] addObserver:callViewController selector:@selector(didCallSuccess:) name:kRTCServiceDidAddCallNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:callViewController selector:@selector(didUpdateCall:) name:kRTCServiceDidUpdateCallNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:callViewController selector:@selector(statusChanged:) name:kRTCServiceCallStatsNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:callViewController selector:@selector(didRemoveCall:) name:kRTCServiceDidRemoveCallNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:callViewController selector:@selector(didAllowMicrophone:) name:kRTCServiceDidAllowMicrophoneNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:callViewController selector:@selector(didRefuseMicrophone:) name:kRTCServiceDidRefuseMicrophoneNotification object:nil];
    
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
    
    
    [tabBarController setViewControllers:[NSArray arrayWithObjects:contactsNavigationViewCntroller,conversationsNavigationViewController,settingsNavigationViewController,nil]];
    
    return tabBarController;
    
}

#pragma mark - format date string
+ (NSString *)getItemDateString:(NSDate *)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    NSDateComponents *todayComponent = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    
    NSDateComponents *messageDayComponent = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:-1];
    
    NSDate *yesterdayDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:0];
    
    NSDateComponents *yesterdayComponent = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:yesterdayDate];
    
    
    
    if([todayComponent day] == [messageDayComponent day] &&
       [todayComponent month] == [messageDayComponent month] &&
       [todayComponent year] == [messageDayComponent year] &&
       [todayComponent era] == [messageDayComponent era]) {
        
        [formatter setDateFormat:@"hh:mm aa"];
        return [formatter stringFromDate:date];
    }
    else if([yesterdayComponent day] == [messageDayComponent day] &&
            [yesterdayComponent month] == [messageDayComponent month] &&
            [yesterdayComponent year] == [messageDayComponent year] &&
            [yesterdayComponent era] == [messageDayComponent era]) {
        
        return  @"Yesterday";
    }
    else{
        [formatter setDateFormat:@"E,d MMM"];
        return [formatter stringFromDate:date];
    }
}

+(NSString *)formatTimeFromSeconds:(NSString *)numberOfSeconds
{
    
    int seconds = [numberOfSeconds intValue] % 60;
    int minutes = ([numberOfSeconds intValue] / 60) % 60;
    int hours = [numberOfSeconds intValue] / 3600;
    
    
    if (hours) {
        if (hours == 1) {
            return [NSString stringWithFormat:@"%d hr %02d mins", hours, minutes];
        }
        return [NSString stringWithFormat:@"%d hrs %02d mins", hours, minutes];
    }
    
    if (minutes) {
        if (minutes == 1) {
            
            return [NSString stringWithFormat:@"%d min %02d sec", minutes, seconds];
            
        }
        return [NSString stringWithFormat:@"%d mins %02d sec", minutes, seconds];
    }
    
    if (seconds == 1) {
        return [NSString stringWithFormat:@"%d sec", seconds];
    }
    return [NSString stringWithFormat:@"%d secs", seconds];
}

@end
