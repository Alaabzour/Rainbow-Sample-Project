//
//  ContactsViewController.m
//  RainbowSampleProject
//
//  Created by Asal Tech on 7/23/17.
//  Copyright © 2017 Asaltech. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactsTableViewCell.h"
#import "ContactInfoViewController.h"
#import "ChatViewController.h"
#import "CallViewController.h"


@interface ContactsViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>{
    NSTimer* timer;
    NSMutableArray * contactsArray;
    
    NSMutableArray * invitedcontactsArray;
    NSMutableArray * allContactsArray;
    NSMutableArray * contactsSearchResultsArray;
    UISearchBar *searchbar;
    BOOL isSearching;
    BOOL isAllContactsSelected;
}

@end

@implementation ContactsViewController

#pragma mark -  Application LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
    [self.activityIndicator startAnimating];
   
    isAllContactsSelected = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddContact:) name:kContactsManagerServiceDidAddContact object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReciveInvitaion:) name:kContactsManagerServiceDidAddInvitation object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdadeContact:) name:kContactsManagerServiceDidUpdateContact object:nil];
    
    
    // Do any additional setup after loading the view from its nib.
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = APPLICATION_BLUE_COLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   
     [timer invalidate];
}

- (void) setup {
    
    // setup tabelView
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    // setup navigationbar
    self.navigationController.navigationBar.barTintColor = APPLICATION_BLUE_COLOR;
    
    // Add serchbar to Navigationbar
    searchbar = [[UISearchBar alloc] init];
    searchbar.placeholder = @"People...";
    searchbar.delegate = self;
    searchbar.tintColor = [UIColor whiteColor];
    self.navigationItem.titleView = searchbar;
    self.definesPresentationContext = YES;
    isSearching = NO;
    
    allContactsArray = [NSMutableArray new];
    contactsArray = [NSMutableArray new];
    invitedcontactsArray = [NSMutableArray new];
    
    

}

#pragma mark - segmentedControl Methods

- (UISegmentedControl *) setupSegmentControl {
    NSArray * itemArray = @[@"my Network",@"All"];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(44, 8, [[UIScreen mainScreen]bounds].size.width - 88 , 28);
    segmentedControl.tintColor = APPLICATION_BLUE_COLOR;
    [segmentedControl addTarget:self action:@selector(changeMyContactList:) forControlEvents: UIControlEventValueChanged];
    if (isAllContactsSelected) {
         segmentedControl.selectedSegmentIndex = 1;
    }
    else{
         segmentedControl.selectedSegmentIndex = 0;
    }
   
    return segmentedControl;
}

- (void)changeMyContactList:(UISegmentedControl *)segment
{
    
    if(segment.selectedSegmentIndex == 0)
    {
        isAllContactsSelected = NO;
        
    }
    else{
        isAllContactsSelected = YES;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.activityIndicator stopAnimating];
    });
}

#pragma mark - Manage Contacts Methods

- (void) connectToRainbowServer {
//     [[ServicesManager sharedInstance].contactsManagerService requestAddressBookAccess];
//    
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddContact:) name:kContactsManagerServiceDidAddContact object:nil];
//    
//    [[ServicesManager sharedInstance].loginManager setUsername:@"abzour@asaltech.com" andPassword:@"Asal@123"];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin:) name:kLoginManagerDidLoginSucceeded object:nil];
//
//    [[ServicesManager sharedInstance].loginManager connect];
    
}

- (void) connectToSandboxServer {
//    [[ServicesManager sharedInstance].contactsManagerService requestAddressBookAccess];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddContact:) name:kContactsManagerServiceDidAddContact object:nil];
//    
//    [[ServicesManager sharedInstance].loginManager setUsername:@"MAbedAlKareem@asaltech.com" andPassword:@"Password_123"];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin:) name:kLoginManagerDidLoginSucceeded object:nil];
//    
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:kChangeServerURLNotification object:@{ @"serverURL": @"sandbox.openrainbow.com"}];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [[ServicesManager sharedInstance].loginManager connect];
//        
//    });
    
}

-(void) didAddContact:(NSNotification *) notification {
    
    
    Contact *contact = (Contact *)notification.object;
    if(![contactsArray containsObject:contact]){
        if (contact.isInRoster) {
            [contactsArray addObject:contact];
        }
       
    }
    
    if(![allContactsArray containsObject:contact]){
        if (contact.emailAddresses.count && contact.requestedInvitation.status != 1 && contact.sentInvitation.status != 1) {
            [allContactsArray addObject:contact];
        }
        
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.activityIndicator stopAnimating];
    });
    
}

//-(void) didLogin:(NSNotification *) notification {
//   
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddContact:) name:kContactsManagerServiceDidAddContact object:nil];
//    
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReciveInvitaion:) name:kContactsManagerServiceDidAddInvitation object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdadeContact:) name:kContactsManagerServiceDidUpdateContact object:nil];
//
//}


-(void) didUpdadeContact:(NSNotification *) notification {
    
    Contact *contact = (Contact *)[notification.object objectForKey:@"contact"];
    
    if(![contactsArray containsObject:contact]){
        if (contact.isInRoster) {
            [contactsArray addObject:contact];
        }
    
    }
    
    else{
        for (int i =0; i < contactsArray.count; i++) {
            if ([[contactsArray objectAtIndex:i] isEqual:contact]) {
                if (contact.isInRoster) {
                    
                     [contactsArray replaceObjectAtIndex:i withObject:contact];
                }
                else{
                   
                    [contactsArray removeObjectAtIndex:i];
                }
                
                break;
            }
        }
       
    }
    
    if(![allContactsArray containsObject:contact]){
        if (contact.emailAddresses.count && contact.requestedInvitation.status != 1) {
            [allContactsArray addObject:contact];
        }
        
    }
    
    else{
        for (int i =0; i < allContactsArray.count; i++) {
            if ([[allContactsArray objectAtIndex:i] isEqual:contact]) {
                // check status ..
                
                if (contact.isInRoster && contact.requestedInvitation.status != 1 ) {
                    
                    [allContactsArray replaceObjectAtIndex:i withObject:contact];
                }
                else{
                    
                    [allContactsArray removeObjectAtIndex:i];
                }
                
                break;
            }
        }
        
    }
    
    // remove contact from invitation array when status changes to accepted
   
    if ([invitedcontactsArray containsObject:contact] && contact.requestedInvitation.status != 1) {
        [invitedcontactsArray removeObject:contact];
        
    }
   
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (invitedcontactsArray.count == 0) {
            [[self navigationController] tabBarItem].badgeValue = nil;
        }
        else{
            [[self navigationController] tabBarItem].badgeValue = [NSString stringWithFormat:@"%lu",invitedcontactsArray.count];
        }
        [self.tableView reloadData];
        [self.activityIndicator stopAnimating];
    });
    
    
}

#pragma - mark Manage Invitation

-(void)declineInvitaionMethod:(UIButton *)sender
{
    Contact *aContact;
    if (isSearching == YES) {
        if (contactsSearchResultsArray.count) {
            aContact = [contactsSearchResultsArray objectAtIndex:sender.tag];
        }
        
    }
    else{
        if (invitedcontactsArray.count) {
            aContact = [invitedcontactsArray objectAtIndex:sender.tag];
        }
        
    }
    
    [[ServicesManager sharedInstance].contactsManagerService declineInvitation:aContact.requestedInvitation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDeclineInvitaion:) name:kContactsManagerServiceDidUpdateInvitation object:nil];
    
    
}
-(void) didReciveInvitaion:(NSNotification *) notification {
    NSLog(@"Recive");
    Invitation *invitaion = (Invitation *)notification.object;
    Contact *contact = (Contact *) invitaion.peer;
    if (contact.requestedInvitation.status == 1) {
        if(![invitedcontactsArray containsObject:contact]){
            [invitedcontactsArray addObject:contact];
            
        }
    }
    else{
        if(![allContactsArray containsObject:contact]){
            [allContactsArray addObject:contact];
            
        }
    }
  
   
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (invitedcontactsArray.count == 0) {
            [[self navigationController] tabBarItem].badgeValue = nil;
        }
        else{
            [[self navigationController] tabBarItem].badgeValue = [NSString stringWithFormat:@"%lu",invitedcontactsArray.count];
        }
        
        [self.tableView reloadData];
        [self.activityIndicator stopAnimating];
    });
}


-(void) didAcceptInvitaion:(NSNotification *) notification {
    NSLog(@"Accept");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
       
    });
}



-(void) didDeclineInvitaion:(NSNotification *) notification {
    NSLog(@"decline");
   
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        
    });
}

-(void) didInviteContact:(NSNotification *) notification {
    NSLog(@"invites");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.activityIndicator stopAnimating];
    });
}

-(void) didFailedToInviteContact:(NSNotification *) notification {
    NSLog(@"failed");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.activityIndicator stopAnimating];
    });
}

-(void) didRemoveContact:(NSNotification *) notification {
    NSLog(@"deleted");
    Contact * deletedContact = notification.object;
    [allContactsArray removeObject:deletedContact];
    [contactsArray removeObject:deletedContact];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.activityIndicator stopAnimating];
    });
}

#pragma mark - showContactsInfoMethod
-(void)acceptInvitationMethod:(UIButton *)sender
{
    Contact *aContact;
    if (isSearching == YES) {
        if (contactsSearchResultsArray.count) {
            aContact = [contactsSearchResultsArray objectAtIndex:sender.tag];
        }
        
    }
    else{
        if (invitedcontactsArray.count) {
            aContact = [invitedcontactsArray objectAtIndex:sender.tag];
        }
        
    }
    [[ServicesManager sharedInstance].contactsManagerService acceptInvitation:aContact.requestedInvitation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAcceptInvitaion:) name:kContactsManagerServiceDidUpdateInvitation object:aContact];

}
-(void)showContactsInfoMethod:(UIButton *)sender
{
    
    Contact *aContact;
    if (isSearching == YES) {
        if (contactsSearchResultsArray.count) {
            aContact = [contactsSearchResultsArray objectAtIndex:sender.tag];
        }
        
    }
    else{
        if (isAllContactsSelected) {
           
            aContact = [allContactsArray objectAtIndex:sender.tag];
            
        }
        else{
            if (contactsArray.count) {
                aContact = [contactsArray objectAtIndex:sender.tag];
            }
        }
        
    }
    
    if (aContact.isRainbowUser) {
        
        ContactInfoViewController * viewController = [[ContactInfoViewController alloc]initWithNibName:@"ContactInfoViewController" bundle:nil];
        viewController.aContact = aContact;
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:NO];
        
    }
    else{
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:[NSString stringWithFormat:@"Invite %@",aContact.fullName]
                                     message:@"Send an email to invite this contact to join Rainbow?"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Send Invitaion"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        // do invite
                                        [self.activityIndicator startAnimating];
                                        
                                        
                                        [[ServicesManager sharedInstance].contactsManagerService inviteContact:aContact];
                                        
                                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddContact:) name:kContactsManagerServiceDidAddContact object:nil];
                                        
                                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didInviteContact:) name:kContactsManagerServiceDidInviteContact object:nil];
                                        
                                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRemoveContact:) name:kContactsManagerServiceDidRemoveContact object:nil];
                                        
                                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdadeContact:) name: kContactsManagerServiceDidUpdateContact object:nil];
                                        
                                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFailedToInviteContact:) name:kContactsManagerServiceDidFailedToInviteContact object:nil];
                                        
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle no, thanks button
                                   }];
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
    
    
}


#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isSearching == YES) {
        return contactsSearchResultsArray.count;
    }
    else{
        if (isAllContactsSelected) {
            if (invitedcontactsArray.count) {
                if (section == 0) {
                    return invitedcontactsArray.count; 
                }
                else{
                    return allContactsArray.count;
                }
                
            }
            
            else{
                return allContactsArray.count;
            }
            
        }
         return contactsArray.count;
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ContactsCell";
    
    ContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"ContactsTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
   
    
    cell.declineButton.hidden = YES;
    Contact *aContact;
    if (isSearching == YES) {
        if (contactsSearchResultsArray.count) {
             aContact = [contactsSearchResultsArray objectAtIndex:indexPath.row];
        }
       
    }
    else{
        if (isAllContactsSelected) {
            if (indexPath.section == 0) {
                if (invitedcontactsArray.count){
                    aContact = [invitedcontactsArray objectAtIndex:indexPath.row];
                    
                }
                else{
                    if (allContactsArray.count) {
                        aContact = [allContactsArray objectAtIndex:indexPath.row];
                    }
                }
            }
            else{
                if (allContactsArray.count) {
                    aContact = [allContactsArray objectAtIndex:indexPath.row];
                }
            }
            
        }
        else{
            if (contactsArray.count) {
                aContact = [contactsArray objectAtIndex:indexPath.row];
            }
        }
       
        
    }
   
   
    [cell.showInfoButton removeTarget:nil
                       action:NULL
             forControlEvents:UIControlEventTouchUpInside];
    
    if (aContact.isRainbowUser) {
         cell.infoButtonWidthConstraint.constant = 28;
        cell.statusLabel.hidden = NO;
        [cell.showInfoButton setTitle:nil forState:UIControlStateNormal];
        Invitation * invitationStatus = aContact.sentInvitation;
        if (invitationStatus.status == 1) {
            [cell.showInfoButton setImage:nil forState:UIControlStateNormal];
            [cell.showInfoButton setTitle:@"Pending" forState:UIControlStateNormal];
            cell.infoButtonWidthConstraint.constant = 64;
        }
       
        else if (aContact.requestedInvitation.status == 1) {
            [cell.showInfoButton setTitle:nil forState:UIControlStateNormal];
            [cell.showInfoButton setImage:[UIImage imageNamed:@"accept-icon"] forState:UIControlStateNormal];
            cell.declineButton.hidden = NO;
             [cell.showInfoButton addTarget:self action:@selector(acceptInvitationMethod:) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            [cell.showInfoButton setTitle:nil forState:UIControlStateNormal];
            [cell.showInfoButton setImage:[UIImage imageNamed:@"contact-info-icon"] forState:UIControlStateNormal];
             [cell.showInfoButton addTarget:self action:@selector(showContactsInfoMethod:) forControlEvents:UIControlEventTouchUpInside];
        }
  
    }
    else{
        cell.statusLabel.hidden = YES;
      
        Invitation * invitationStatus = aContact.sentInvitation;
        if (invitationStatus.status == 1) {
             [cell.showInfoButton setTitle:@"Pending" forState:UIControlStateNormal];
        }
        else{
             [cell.showInfoButton setTitle:@"Invite" forState:UIControlStateNormal];
             [cell.showInfoButton addTarget:self action:@selector(showContactsInfoMethod:) forControlEvents:UIControlEventTouchUpInside];
        }
        
       
        [cell.showInfoButton setImage:nil forState:UIControlStateNormal];
        cell.infoButtonWidthConstraint.constant = 44;
    }
    
    cell.contactNameLabel.text = aContact.fullName;
    
    if (aContact.photoData != nil) {
         cell.contactImageView.image = [UIImage imageWithData:aContact.photoData];
    }
    else{
        cell.contactImageView.image = [UIImage imageNamed:@"placeholder"];
    }
    
   
    if (aContact.presence) {
        cell.statusLabel.hidden = NO;
        cell.statusTextLabel.hidden = NO;
        cell.statusLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        NSLog(@"presence :%ld",(long)aContact.presence.presence);
        
        switch ((long)aContact.presence.presence) {
            case 0://Unavailable
                cell.statusTextLabel.text = @"Unavailable";
                cell.statusLabel.backgroundColor = [UIColor lightGrayColor];
                break;
            case 1://Available
                if (aContact.isConnectedWithMobile) {
                   // or check status
                    cell.statusTextLabel.text = @"Available on Mobile";
                    //NSLog(@"t status: %@",aContact.presence.status);
                }
                else{
                    cell.statusTextLabel.text = @"Available";
                }
                
                cell.statusLabel.backgroundColor = ONLINE_STATUS_COLOR;
                break;

            case 2://Dot not disturb
                cell.statusTextLabel.text = @"Dot not disturb";
                cell.statusLabel.backgroundColor = BUSY_STATUS_COLOR;
                break;

            case 3://Busy
                cell.statusTextLabel.text = @"Busy";
                cell.statusLabel.backgroundColor = BUSY_STATUS_COLOR;
                break;
            case 4://Away
                cell.statusTextLabel.text = @"Away";
                cell.statusLabel.backgroundColor = AWAY_STATUS_COLOR;
                break;
            case 5://Invisible
                cell.statusTextLabel.text = @"Invisible";
                cell.statusLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
                cell.statusLabel.backgroundColor = INVISIBLE_STATUS_COLOR;
                break;

                
            default:
                break;
        }
          }
    else{
        cell.statusLabel.hidden = YES;
        cell.statusTextLabel.hidden = YES;
    }
    
   
    cell.showInfoButton.tag = indexPath.row;
    cell.declineButton.tag = indexPath.row;
    
   
    [cell.declineButton addTarget:self action:@selector(declineInvitaionMethod:) forControlEvents:UIControlEventTouchUpInside];
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    Contact *aContact;
    if (isSearching == YES) {
        if (contactsSearchResultsArray.count) {
            aContact = [contactsSearchResultsArray objectAtIndex:indexPath.row];
        }
        
    }
    else{
        if (isAllContactsSelected) {
            if (allContactsArray.count) {
                aContact = [allContactsArray objectAtIndex:indexPath.row];
            }
        }
        else{
            if (contactsArray.count) {
                aContact = [contactsArray objectAtIndex:indexPath.row];
            }
        }
        
        
    }

    Invitation * invitationStatus = aContact.sentInvitation;
    if (invitationStatus.status == 1){
        return YES;
    }
    else{
        return NO;
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Contact *aContact;
        if (isSearching == YES) {
            if (contactsSearchResultsArray.count) {
                aContact = [contactsSearchResultsArray objectAtIndex:indexPath.row];
            }
            
        }
        else{
            if (isAllContactsSelected) {
                if (allContactsArray.count) {
                    aContact = [allContactsArray objectAtIndex:indexPath.row];
                }
            }
            else{
                if (contactsArray.count) {
                    aContact = [contactsArray objectAtIndex:indexPath.row];
                }
            }
            
            
        }

         [self.activityIndicator startAnimating];
        
        [[ServicesManager sharedInstance].contactsManagerService deleteInvitationSentToContact:aContact];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdadeContact:) name: kContactsManagerServiceDidUpdateContact object:nil];
        
    }
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Cancel";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (invitedcontactsArray.count && isAllContactsSelected){
        if (section == 1) {
            return 22;
        }
  
    }
     return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if (isAllContactsSelected && !isSearching) {
        if (invitedcontactsArray.count) {
           return 2;
        }
      
        return 1;
    }
    
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (invitedcontactsArray.count){
        if (section == 0) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, 44)];
            view.backgroundColor = [UIColor whiteColor];
            [view addSubview:[self setupSegmentControl]];
            return view;
        }
        else {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, 44)];
            view.backgroundColor = [UIColor groupTableViewBackgroundColor];
            return view;
        }
       
    }
    else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, 44)];
        view.backgroundColor = [UIColor whiteColor];
        [view addSubview:[self setupSegmentControl]];
        return view;
    }
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Contact *aContact;
   
    if (isSearching == YES) {
        if (contactsSearchResultsArray.count) {
            aContact = [contactsSearchResultsArray objectAtIndex:indexPath.row];
        }
        
    }
    else{
        if (isAllContactsSelected) {
            if (indexPath.section == 0) {
                if (invitedcontactsArray.count){
                    aContact = [invitedcontactsArray objectAtIndex:indexPath.row];
                    
                }
                else{
                    if (allContactsArray.count) {
                        aContact = [allContactsArray objectAtIndex:indexPath.row];
                    }
                }
            }
            else{
                if (allContactsArray.count) {
                    aContact = [allContactsArray objectAtIndex:indexPath.row];
                }
            }
            
        }
        else{
            if (contactsArray.count) {
                aContact = [contactsArray objectAtIndex:indexPath.row];
            }
        }
  
    }
  
    if (aContact.isRainbowUser && aContact.canChatWith) {
         //start conversation with contact
        ChatViewController * viewController = [[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];
        viewController.aContact = aContact;
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:NO];

    }
    else{
        
        ContactInfoViewController * viewController = [[ContactInfoViewController alloc]initWithNibName:@"ContactInfoViewController" bundle:nil];
        viewController.aContact = aContact;
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:NO];
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    isSearching = YES;
    [searchbar setShowsCancelButton:YES animated:YES];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if([searchText length] != 0) {
        isSearching = YES;
        [self.activityIndicator startAnimating];
        [self searchContactsListWithSearchedText:searchText];
        
    }
    else {
        isSearching = NO;

    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.activityIndicator stopAnimating];
    });
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
     isSearching = NO;
     searchBar.text = nil;
     [searchBar resignFirstResponder];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.activityIndicator stopAnimating];
    });
   
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
     [self.activityIndicator stopAnimating];
    
}

- (void) searchContactsListWithSearchedText:(NSString*) searchedText{
   
   
    [[ServicesManager sharedInstance].contactsManagerService searchRemoteContactsWithPattern:searchedText withCompletionHandler:^(NSString *searchPattern, NSArray<Contact *> *foundContacts) {
        dispatch_async(dispatch_get_main_queue(), ^{
            contactsSearchResultsArray = [NSMutableArray arrayWithArray:foundContacts];
            [self.tableView reloadData];
            [self.activityIndicator stopAnimating];
        });
       
      
    }];
    
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
     [self.activityIndicator stopAnimating];
    [searchBar setShowsCancelButton:NO animated:YES];
   
}

@end
