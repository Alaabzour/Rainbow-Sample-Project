//
//  ContactInfoViewController.m
//  RainbowSampleProject
//
//  Created by Asal Tech on 7/25/17.
//  Copyright © 2017 Asaltech. All rights reserved.
//

#import "ContactInfoViewController.h"
#import "UserInfoTableViewCell.h"
#import "UserSubInfoTableViewCell.h"

@interface ContactInfoViewController () <UITableViewDelegate,UITableViewDataSource>

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
        [self.tableView reloadData];
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
        cell.contactTitle.text = _aContact.isRainbowUser? @"Rainbow":@" ";
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
        if (indexPath.row <= emailAdresses.count ) {
            EmailAddress * currentEmail = [emailAdresses objectAtIndex:indexPath.row -1];
            if (currentEmail.type == 0) {
                cell.titleLabel.text = @"Email- Home";
            }
            else{
                cell.titleLabel.text = @"Email";
            }
            cell.subTitleLabel.text = currentEmail.address;
            cell.iconImageView.image = [UIImage imageNamed:@"email-icon"];
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
            cell.iconImageView.image = [UIImage imageNamed:@"call-icon"];
            cell.subTitleLabel.text = phoneNumber.number;
        }
        
        else if ((indexPath.row > phoneNumbers.count+emailAdresses.count) && !_aContact.isBot){
            if (indexPath.row - (phoneNumbers.count+emailAdresses.count) == 1) {
                if (!_aContact.isInRoster) {
                    if (_aContact.isRainbowUser) {
                        Invitation * invitationStatus = _aContact.sentInvitation;
                        if (invitationStatus.status == 1){
                           cell.titleLabel.text = @"Invitaion sent";
                            cell.titleLabel.textColor = [UIColor colorWithRed:39.0/255.0 green:129.0/255.0 blue:187.0/255.0 alpha:1.0];
                            cell.iconImageView.image = nil;
                        }
                        else{
                            cell.titleLabel.text = @"Add Contact to my Network";
                            cell.titleLabel.textColor = [UIColor colorWithRed:39.0/255.0 green:129.0/255.0 blue:187.0/255.0 alpha:1.0];
                            cell.iconImageView.image = [UIImage imageNamed:@"add-contact-icon"];
                        }
                        
                    }
                    else{
                        Invitation * invitationStatus = _aContact.sentInvitation;
                        if (invitationStatus.status == 1){
                            cell.titleLabel.text = @"Invitaion sent";
                            cell.titleLabel.textColor = [UIColor colorWithRed:39.0/255.0 green:129.0/255.0 blue:187.0/255.0 alpha:1.0];
                            cell.iconImageView.image = nil;
                        }
                        else{
                            cell.titleLabel.text = @"Invite Contact to Rainbow";
                            cell.titleLabel.textColor = [UIColor colorWithRed:39.0/255.0 green:129.0/255.0 blue:187.0/255.0 alpha:1.0];
                            cell.iconImageView.image = [UIImage imageNamed:@"add-contact-icon"];
                        }
                        
                    }
                   
                   
                }
                else{
                    Invitation * invitationStatus = _aContact.sentInvitation;
                    if (invitationStatus.status == 1){
                        cell.titleLabel.text = @"Invitaion sent";
                        cell.titleLabel.textColor = [UIColor colorWithRed:39.0/255.0 green:129.0/255.0 blue:187.0/255.0 alpha:1.0];
                        cell.iconImageView.image = nil;
                    }
                    else{
                        cell.titleLabel.text = @"Remove Contact from my Network";
                        cell.titleLabel.textColor = [UIColor redColor];
                        cell.iconImageView.image = [UIImage imageNamed:@"remove-contact-icon"];
                    }
                    
                    
                }
 
            }
            else{
                cell.titleLabel.text = @"Start Conversation";
                cell.titleLabel.textColor = [UIColor colorWithRed:39.0/255.0 green:129.0/255.0 blue:187.0/255.0 alpha:1.0];
                cell.iconImageView.image = [UIImage imageNamed:@"start-conversation-icon"];
            }
            cell.subTitleLabel.text = @"";
            cell.titleTopConstraint.constant = 16;
            
        }
        else{
            cell.titleLabel.text = @"Start Conversation";
            cell.subTitleLabel.text = @"";
            cell.titleTopConstraint.constant = 16;
            cell.titleLabel.textColor = [UIColor colorWithRed:39.0/255.0 green:129.0/255.0 blue:187.0/255.0 alpha:1.0];
            cell.iconImageView.image = [UIImage imageNamed:@"start-conversation-icon"];
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
        }
               
    }
    

}

#pragma mark - Status Methods

-(void) didRemoveContact:(NSNotification *) notification {
    NSLog(@"deleted");
    [self.activityIndicator stopAnimating];
    [self.tableView reloadData];
}

-(void) didInviteContact:(NSNotification *) notification {
    NSLog(@"Invited");
    [self.activityIndicator stopAnimating];
    [self.tableView reloadData];
}
-(void) didAddContact:(NSNotification *) notification {
    NSLog(@"Added");
    [self.activityIndicator stopAnimating];
     [self.tableView reloadData];
}


-(void) didFailedToInviteContact:(NSNotification *) notification {
    NSLog(@"failed to add");
    [self.activityIndicator stopAnimating];
    [self.tableView reloadData];
}

@end