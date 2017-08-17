//
//  SettingsViewController.m
//  RainbowSampleProject
//
//  Created by Asal Tech on 8/1/17.
//  Copyright © 2017 Asaltech. All rights reserved.
//

#import "SettingsViewController.h"
#import "UserInfoTableViewCell.h"
#import "ContactStatusTableViewCell.h"
#import "SettingsTableViewCell.h"
#import <Rainbow/Rainbow.h>

@interface SettingsViewController () {
    MyUser * currentUser;
    int selectedStatus;
}

@end

@implementation SettingsViewController

#pragma mark - Application LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // navigationController setup
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:39.0/255.0 green:129.0/255.0 blue:187.0/255.0 alpha:1.0];
    self.title = @"Settings";
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    // get myuser
    currentUser = [[ServicesManager sharedInstance] myUser];
    // get myuser status
    selectedStatus = (int)currentUser.contact.presence.presence;
   
   
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"ContactsInfoCell";
        
        UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"UserInfoTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        
        cell.contactNameLabel.text = [NSString stringWithFormat:@"%@ %@",currentUser.contact.title? currentUser.contact.title:@"",currentUser.contact.fullName];
        cell.contactJobTitle.text = currentUser.contact.jobTitle;
        cell.contactTitle.text = currentUser.contact.isRainbowUser? @"Rainbow":@" ";
        cell.statusLabel.text = currentUser.contact.presence.status;
        if (currentUser.contact.photoData != nil) {
            cell.contactImageView.image = [UIImage imageWithData:currentUser.contact.photoData];
        }
        else{
            cell.contactImageView.image = [UIImage imageNamed:@"placeholder"];
        }
        
        if (currentUser.contact.presence.presence) {
            cell.statusLabel.hidden = NO;
            cell.contactStatusLabel.hidden = NO;
            cell.statusLabel.layer.borderColor = [UIColor whiteColor].CGColor;
            
            switch ((int)currentUser.contact.presence.presence) {
                    
                case 1://Available
                    if (currentUser.contact.isConnectedWithMobile) {
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
    else if (indexPath.section == 2) {
        static NSString *CellIdentifier = @"SettingsCell";
        
        SettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"SettingsTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
        
    }
    else if (indexPath.section == 1){
        static NSString *CellIdentifier = @"ContactStatusCell";
        
        ContactStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"ContactStatusTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
       
        
        [cell.onlineStatusButton addTarget:self action:@selector(changeStatus:) forControlEvents:UIControlEventTouchUpInside];
        [cell.awayStatusButton addTarget:self action:@selector(changeStatus:) forControlEvents:UIControlEventTouchUpInside];
        [cell.invisibleStatusButton addTarget:self action:@selector(changeStatus:) forControlEvents:UIControlEventTouchUpInside];
        [cell.notDistrubStatusButton addTarget:self action:@selector(changeStatus:) forControlEvents:UIControlEventTouchUpInside];
        
        
        switch (selectedStatus) {
           
            case 1://Available
                cell.onlineButton.hidden = NO;
                cell.awayButton.hidden = YES;
                cell.invisibleButton.hidden = YES;
                cell.notDistrubButton.hidden = YES;
                break;
                
            case 2://Dot not disturb
                cell.onlineButton.hidden = YES;
                cell.awayButton.hidden = YES;
                cell.invisibleButton.hidden = YES;
                cell.notDistrubButton.hidden = NO;
                break;
                
           
            case 4://Away
                cell.onlineButton.hidden = YES;
                cell.awayButton.hidden = NO;
                cell.invisibleButton.hidden = YES;
                cell.notDistrubButton.hidden = YES;
                break;
            case 5://Invisible
                cell.onlineButton.hidden = YES;
                cell.awayButton.hidden = YES;
                cell.invisibleButton.hidden = NO;
                cell.notDistrubButton.hidden = YES;
                break;
                
                
            default:
                break;
        }

       
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 144;
    }
    else if (indexPath.section == 2) {
        return 44;
    }
    return 202;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0){
        return 0;
    }
    return 22;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    
    return 3;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section != 0){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, 22)];
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10.0, 0.0, tableView.frame.size.width-20, 22)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont systemFontOfSize:12.0];
        if (section == 1) {
             label.text = @"change your presence";
        }
        else{
             label.text = @"Logout from Rainbow";
        }
       
        [view addSubview:label];
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        return view;
        
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     if (indexPath.row == 2) { // do logout from the app
         [self.activityIndicator startAnimating];
        [[ServicesManager sharedInstance].loginManager disconnect];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogout:) name:kLoginManagerDidLogoutSucceeded object:nil];
         
    }
}

-(void) didLogout:(NSNotification *) notification {
    [self.activityIndicator stopAnimating];
    // go to main pages
}

#pragma mark - change User Status 

- (void)changeStatus:(UIButton *)sender
{
    
    selectedStatus = (int)sender.tag;
    switch (sender.tag) {
        case 1:
            [[ServicesManager sharedInstance].contactsManagerService changeMyPresence:[Presence presenceAvailable]];
            break;
        case 4:
            [[ServicesManager sharedInstance].contactsManagerService changeMyPresence:[Presence presenceAway]];
            break;
        case 5:
            [[ServicesManager sharedInstance].contactsManagerService changeMyPresence:[Presence presenceExtendedAway]];
            break;
        case 2:
            [[ServicesManager sharedInstance].contactsManagerService changeMyPresence:[Presence presenceDoNotDistrub]];
            break;
            
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateMyContact:) name:kContactsManagerServiceDidUpdateMyContact object:nil];
 
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityIndicator stopAnimating];
        [self.tableView reloadData];
        
    });
}

-(void) didUpdateMyContact:(NSNotification *) notification {
    
     selectedStatus = (int)currentUser.contact.presence.presence;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityIndicator stopAnimating];
        [self.tableView reloadData];
        
    });
}

@end
