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
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:39.0/255.0 green:129.0/255.0 blue:187.0/255.0 alpha:1.0];
    self.title = @"Conversations";
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
   
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
    

    
       cell.conversationNameLabel.text = conversation.peer.displayName;
    if (conversation.lastMessage.isOutgoing) {
         cell.ConversationLastMessageLabel.text = [NSString stringWithFormat:@"You:%@",conversation.lastMessage.body];
    }
    else{
         cell.ConversationLastMessageLabel.text = conversation.lastMessage.body;
    }
    cell.ConversationLastMessageLabel.text = conversation.lastMessage.body;
    if (conversation.lastUpdateDate) {
        cell.conversationTimeLabel.text = [self getFormattedFromDate:conversation.lastUpdateDate];
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
    viewController.aContact = conversation.peer;
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma - mark Retrieving conversation from a contact

- (void) getConversations {
    [self.activityIndicator stopAnimating];
    NSArray<Conversation *> *conversationsArray = [ServicesManager sharedInstance].conversationsManagerService.conversations;
    conversationsMuttableArray = [NSMutableArray arrayWithArray:conversationsArray];
    // when success it invoke which method?
    
    [self.activityIndicator stopAnimating];
}

- (NSString *) getFormattedFromDate : (NSDate *) date {
  
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"YYYY-MM-dd\'T\'HH:mm:ssZZZZZ"];
 
    [dateFormat setDateFormat:@"E, d MMM HH:mm"];
   
    return [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:date]];
}



@end
