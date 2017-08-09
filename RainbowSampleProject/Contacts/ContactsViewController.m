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
#import <Rainbow/Rainbow.h>

@interface ContactsViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>{
    NSTimer* timer;
    NSMutableArray * contactsArray;
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
    [self connectToRainbowServer];
    //[self connectToSandboxServer];
    isAllContactsSelected = NO;
    // Do any additional setup after loading the view from its nib.
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
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:39.0/255.0 green:129.0/255.0 blue:187.0/255.0 alpha:1.0];
    
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

}

#pragma mark - segmentedControl Methods

- (UISegmentedControl *) setupSegmentControl {
    NSArray * itemArray = @[@"my Network",@"All"];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(44, 8, [[UIScreen mainScreen]bounds].size.width - 88 , 28);
    segmentedControl.tintColor = [UIColor colorWithRed:39.0/255.0 green:129.0/255.0 blue:187.0/255.0 alpha:1.0];
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
    
    [self.tableView reloadData];
}

#pragma mark - Manage Contacts Methods

- (void) connectToRainbowServer {
     [[ServicesManager sharedInstance].contactsManagerService requestAddressBookAccess];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddContact:) name:kContactsManagerServiceDidAddContact object:nil];//MAbedAlKareem
    
    [[ServicesManager sharedInstance].loginManager setUsername:@"abzour@asaltech.com" andPassword:@"Asal@123"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin:) name:kLoginManagerDidLoginSucceeded object:nil];

    [[ServicesManager sharedInstance].loginManager connect];
    
 
}

- (void) connectToSandboxServer {
    [[ServicesManager sharedInstance].contactsManagerService requestAddressBookAccess];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddContact:) name:kContactsManagerServiceDidAddContact object:nil];
    
    [[ServicesManager sharedInstance].loginManager setUsername:@"abzour@asaltech.com" andPassword:@"Password_123"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin:) name:kLoginManagerDidLoginSucceeded object:nil];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kChangeServerURLNotification object:@{ @"serverURL": @"sandbox.openrainbow.com"}];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[ServicesManager sharedInstance].loginManager connect];
        
    });
}

-(void) didAddContact:(NSNotification *) notification {
    
    [self.activityIndicator stopAnimating];
    Contact *contact = (Contact *)notification.object;
    if(![contactsArray containsObject:contact]){
        if (contact.isInRoster) {
            [contactsArray addObject:contact];
        }
       
    }
    if(![allContactsArray containsObject:contact]){
        if (contact.emailAddresses.count) {
            [allContactsArray addObject:contact];
        }

    }
    
    [self.tableView reloadData];
}

-(void) didLogin:(NSNotification *) notification {
    
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddContact:) name:kContactsManagerServiceDidAddContact object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReciveInvitaion:) name:kContactsManagerServiceDidAddInvitation object:nil];
//    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdadeContact:) name:kContactsManagerServiceDidUpdateContact object:nil];

}


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
        if (contact.emailAddresses.count) {
            [allContactsArray addObject:contact];
        }
        
    }
    else{
        for (int i =0; i < allContactsArray.count; i++) {
            if ([[allContactsArray objectAtIndex:i] isEqual:contact]) {
                if (contact.isInRoster || contact.sentInvitation.status) {
                     [allContactsArray replaceObjectAtIndex:i withObject:contact];
                }
                else{
                    [allContactsArray removeObjectAtIndex:i];
                }
               
                break;
            }
        }
        
    }
    
    [self.activityIndicator stopAnimating];
    [self.tableView reloadData];
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
        if (contactsArray.count) {
            aContact = [contactsArray objectAtIndex:sender.tag];
        }
        
    }
    
    [[ServicesManager sharedInstance].contactsManagerService declineInvitation:aContact.requestedInvitation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDeclineInvitaion:) name:kContactsManagerServiceDidUpdateInvitation object:nil];
    
    
}
-(void) didReciveInvitaion:(NSNotification *) notification {
    NSLog(@"Recive");
    [self.activityIndicator stopAnimating];
    [self.tableView reloadData];
}


-(void) didAcceptInvitaion:(NSNotification *) notification {
    NSLog(@"Accept");
    
    [self.tableView reloadData];
}

-(void) didDeclineInvitaion:(NSNotification *) notification {
    NSLog(@"decline");
    [self.tableView reloadData];
}

-(void) didInviteContact:(NSNotification *) notification {
    NSLog(@"invites");
    [self.activityIndicator stopAnimating];
    
    [self.tableView reloadData];
}

-(void) didFailedToInviteContact:(NSNotification *) notification {
    NSLog(@"failed");
    [self.activityIndicator stopAnimating];
    [self.tableView reloadData];
}

-(void) didRemoveContact:(NSNotification *) notification {
    NSLog(@"deleted");
#warning REMOVE CONTACT!
    Contact * deletedContact = notification.object;
    [allContactsArray removeObject:deletedContact];
    [contactsArray removeObject:deletedContact];
    [self.tableView reloadData];
    [self.activityIndicator stopAnimating];
}

#pragma mark - showContactsInfoMethod

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
            if (allContactsArray.count) {
                aContact = [allContactsArray objectAtIndex:sender.tag];
            }
        }
        else{
            if (contactsArray.count) {
                aContact = [contactsArray objectAtIndex:sender.tag];
            }
        }
        
    }
    
    if (aContact.isRainbowUser) {
        if (aContact.requestedInvitation.status == 1) {
            // accept invitaion
            [[ServicesManager sharedInstance].contactsManagerService acceptInvitation:aContact.requestedInvitation];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAcceptInvitaion:) name:kContactsManagerServiceDidUpdateInvitation object:nil];
            
            
            
        }
        else{
            ContactInfoViewController * viewController = [[ContactInfoViewController alloc]initWithNibName:@"ContactInfoViewController" bundle:nil];
            viewController.aContact = aContact;
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
        
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
            return allContactsArray.count;
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
        }
        else{
            [cell.showInfoButton setTitle:nil forState:UIControlStateNormal];
            [cell.showInfoButton setImage:[UIImage imageNamed:@"contact-info-icon"] forState:UIControlStateNormal];
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
                    cell.statusTextLabel.text = @"Available on Mobile";
                }
                else{
                    cell.statusTextLabel.text = @"Available";
                }
                
                cell.statusLabel.backgroundColor = [UIColor colorWithRed:97.0/255.0 green:189.0/255.0 blue:80.0/255.0 alpha:1];
                break;

            case 2://Dot not disturb
                cell.statusTextLabel.text = @"Dot not disturb";
                cell.statusLabel.backgroundColor = [UIColor redColor];
                break;

            case 3://Busy
                cell.statusTextLabel.text = @"Busy";
                cell.statusLabel.backgroundColor = [UIColor redColor];
                break;
            case 4://Away
                cell.statusTextLabel.text = @"Away";
                cell.statusLabel.backgroundColor = [UIColor orangeColor];
                break;
            case 5://Invisible
                cell.statusTextLabel.text = @"Invisible";
                cell.statusLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
                cell.statusLabel.backgroundColor = [UIColor whiteColor];
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
    
    [cell.showInfoButton addTarget:self action:@selector(showContactsInfoMethod:) forControlEvents:UIControlEventTouchUpInside];
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
    
    return 64;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, 44)];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:[self setupSegmentControl]];
    return view;
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
    
    if (aContact.isRainbowUser) {
        // start conversation with contact
    }
    else{
        ContactInfoViewController * viewController = [[ContactInfoViewController alloc]initWithNibName:@"ContactInfoViewController" bundle:nil];
        viewController.aContact = aContact;
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
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
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
     isSearching = NO;
     searchBar.text = nil;
     [searchBar resignFirstResponder];
     [self.tableView reloadData];
   
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
     [self.activityIndicator stopAnimating];
    
}

- (void) searchContactsListWithSearchedText:(NSString*) searchedText{
   
   
    [[ServicesManager sharedInstance].contactsManagerService searchRemoteContactsWithPattern:searchedText withCompletionHandler:^(NSString *searchPattern, NSArray<Contact *> *foundContacts) {
        contactsSearchResultsArray = [NSMutableArray arrayWithArray:foundContacts];
        [self.tableView reloadData];
         [self.activityIndicator stopAnimating];
    }];
    
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
     [self.activityIndicator stopAnimating];
    [searchBar setShowsCancelButton:NO animated:YES];
   
}

@end
