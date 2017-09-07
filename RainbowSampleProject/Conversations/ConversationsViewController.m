;//
//  ConversationsViewController.m
//  RainbowSampleProject
//
//  Created by Asal Tech on 7/24/17.
//  Copyright © 2017 Asaltech. All rights reserved.
//

#import "ConversationsViewController.h"
#import "ConversationTableViewCell.h"
#import "ChatViewController.h"

@interface ConversationsViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>{
    NSMutableArray * conversationsMuttableArray;
    NSArray * conversationsResultArray;
    UISearchBar *searchbar;
    BOOL isSearching;
}

@end

@implementation ConversationsViewController

#pragma mark - Application LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self setup];
    
//      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecieveCall:) name:kRTCServiceDidAddCallNotification object:nil];
    
}

//- (void) didRecieveCall : (NSNotification * ) notification {
//    NSLog(@"%@",notification.object);
//}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = APPLICATION_BLUE_COLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
   
    [self getConversations];
}

- (void) setup {
    
    // setup tabelView
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Add serchbar to Navigationbar
    searchbar = [[UISearchBar alloc] init];
    searchbar.placeholder = @"Conversations...";
    searchbar.delegate = self;
    searchbar.tintColor = [UIColor whiteColor];
    self.navigationItem.titleView = searchbar;
    self.definesPresentationContext = YES;
    isSearching = NO;
    
       
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isSearching) {
        return conversationsResultArray.count;
    }
    return conversationsMuttableArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ConversationCell";
    
    ConversationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"ConversationTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    
    Conversation * conversation;
    
    if (isSearching) {
         conversation  = [conversationsResultArray objectAtIndex:indexPath.row];
    }
    else{
         conversation  = [conversationsMuttableArray objectAtIndex:indexPath.row];
    }
   
    
    if (conversation.type == 1 || conversation.type == 3) { // user or Bot
        
        Contact * contact = (Contact *)conversation.peer ;
        
        cell.conversationNameLabel.text = contact.fullName;
        
        if (contact.photoData) {
            cell.ConversationImageView.image = [UIImage imageWithData:contact.photoData];
        }
        else{
            cell.ConversationImageView.image = [UIImage imageNamed:@"placeholder"];
        }
        
        cell.statusLabel.hidden = NO;
        
        switch (contact.presence.presence) {
                
            case 0://Unavailable
                
                cell.statusLabel.backgroundColor = [UIColor lightGrayColor];
                break;
            case 1://Available
                
                cell.statusLabel.backgroundColor = ONLINE_STATUS_COLOR;
                break;
                
            case 2://Dot not disturb
                
                cell.statusLabel.backgroundColor = BUSY_STATUS_COLOR;
                break;
                
            case 3://Busy
                
                cell.statusLabel.backgroundColor = BUSY_STATUS_COLOR;
                break;
            case 4://Away
                
                cell.statusLabel.backgroundColor = AWAY_STATUS_COLOR;
                break;
            case 5://Invisible
                
                cell.statusLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
                cell.statusLabel.backgroundColor = [UIColor whiteColor];
                break;
                
                
            default:
                break;
        }

        
    }
    else if (conversation.type == 2) { // Room
        Room * room = (Room *)conversation.peer;
        NSLog(@"%@",room);
        cell.ConversationImageView.image = [UIImage imageNamed:@"group-placeholder-icon"];
        cell.conversationNameLabel.text = conversation.peer.displayName;
        cell.statusLabel.hidden = YES;
    }
    

    if (conversation.lastMessage.type == 1 || conversation.lastMessage.type == 2) {
        if (conversation.lastMessage.isOutgoing) {
            cell.ConversationLastMessageLabel.text = [NSString stringWithFormat:@"You: %@",conversation.lastMessage.body];
        }
        else{
            cell.ConversationLastMessageLabel.text = conversation.lastMessage.body;
        }
    }
    else if (conversation.lastMessage.type == 3){
        NSString * text;
        if (conversation.lastMessage.callLog.state == 0) {
            
            
            if (!conversation.lastMessage.callLog.isOutgoing) {
                
                text = @"%@ missed a call from you";
                
            }
            else{
                text = @"You missed a call from %@";
            }
        }
        else if (conversation.lastMessage.callLog.state == 1) {
            
            
            
            if (conversation.lastMessage.callLog.isOutgoing) {
                text = @"You called %@";
            }
            else{
                text = @"%@ called you";
            }
        }
        
        if ([conversation.peer class] == [Contact class]) {
            Contact * contact = (Contact *) conversation.peer;
            cell.ConversationLastMessageLabel.text = [NSString stringWithFormat:text,contact.firstName];
        }
        else if ([conversation.peer class] == [Room class]){
           
            
        }
        
    }
    
   
    
    
    if (conversation.lastUpdateDate) {
        cell.conversationTimeLabel.text = [self getItemDateString:conversation.lastUpdateDate];
    }
    else{
        cell.conversationTimeLabel.text = @"";
    }
    
    if (conversation.unreadMessagesCount == 0) {
        cell.unreadMessagesCountLabel.hidden = YES;
        cell.conversationNameLabel.font = [UIFont systemFontOfSize:16.0];
        cell.ConversationLastMessageLabel.font = [UIFont systemFontOfSize:13.0];
        
    }
    else{
        cell.unreadMessagesCountLabel.hidden = NO;
        cell.unreadMessagesCountLabel.text = [NSString stringWithFormat:@"%li",(long)conversation.unreadMessagesCount];
        cell.conversationNameLabel.font = [UIFont boldSystemFontOfSize:14.0];
        cell.ConversationLastMessageLabel.font = [UIFont boldSystemFontOfSize:13.0];
    }
    
   
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Delete";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 68;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatViewController * viewController = [[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];
    
    Conversation * conversation;
    
    if (isSearching) {
        conversation = [conversationsResultArray objectAtIndex:indexPath.row];
    }
    else{
        conversation = [conversationsMuttableArray objectAtIndex:indexPath.row];
    }
    
    if (conversation.type == 1 || conversation.type == 3) { // user or Bot
        
         viewController.aContact = (Contact *)conversation.peer;
    }
    else if (conversation.type == 2){
         viewController.aContact = (Room *)conversation.peer;
    }
   

   // MessagesBrowser *messages = [[ServicesManager sharedInstance].conversationsManagerService messagesBrowserForConversation:conversation withPageSize:10 preloadMessages:NO];
        
//    [messages resyncBrowsingCacheWithCompletionHandler:^(NSArray *addedCacheItems, NSArray *removedCacheItems, NSArray *updatedCacheItems, NSError *error) {
//        NSLog(@"Done..");
//    }];
//    
//    [messages resyncBrowsingCacheUntilDate:[NSDate date] withCompletionHandler:^(NSArray *addedCacheItems, NSArray *removedCacheItems, NSArray *updatedCacheItems, NSError *error) {
//        NSLog(@"Done..");
//    }];
    
    viewController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:viewController animated:NO];
}



#pragma - mark Retrieving conversation from a contact

- (void) getConversations {
    [self.activityIndicator startAnimating];
    conversationsMuttableArray = [NSMutableArray array];
    NSArray<Conversation *> *conversationsArray = [ServicesManager sharedInstance].conversationsManagerService.conversations;
    conversationsMuttableArray = [self sortArray:[NSMutableArray arrayWithArray:conversationsArray]];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateConversation:) name:kConversationsManagerDidUpdateConversation object:nil];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        NSInteger unreadCount = [ServicesManager sharedInstance].conversationsManagerService.totalNbOfUnreadMessagesInAllConversations;
        if (unreadCount == 0) {
            [[self navigationController] tabBarItem].badgeValue = nil;
        }
        else{
             [[self navigationController] tabBarItem].badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long) unreadCount];
        }
       
       
    });

}

- (void) didUpdateConversation :(NSNotification *) notification {
    
    Conversation * updatedConversation = (Conversation *)notification.object;
    if (updatedConversation != nil) {
        if(![conversationsMuttableArray containsObject:updatedConversation]){
            [conversationsMuttableArray addObject:updatedConversation];
            conversationsMuttableArray = [self sortArray:conversationsMuttableArray];
        }
        else{
            for (int i =0; i < conversationsMuttableArray.count; i++) {
                if ([[conversationsMuttableArray objectAtIndex:i] isEqual:updatedConversation]) {
                    [conversationsMuttableArray replaceObjectAtIndex:i withObject:updatedConversation];
                    conversationsMuttableArray = [self sortArray:conversationsMuttableArray];
                    break;
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            NSInteger unreadCount = [ServicesManager sharedInstance].conversationsManagerService.totalNbOfUnreadMessagesInAllConversations;
            if (unreadCount == 0) {
                [[self navigationController] tabBarItem].badgeValue = nil;
            }
            else{
                 [[self navigationController] tabBarItem].badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long) unreadCount];
            }
            
            [self.activityIndicator stopAnimating];
        });

    }
    
}



- (NSMutableArray *) sortArray : (NSMutableArray *) array {
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                        sortDescriptorWithKey:@"lastUpdateDate"
                                        ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
    NSArray *sortedEventArray = [array
                                 sortedArrayUsingDescriptors:sortDescriptors];
    [self.activityIndicator stopAnimating];
    
    return [NSMutableArray arrayWithArray:sortedEventArray];
}

#pragma mark - format date string
-(NSString *)getItemDateString:(NSDate *)date{
    
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
    
    conversationsResultArray  =  [[ServicesManager sharedInstance].conversationsManagerService searchConversationWithPattern:searchedText];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.activityIndicator stopAnimating];
    });
    
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.activityIndicator stopAnimating];
    [searchBar setShowsCancelButton:NO animated:YES];
    
}


@end
