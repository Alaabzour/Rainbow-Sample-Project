//
//  ChatViewController.m
//  RainbowSampleProject
//
//  Created by Asal Tech on 8/6/17.
//  Copyright © 2017 Asaltech. All rights reserved.
//

#import "ChatViewController.h"
#import "MessageTableViewCell.h"
#import "CallViewController.h"
#import "CallTableViewCell.h"
#import <Rainbow/CKItemsBrowser+protected.h>

@interface ChatViewController () <UITextViewDelegate, CKItemsBrowserDelegate>

@end

@implementation ChatViewController {
    NSMutableArray * messagesArray;
    Conversation *currentConversation;
    UIRefreshControl * refreshControl;
    MessagesBrowser *messagesBrowser;
    BOOL isFetchMoreMessages;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height)];

    messagesArray = [NSMutableArray array];
    
    
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [UIColor whiteColor];
    refreshControl.tintColor = [UIColor darkGrayColor];
    [refreshControl addTarget:self
                       action:@selector(handleRefresh:)
                  forControlEvents:UIControlEventValueChanged];
    
    self.tableView.refreshControl = refreshControl;
   
    // Do any additional setup after loading the view from its nib.
}

-(void)handleRefresh : (id)sender
{
    isFetchMoreMessages = YES;
    [messagesBrowser nextPageWithCompletionHandler:^(NSArray *addedCacheItems, NSArray *removedCacheItems, NSArray *updatedCacheItems, NSError *error) {

        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self.tableView reloadData];
            if (addedCacheItems.count) {
                isFetchMoreMessages = NO;
                NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.tableView scrollToRowAtIndexPath:rowIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            }
           
            
        });
        
        [refreshControl endRefreshing];
    }];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNewMessage:) name:kConversationsManagerDidReceiveNewMessageForConversation object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateConversation:) name:kConversationsManagerDidUpdateConversation object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateMessagesUnreadCount:) name:kConversationsManagerDidUpdateMessagesUnreadCount object:nil];
    
    
    // stat conversation
     [[ServicesManager sharedInstance].conversationsManagerService startConversationWithPeer:_aContact withCompletionHandler:^(Conversation *conversation, NSError *error) {
         if (error == nil) {
             currentConversation = conversation;
             
             messagesBrowser = [[ServicesManager sharedInstance].conversationsManagerService messagesBrowserForConversation:currentConversation withPageSize:20 preloadMessages:YES];
             
             
             messagesBrowser.delegate = self;
            
             [messagesBrowser resyncBrowsingCacheWithCompletionHandler:^(NSArray *addedCacheItems, NSArray *removedCacheItems, NSArray *updatedCacheItems, NSError *error) {

             }];
            
             [[ServicesManager sharedInstance].conversationsManagerService markAsReadByMeAllMessageForConversation:currentConversation];

         }
    }];

  
    
    [self.MessageTextView becomeFirstResponder];
    
    self.navigationController.navigationBar.barTintColor = [UIColor groupTableViewBackgroundColor];
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    
    if ([_aContact class] == [Contact class]) {
        Contact * contact = (Contact *) _aContact;
        titleLabel.text = contact.fullName;
    }
    else if ([_aContact class] == [Room class]){
        Room * contact = (Room *) _aContact;
        titleLabel.text = contact.displayName;
    }
    
    titleLabel.tintColor = APPLICATION_BLUE_COLOR;
    self.navigationItem.titleView = titleLabel;
    
    self.navigationController.navigationBar.tintColor = APPLICATION_BLUE_COLOR;
    
  // check if call is available
   
   UIBarButtonItem *callButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"call-not-filled-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(callButtonClicked:)];
   
    
    UIBarButtonItem *videoCallButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"video-not-filled-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(videoCallButtonClicked:)];
    self.navigationItem.rightBarButtonItems = @[videoCallButton,callButton];
    
  
}

-(void) callButtonClicked:(id)sender {
    [self openCallViewControllerWithVideoFalg:NO];
}

-(void) videoCallButtonClicked:(id)sender {
    [self openCallViewControllerWithVideoFalg:YES];
}

-(void) openCallViewControllerWithVideoFalg:(BOOL)isVideo {
    CallViewController * viewController = [[CallViewController alloc]initWithNibName:@"CallViewController" bundle:nil];
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    if ([_aContact class] == [Contact class]) {
        Contact * contact = (Contact *) _aContact;
        viewController.aContact = contact;
        viewController.isVideoCall = isVideo;
        
        [[ServicesManager sharedInstance].rtcService requestMicrophoneAccess];
        
        [[NSNotificationCenter defaultCenter] addObserver:viewController selector:@selector(didCallSuccess:) name:kRTCServiceDidAddCallNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:viewController selector:@selector(didUpdateCall:) name:kRTCServiceDidUpdateCallNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:viewController selector:@selector(statusChanged:) name:kRTCServiceCallStatsNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:viewController selector:@selector(didRemoveCall:) name:kRTCServiceDidRemoveCallNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:viewController selector:@selector(didAllowMicrophone:) name:kRTCServiceDidAllowMicrophoneNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:viewController selector:@selector(didRefuseMicrophone:) name:kRTCServiceDidRefuseMicrophoneNotification object:nil];
        
        
        [self presentViewController:viewController animated:NO completion:^{
            
        }];
    }
    else if ([_aContact class] == [Room class]){
        
        
    }
 
}



- (void) didUpdateMessagesUnreadCount : (NSNotification *) notification {
    
    Conversation * receivedConversation  = notification.object;
    if (receivedConversation != nil) {
       
        
    }
    
}

- (void) didReceiveNewMessage : (NSNotification *) notification {
   
    Conversation * receivedConversation  = notification.object;
    if (receivedConversation != nil) {
        [messagesArray addObject:receivedConversation.lastMessage];
        
        [[ServicesManager sharedInstance].conversationsManagerService markAsReadByMeAllMessageForConversation:currentConversation];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:messagesArray.count-1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:rowIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        });

    }
    
}

- (void) didUpdateConversation : (NSNotification *) notification {
    
    Conversation * receivedConversation  = notification.object;
    if (receivedConversation != nil) {

        
    }
    
}
#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return messagesArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
    UITableViewCell *cell ;
    
    Message *  message = [messagesArray objectAtIndex:indexPath.row];
    
    if (message.type == 2 || message.type == 1) {
        
        static NSString *CellIdentifier = @"MessageCell";
        
        MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"MessageTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        
        cell.dateLabel.text = [self getItemDateString:message.date];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (message.isOutgoing) {
            cell.MessageImageView.image = [self balloonImageForSending];
            [cell.myUserImageView setHidden:NO];
            [cell.contactImageView setHidden:YES];
            cell.messagebodyLabel.textColor = [UIColor darkGrayColor];
            cell.dateLabel.textColor = [UIColor grayColor];
            switch (message.state) {
                    
                case 2:
                    cell.seenImageView.image = [UIImage imageNamed:@"recieved-icon"];
                    break;
                case 3:
                    cell.seenImageView.image = [UIImage imageNamed:@"seen-icon"];
                    break;
                case 4:
                    cell.seenImageView.image = [UIImage imageNamed:@"error-gray-icon"];
                    break;
                    
                default:
                    cell.seenImageView.image = [UIImage imageNamed:@"deliverd-icon"];
                    break;
            }
            
            if ([[ServicesManager sharedInstance] myUser].contact.photoData) {
                cell.myUserImageView.image = [UIImage imageWithData:[[ServicesManager sharedInstance] myUser].contact.photoData];
            }
            else{
                cell.myUserImageView.image = [UIImage imageNamed:@"placeholder"];
            }
        }
        else{
            cell.MessageImageView.image = [self balloonImageForReceiving];
            [cell.myUserImageView setHidden:YES];
            [cell.contactImageView setHidden:NO];
            cell.messagebodyLabel.textColor = [UIColor whiteColor];
            cell.dateLabel.textColor = [UIColor groupTableViewBackgroundColor];
            cell.seenImageView.image = nil;
            
            if ([_aContact class] == [Contact class]) {
                Contact * contact = (Contact *) _aContact;
                if (contact.photoData) {
                    cell.contactImageView.image = [UIImage imageWithData:contact.photoData];
                }
                else{
                    
                }
            }
            else if ([_aContact class] == [Room class]){
                //Room * contact = (Contact *) message.peer;
                
                cell.contactImageView.image = [UIImage imageNamed:@"group-placeholder-icon"];
                
            }
            
           
            
            
        }
        
         cell.messagebodyLabel.text = message.body;
         return cell;

    }
    
 
    else{
        static NSString *CellIdentifier = @"CallCell";
        
        CallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"CallTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString * text;
        
        if (message.callLog.state == 0) {
            
            cell.titleLabel.textColor = [UIColor redColor];
            cell.detailLabel.textColor = [UIColor redColor];
            cell.detailLabel.text = [self getItemDateString:message.callLog.date];
            if (!message.callLog.isOutgoing) {
            
                text = @"%@ missed a call from you";
                
            }
            else{
                text = @"You missed a call from %@";
            }
        }
        else if (message.callLog.state == 1) {
            
            cell.titleLabel.textColor = [UIColor darkGrayColor];
            cell.detailLabel.textColor = [UIColor grayColor];
            cell.detailLabel.text = [self formatTimeFromSeconds:message.callLog.duration];
            
            if (!message.callLog.isOutgoing) {
                text = @"You called %@";
            }
            else{
                text = @"%@ called you";
            }
        }
        
        if ([_aContact class] == [Contact class]) {
            Contact * contact = (Contact *) _aContact;
            cell.titleLabel.text = [NSString stringWithFormat:text,contact.firstName];
        }
        
        [cell.callButton addTarget:self action:@selector(callButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
       
        return cell;

    }
    

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Message *  message = [messagesArray objectAtIndex:indexPath.row];

   
    if (message.type == 2 || message.type == 1) {
        
        static NSString *CellIdentifier = @"MessageCell";
        
        MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"MessageTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier ];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        }
        
        
        CGSize labelSize = (CGSize){cell.messagebodyLabel.frame.size.width, MAXFLOAT};
        CGRect requiredSize = [message.body boundingRectWithSize:labelSize  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: cell.messagebodyLabel.font} context:nil];
        
        return (requiredSize.size.height + 50);
    }
    
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (UIImage *)balloonImageForReceiving
{
    UIImage *bubble = [UIImage imageNamed:@"bubble-receive-icon"];

    UIColor *color = APPLICATION_BLUE_COLOR;
    bubble = [self tintImage:bubble withColor:color];
    return [bubble resizableImageWithCapInsets:UIEdgeInsetsMake(17, 27, 21, 17)];
}

- (UIImage *)balloonImageForSending
{
    UIImage *bubble = [UIImage imageNamed:@"bubble-icon"];
    UIColor *color = [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1.0];
    bubble = [self tintImage:bubble withColor:color];
    return [bubble resizableImageWithCapInsets:UIEdgeInsetsMake(17, 21, 16, 27)];
}

- (UIImage *)tintImage:(UIImage *)image withColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - TextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
   
    return YES;
    
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
  
    
    [self.view endEditing:YES];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
    _MessageTextView.textColor = [UIColor blackColor];
    
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    
}


- (void)textViewDidChange:(UITextView *)textView{
    
    if ([textView.text  length] ==0 ) {
        _MessageTextView.text = @" New Message ...";
        _MessageTextView.textColor = [UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1];
        
        [self.sendButton setEnabled:NO];
       
        _heightConstraint.constant = 44;
       [_MessageTextView resignFirstResponder];
        
        [self.view layoutIfNeeded];
    }
    else{
        
        _MessageTextView.textColor = [UIColor blackColor];
        
        [self.sendButton setEnabled:YES];
        
        UIFont * ft = [UIFont systemFontOfSize:14.0];
        CGSize expectedSize = [textView.text sizeWithAttributes:@{NSFontAttributeName:ft}];
        if (expectedSize.height > 80) {
             _heightConstraint.constant = 100;
        }
        else{
             _heightConstraint.constant = expectedSize.height + 27;
            
        }
       
        
     }

}

- (void)keyboardDidShow:(NSNotification *)notification
{
   
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    int height = MIN(keyboardSize.height,keyboardSize.width);
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.0 animations:^{
            self.containerViewBottomConstraint.constant = height;
            [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height)];
            
        }];
    });
   
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.0 animations:^{
            
            self.containerViewBottomConstraint.constant = 0;
        }];
    });

   
   
}

- (IBAction)showAttachmentMethod:(id)sender {
    
}

- (IBAction)sendMessage:(id)sender {
   
    [[ServicesManager sharedInstance].conversationsManagerService sendMessage:_MessageTextView.text fileAttachment:nil to:currentConversation completionHandler:^(Message *message, NSError *error) {
        [messagesArray addObject:message];
        
        NSInteger idx = [messagesBrowser insertItemAtProperIndex:message];
        [self itemsBrowser:messagesBrowser didAddCacheItems:@[message] atIndexes:[NSIndexSet indexSetWithIndex:idx]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView reloadData];
//            NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:messagesArray.count-1 inSection:0];
//            [self.tableView scrollToRowAtIndexPath:rowIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            _MessageTextView.text = @" ";
            _MessageTextView.textColor = [UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1];
            [self.sendButton setEnabled:NO];
        });
      
      
    } attachmentUploadProgressHandler:^(Message *message, double totalBytesSent, double totalBytesExpectedToSend) {
        NSLog(@"total byte send  : %f",totalBytesSent);
        NSLog(@"total byte expected to send  : %f",totalBytesExpectedToSend);
      
    }];
    
   
}

#pragma mark - CKItemsBrowserDelegate
-(void) itemsBrowser:(CKItemsBrowser*)browser didAddCacheItems:(NSArray*)newItems atIndexes:(NSIndexSet*)indexes {
  
    int count = (int)newItems.count;
    NSMutableArray * reversedArray = [NSMutableArray array];
    for (int i = count -1; i >= 0; i--) {
        [reversedArray addObject:[newItems objectAtIndex:i]];
        
    }
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, reversedArray.count)];
    [messagesArray insertObjects:reversedArray atIndexes:indexSet];
   
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!isFetchMoreMessages) {
            //[self.tableView reloadData];
            //[self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height)];
            [self.tableView reloadData];
            NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:messagesArray.count-1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:rowIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
       

    });
  
    

}
-(void) itemsBrowser:(CKItemsBrowser*)browser didRemoveCacheItems:(NSArray*)removedItems atIndexes:(NSIndexSet*)indexes{
    NSLog(@"Done!");
}
-(void) itemsBrowser:(CKItemsBrowser*)browser didUpdateCacheItems:(NSArray*)changedItems atIndexes:(NSIndexSet*)indexes {
    dispatch_async(dispatch_get_main_queue(), ^{
        [messagesArray replaceObjectsAtIndexes:indexes withObjects:changedItems];
        [self.tableView reloadData];
        
    });

 
}

-(void) itemsBrowser:(CKItemsBrowser*)browser didReorderCacheItemsAtIndexes:(NSArray*)oldIndexes toIndexes:(NSArray*)newIndexes {
    NSLog(@"Done!");
}

-(void) itemsBrowser:(CKItemsBrowser*)browser didReceiveItemsAddedEvent:(NSArray*)addedItems{
    
     NSLog(@"Receive!");
}

-(void) itemsBrowser:(CKItemsBrowser*)browser didReceiveItemsDeletedEvent:(NSArray*)deletedItems{
    
     NSLog(@"Done!");
}

-(void) itemsBrowserDidReceivedAllItemsDeletedEvent:(CKItemsBrowser*)browser{
    
     NSLog(@"Done!");
}

#pragma mark - format  string

-(NSString *)formatTimeFromSeconds:(NSString *)numberOfSeconds
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
        [formatter setDateFormat:@"E, d MMM"];
        return [formatter stringFromDate:date];
    }
}

@end
