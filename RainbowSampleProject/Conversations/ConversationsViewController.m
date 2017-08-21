;//
//  ConversationsViewController.m
//  RainbowSampleProject
//
//  Created by Asal Tech on 7/24/17.
//  Copyright © 2017 Asaltech. All rights reserved.
//

#import "ConversationsViewController.h"
#import "ConversationTableViewCell.h"
#import <Rainbow/Rainbow.h>
#import "ChatViewController.h"

@interface ConversationsViewController (){
    NSMutableArray * conversationsMuttableArray;
}

@end

@implementation ConversationsViewController

#pragma mark - Application LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = @"Conversations";
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
   
   
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:39.0/255.0 green:129.0/255.0 blue:187.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self getConversations];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return conversationsMuttableArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ConversationCell";
    
    ConversationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"ConversationTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    Conversation * conversation  = [conversationsMuttableArray objectAtIndex:indexPath.row];
    
    if ([conversation.peer class] == [Contact class]) {
        
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
                
                cell.statusLabel.backgroundColor = [UIColor colorWithRed:97.0/255.0 green:189.0/255.0 blue:80.0/255.0 alpha:1];
                break;
                
            case 2://Dot not disturb
                
                cell.statusLabel.backgroundColor = [UIColor redColor];
                break;
                
            case 3://Busy
                
                cell.statusLabel.backgroundColor = [UIColor redColor];
                break;
            case 4://Away
                
                cell.statusLabel.backgroundColor = [UIColor orangeColor];
                break;
            case 5://Invisible
                
                cell.statusLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
                cell.statusLabel.backgroundColor = [UIColor whiteColor];
                break;
                
                
            default:
                break;
        }

        
    }
    else if ([conversation.peer class] == [Room class]) {
        Room * room = (Room *)conversation.peer;
        NSLog(@"%@",room);
        cell.ConversationImageView.image = [UIImage imageNamed:@"group-placeholder-icon"];
        cell.conversationNameLabel.text = conversation.peer.displayName;
        cell.statusLabel.hidden = YES;
    }

    
    
    if (conversation.lastMessage.isOutgoing) {
         cell.ConversationLastMessageLabel.text = [NSString stringWithFormat:@"You: %@",conversation.lastMessage.body];
    }
    else{
         cell.ConversationLastMessageLabel.text = conversation.lastMessage.body;
    }
    
    
    if (conversation.lastUpdateDate) {
        cell.conversationTimeLabel.text = [self getItemDateString:conversation.lastUpdateDate];
    }
    else{
        cell.conversationTimeLabel.text = @"";
    }
    
    if (conversation.unreadMessagesCount == 0) {
        cell.unreadMessagesCountLabel.hidden = YES;
    }
    else{
        cell.unreadMessagesCountLabel.hidden = NO;
        cell.unreadMessagesCountLabel.text = [NSString stringWithFormat:@"%li",(long)conversation.unreadMessagesCount];
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
    
    return 64;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatViewController * viewController = [[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];
    Conversation * conversation = [conversationsMuttableArray objectAtIndex:indexPath.row];
    viewController.aContact = (Contact *)conversation.peer;
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:NO];
}

#pragma - mark Retrieving conversation from a contact

- (void) getConversations {
    [self.activityIndicator stopAnimating];
    conversationsMuttableArray = [NSMutableArray array];
    NSArray<Conversation *> *conversationsArray = [ServicesManager sharedInstance].conversationsManagerService.conversations;
    conversationsMuttableArray = [self sortArray:[NSMutableArray arrayWithArray:conversationsArray]];
    // when success it invoke which method?
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateConversation:) name:kConversationsManagerDidUpdateConversation object:nil];
    
    [self.activityIndicator stopAnimating];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [[self navigationController] tabBarItem].badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)[ServicesManager sharedInstance].conversationsManagerService.totalNbOfUnreadMessagesInAllConversations];
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
            [[self navigationController] tabBarItem].badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)[ServicesManager sharedInstance].conversationsManagerService.totalNbOfUnreadMessagesInAllConversations];
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
        
        [formatter setDateFormat:@"HH:mm"];
        return [formatter stringFromDate:date];
    }
    else if([yesterdayComponent day] == [messageDayComponent day] &&
            [yesterdayComponent month] == [messageDayComponent month] &&
            [yesterdayComponent year] == [messageDayComponent year] &&
            [yesterdayComponent era] == [messageDayComponent era]) {
        
        return  @"Yesterday";
    }
    else{
        [formatter setDateFormat:@"E, d MMM"];
        return [formatter stringFromDate:date];
    }
}


@end
