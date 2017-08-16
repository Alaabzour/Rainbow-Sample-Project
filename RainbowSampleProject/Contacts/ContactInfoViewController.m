//
//  ContactInfoViewController.m
//  RainbowSampleProject
//
//  Created by Asal Tech on 7/25/17.
//  Copyright © 2017 Asaltech. All rights reserved.
//

#import "ContactInfoViewController.h"
#import "UserInfoTableViewCell.h"
#import "ChatViewController.h"
#import "UserSubInfoTableViewCell.h"
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ContactInfoViewController () <UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate>

@end

@implementation ContactInfoViewController

#pragma mark - Application LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Contat Details";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getContactInforamtion];

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:39.0/255.0 green:129.0/255.0 blue:187.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:kContactsManagerServiceDidUpdateContact object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Managing Contact Method

- (void) getContactInforamtion{
    

    [[ServicesManager sharedInstance].contactsManagerService fetchRemoteContactDetail:_aContact];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetInfo:) name:kContactsManagerServiceDidUpdateContact object:nil];
}

-(void) didGetInfo:(NSNotification *) notification {
    // check if same id
      Contact *contact = (Contact *)[notification.object objectForKey:@"contact"];
    if (_aContact == contact) {
        _aContact = contact;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            
        });
    }
   
   [self.activityIndicator stopAnimating];
}

#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray<EmailAddress *> * emailAdresses = _aContact.emailAddresses;
    NSArray<PhoneNumber *> * phoneNumbers = _aContact.phoneNumbers;
    int addChatCell = _aContact.canChatWith?1:0;
    
    if (_aContact.isBot) {
        return 1 + emailAdresses.count + phoneNumbers.count + addChatCell ;
    }
    return 2 + emailAdresses.count + phoneNumbers.count + addChatCell ;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UITableViewCell *cell;
    
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"ContactsInfoCell";
        
        UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"UserInfoTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        
        cell.contactNameLabel.text = [NSString stringWithFormat:@"%@ %@",_aContact.title? _aContact.title:@"",_aContact.fullName];
        cell.contactJobTitle.text = _aContact.jobTitle;
        cell.contactTitle.text = _aContact.companyName?  _aContact.companyName:@" ";
        cell.statusLabel.text = _aContact.presence.status;
        if (_aContact.photoData != nil) {
             cell.contactImageView.image = [UIImage imageWithData:_aContact.photoData];
        }
        else{
            cell.contactImageView.image = [UIImage imageNamed:@"placeholder"];
        }
        
        if (_aContact.presence.presence) {
            cell.statusLabel.hidden = NO;
            cell.contactStatusLabel.hidden = NO;
            cell.statusLabel.layer.borderColor = [UIColor whiteColor].CGColor;
            NSLog(@"presence :%ld",(long)_aContact.presence.presence);
            
            switch ((long)_aContact.presence.presence) {
                case 0://Unavailable
                    cell.contactStatusLabel.text = @"Unavailable";
                    cell.statusLabel.backgroundColor = [UIColor lightGrayColor];
                    break;
                case 1://Available
                    if (_aContact.isConnectedWithMobile) {
                        cell.contactStatusLabel.text = @"Available on Mobile";
                    }
                    else{
                        cell.contactStatusLabel.text = @"Available";
                    }
                    
                    cell.statusLabel.backgroundColor = [UIColor colorWithRed:97.0/255.0 green:189.0/255.0 blue:80.0/255.0 alpha:1];
                    break;
                    
                case 2://Dot not disturb
                    cell.contactStatusLabel.text = @"Dot not disturb";
                    cell.statusLabel.backgroundColor = [UIColor redColor];
                    break;
                    
                case 3://Busy
                    cell.contactStatusLabel.text = @"Busy";
                    cell.statusLabel.backgroundColor = [UIColor redColor];
                    break;
                case 4://Away
                    cell.contactStatusLabel.text = @"Away";
                    cell.statusLabel.backgroundColor = [UIColor orangeColor];
                    break;
                case 5://Invisible
                    cell.contactStatusLabel.text = @"Invisible";
                    cell.statusLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
                    cell.statusLabel.backgroundColor = [UIColor whiteColor];
                    break;
                    
                    
                default:
                    break;
            }
        }
        else{
            cell.statusLabel.hidden = YES;
            cell.contactStatusLabel.hidden = YES;
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
       
    }
    else{
        static NSString *CellIdentifier = @"ContactsSubInfoCell";
        
        UserSubInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"UserSubInfoTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        NSArray<EmailAddress *> * emailAdresses = _aContact.emailAddresses;
        NSArray<PhoneNumber *> * phoneNumbers = _aContact.phoneNumbers;
        cell.titleTopConstraint.constant = 0;
        [cell.iconButton removeTarget:nil
                                   action:NULL
                         forControlEvents:UIControlEventTouchUpInside];
        cell.titleLabel.textColor = [UIColor colorWithRed:39.0/255.0 green:129.0/255.0 blue:187.0/255.0 alpha:1.0];
        
        if (indexPath.row <= emailAdresses.count ) {
            EmailAddress * currentEmail = [emailAdresses objectAtIndex:indexPath.row -1];
            if (currentEmail.type == 0) {
                cell.titleLabel.text = @"Email- Home";
            }
            else{
                cell.titleLabel.text = @"Email";
            }
            
            cell.iconButton.userInteractionEnabled = YES;
            
            cell.iconButton.tag = indexPath.row - 1;
            
            
            [cell.iconButton addTarget:self action:@selector(sendEmailtapGesture:) forControlEvents:UIControlEventTouchUpInside];
        
            
            cell.subTitleLabel.text = currentEmail.address;
            
            [cell.iconButton setImage:[UIImage imageNamed:@"email-icon"] forState:UIControlStateNormal];
           
        }
        else if ((indexPath.row > emailAdresses.count) && (indexPath.row <= phoneNumbers.count+emailAdresses.count)) {
            PhoneNumber * phoneNumber = [phoneNumbers objectAtIndex:indexPath.row - emailAdresses.count - 1];
            if (phoneNumber.type == 0) {
             
                cell.titleLabel.text = @"Personal phone";
            }
            else if (phoneNumber.type == 1) {
                cell.titleLabel.text = @"Work phone";
            }
            else{
                cell.titleLabel.text = @"Work mobile";
            }
            [cell.iconButton setImage:[UIImage imageNamed:@"call-icon"] forState:UIControlStateNormal];
           
            cell.subTitleLabel.text = phoneNumber.number;
            
            cell.iconButton.tag = indexPath.row - emailAdresses.count - 1;
            
            [cell.iconButton addTarget:self action:@selector(callPhone:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        else if ((indexPath.row > phoneNumbers.count+emailAdresses.count) && !_aContact.isBot){
            if (indexPath.row - (phoneNumbers.count+emailAdresses.count) == 1) {
                if (!_aContact.isInRoster) {
                    if (_aContact.isRainbowUser) {
                        Invitation * invitationStatus = _aContact.sentInvitation;
                        if (invitationStatus.status == 1){
                           cell.titleLabel.text = @"Invitaion sent";
                            cell.titleLabel.textColor = [UIColor colorWithRed:39.0/255.0 green:129.0/255.0 blue:187.0/255.0 alpha:1.0];
                              [cell.iconButton setImage:nil forState:UIControlStateNormal];
                        }
                        else{
                            cell.titleLabel.text = @"Add Contact to my Network";
                            cell.titleLabel.textColor = [UIColor colorWithRed:39.0/255.0 green:129.0/255.0 blue:187.0/255.0 alpha:1.0];
                            [cell.iconButton setImage:[UIImage imageNamed:@"add-contact-icon"] forState:UIControlStateNormal];
                            
                        }
                        
                    }
                    else{
                        Invitation * invitationStatus = _aContact.sentInvitation;
                        if (invitationStatus.status == 1){
                            cell.titleLabel.text = @"Invitaion sent";
                            cell.titleLabel.textColor = [UIColor colorWithRed:39.0/255.0 green:129.0/255.0 blue:187.0/255.0 alpha:1.0];
                            [cell.iconButton setImage:nil forState:UIControlStateNormal];
                        }
                        else{
                            cell.titleLabel.text = @"Invite Contact to Rainbow";
                            cell.titleLabel.textColor = [UIColor colorWithRed:39.0/255.0 green:129.0/255.0 blue:187.0/255.0 alpha:1.0];
                             [cell.iconButton setImage:[UIImage imageNamed:@"add-contact-icon"] forState:UIControlStateNormal];
                            
                        }
                        
                    }
                   
                   
                }
                else{
                    Invitation * invitationStatus = _aContact.sentInvitation;
                    if (invitationStatus.status == 1){
                        cell.titleLabel.text = @"Invitaion sent";
                        cell.titleLabel.textColor = [UIColor colorWithRed:39.0/255.0 green:129.0/255.0 blue:187.0/255.0 alpha:1.0];
                        [cell.iconButton setImage:nil forState:UIControlStateNormal];
                    }
                    else{
                        cell.titleLabel.text = @"Remove Contact from my Network";
                        cell.titleLabel.textColor = [UIColor redColor];
                        
                        [cell.iconButton setImage:[UIImage imageNamed:@"remove-contact-icon"] forState:UIControlStateNormal];
                    }
                    
                    
                }
 
            }
            else{
                cell.titleLabel.text = @"Start Conversation";
                cell.titleLabel.textColor = [UIColor colorWithRed:39.0/255.0 green:129.0/255.0 blue:187.0/255.0 alpha:1.0];
                
                [cell.iconButton setImage:[UIImage imageNamed:@"start-conversation-icon"] forState:UIControlStateNormal];
                
            }
            cell.subTitleLabel.text = @"";
            cell.titleTopConstraint.constant = 16;
            
        }
        else{
            cell.titleLabel.text = @"Start Conversation";
            cell.subTitleLabel.text = @"";
            cell.titleTopConstraint.constant = 16;
            cell.titleLabel.textColor = [UIColor colorWithRed:39.0/255.0 green:129.0/255.0 blue:187.0/255.0 alpha:1.0];
           
            [cell.iconButton setImage:[UIImage imageNamed:@"start-conversation-icon"] forState:UIControlStateNormal];
            
        }
        
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 144;
    }
    return 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray<EmailAddress *> * emailAdresses = _aContact.emailAddresses;
    NSArray<PhoneNumber *> * phoneNumbers = _aContact.phoneNumbers;
    
     if (indexPath.row > phoneNumbers.count+emailAdresses.count){
        if (indexPath.row - (phoneNumbers.count+emailAdresses.count) == 1) {
            if (!_aContact.isInRoster) {
                Invitation * invitationStatus = _aContact.sentInvitation;
                if (invitationStatus.status == 1){
                    // cancel invitation
                }
                else{
                    UIAlertController * alert = [UIAlertController
                                                 alertControllerWithTitle:[NSString stringWithFormat:@"Invite %@",_aContact.fullName]
                                                 message:@"Send an email to invite this contact to join Rainbow?"
                                                 preferredStyle:UIAlertControllerStyleAlert];
                    
                    
                    
                    UIAlertAction* yesButton = [UIAlertAction
                                                actionWithTitle:@"Send Invitaion"
                                                style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * action) {
                                                    // do invite
                                                    [self.activityIndicator startAnimating];
                                                    
                                                    [[ServicesManager sharedInstance].contactsManagerService inviteContact:_aContact];
                                                    
                                                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddContact:) name:kContactsManagerServiceDidAddContact object:nil];
                                                    
                                                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didInviteContact:) name:kContactsManagerServiceDidInviteContact object:nil];
                                                    
                                                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRemoveContact:) name:kContactsManagerServiceDidRemoveContact object:nil];
                                                    
                                                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetInfo:) name: kContactsManagerServiceDidUpdateContact object:nil];
                                                    
                                                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFailedToInviteContact:) name:kContactsManagerServiceDidFailedToInviteContact object:nil];
                                                    
                                                }];
                    
                    UIAlertAction* noButton = [UIAlertAction
                                               actionWithTitle:@"Cancel"
                                               style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                
                                               }];
                    
                    [alert addAction:yesButton];
                    [alert addAction:noButton];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                }
             
                

            }
            else{
               // do delete
                
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:[NSString stringWithFormat:@"Delete %@",_aContact.fullName]
                                             message:@"Are you sure you want to delete this contact from your Network?"
                                             preferredStyle:UIAlertControllerStyleAlert];
                
                
                
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:@"Delete"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                [self.activityIndicator startAnimating];

                                                [[ServicesManager sharedInstance].contactsManagerService removeContactFromMyNetwork:_aContact];
                                                
                                                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRemoveContact:) name:kContactsManagerServiceDidRemoveContact object:nil];
                                                
                                            }];
                
                UIAlertAction* noButton = [UIAlertAction
                                           actionWithTitle:@"Cancel"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action) {
                                              
                                           }];
                
                [alert addAction:yesButton];
                [alert addAction:noButton];
                
                [self presentViewController:alert animated:YES completion:nil];
              
                

            }
            
        }
        else{
            //start conversation
            ChatViewController * viewController = [[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];
            viewController.aContact = _aContact;
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:NO];
            
        }
               
    }
    

}

#pragma mark - call phone number 

- (void) callPhone : (UIButton *) sender {
    NSArray<PhoneNumber *> * phoneNumbers = _aContact.phoneNumbers;
    PhoneNumber * selectedPhoneNumber = [phoneNumbers objectAtIndex:sender.tag];
    NSString *phoneNumber = [@"tel://" stringByAppendingString:selectedPhoneNumber.number];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber] options:@{} completionHandler:^(BOOL success) {
        NSLog(@"Success");
    }];
}

#pragma mark - send Email Methods
- (void) sendEmailtapGesture: (UIImageView *)sender
{

    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc]init];
    
    if ([MFMailComposeViewController canSendMail] && mailComposer) {
        // Email Subject
        NSString *emailTitle = @"Test";
        // Email Content
        NSString *messageBody = @"This is a test message from iOS";
        // To address
        NSArray<EmailAddress *> * emailAdresses = _aContact.emailAddresses;
        EmailAddress * currentEmail = [emailAdresses objectAtIndex:sender.tag];
        NSArray *toRecipents = [NSArray arrayWithObject:currentEmail.address];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
       
    }
   
}


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString * statusMessage;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            statusMessage = @"Mail saved";
            break;
        case MFMailComposeResultSent:
            statusMessage = @"Mail sent";
            break;
        case MFMailComposeResultFailed:
            statusMessage = [NSString stringWithFormat:@"Mail sent failure: %@", [error localizedDescription]];
            break;
        default:
            break;
    }
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    if (statusMessage != nil) {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:nil
                                     message:statusMessage
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        
                                    }];
        
        
        [alert addAction:yesButton];
        
        // show alert
        [self presentViewController:alert animated:YES completion:nil];
    }
   
    
   
}

#pragma mark - Status Methods

-(void) didRemoveContact:(NSNotification *) notification {
    NSLog(@"deleted");
    
       dispatch_async(dispatch_get_main_queue(), ^{
         [self.activityIndicator stopAnimating];
         [self.tableView reloadData];
        
    });
}

-(void) didInviteContact:(NSNotification *) notification {
    NSLog(@"Invited");
   
       dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicator stopAnimating];
            [self.tableView reloadData];
        
    });
}

-(void) didAddContact:(NSNotification *) notification {
    NSLog(@"Added");
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicator stopAnimating];
            [self.tableView reloadData];
        
    });
}


-(void) didFailedToInviteContact:(NSNotification *) notification {
    NSLog(@"failed to add");
 
       dispatch_async(dispatch_get_main_queue(), ^{
           [self.activityIndicator stopAnimating];
           [self.tableView reloadData];
        
    });
}

@end
