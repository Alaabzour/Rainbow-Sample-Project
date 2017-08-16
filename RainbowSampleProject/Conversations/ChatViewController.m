//
//  ChatViewController.m
//  RainbowSampleProject
//
//  Created by Asal Tech on 8/6/17.
//  Copyright © 2017 Asaltech. All rights reserved.
//

#import "ChatViewController.h"
#import "MessageTableViewCell.h"
#import <Rainbow/Rainbow.h>
#import "CallViewController.h"

@interface ChatViewController () <UITextViewDelegate>

@end

@implementation ChatViewController {
    NSMutableArray * messagesArray;
    Conversation *conversation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height)];

    messagesArray = [NSMutableArray array];
    
   
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    conversation = [[ServicesManager sharedInstance].conversationsManagerService startConversationWithPeer:_aContact];
//    Conversation *conversation2 = [[ServicesManager sharedInstance].conversationsManagerService getConversationWithPeerJID:_aContact.jid];

    [[ServicesManager sharedInstance].conversationsManagerService markAsReadByMeAllMessageForConversation:conversation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNewMessage:) name:kConversationsManagerDidReceiveNewMessageForConversation object:nil];
    
    [self.MessageTextView becomeFirstResponder];
    
    self.navigationController.navigationBar.barTintColor = [UIColor groupTableViewBackgroundColor];
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Chat";
    titleLabel.tintColor = [UIColor colorWithRed:39.0/255.0 green:129.0/255.0 blue:187.0/255.0 alpha:1.0];
    self.navigationItem.titleView = titleLabel;
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:39.0/255.0 green:129.0/255.0 blue:187.0/255.0 alpha:1.0];
    
  // check if call is available
    
    UIBarButtonItem *callButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"call-not-filled-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(callButtonClicked:)];
    self.navigationItem.rightBarButtonItem = callButton;
  
}

-(void) callButtonClicked:(id)sender {
    CallViewController * viewController = [[CallViewController alloc]initWithNibName:@"CallViewController" bundle:nil];
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
   // viewController.aContact = _aContact;
    [self presentViewController:viewController animated:NO completion:^{
        
    }];
    
}
- (void) didReceiveNewMessage : (NSNotification *) notification {
   
    Conversation * myconversation  = notification.object;
    if (myconversation != nil) {
        [messagesArray addObject:myconversation.lastMessage.body];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:messagesArray.count-1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:rowIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        });

    }
    
}
#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return messagesArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MessageCell";
    
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"MessageTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    if (indexPath.row %2 == 0) {
        cell.MessageImageView.image = [self balloonImageForSending];
    }
    else{
        cell.MessageImageView.image = [self balloonImageForReceiving];
    }
    
    cell.messagebodyLabel.text = [messagesArray objectAtIndex:indexPath.row];
    
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
  
   

    static NSString *CellIdentifier = @"MessageCell";
    
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"MessageTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier ];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }

    CGSize labelSize = (CGSize){cell.messagebodyLabel.frame.size.width, MAXFLOAT};
    CGRect requiredSize = [[messagesArray objectAtIndex:indexPath.row] boundingRectWithSize:labelSize  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: cell.messagebodyLabel.font} context:nil];
    
    return (requiredSize.size.height + 50);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (UIImage *)balloonImageForReceiving
{
    UIImage *bubble = [UIImage imageNamed:@"bubble-receive-icon"];

    UIColor *color = [UIColor colorWithRed:39.0/255.0 green:129.0/255.0 blue:187.0/255.0 alpha:1.0];
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
   
    [[ServicesManager sharedInstance].conversationsManagerService sendMessage:_MessageTextView.text fileAttachment:nil to:conversation completionHandler:^(Message *message, NSError *error) {
        [messagesArray addObject:_MessageTextView.text];
      
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:messagesArray.count-1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:rowIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            _MessageTextView.text = @" ";
            _MessageTextView.textColor = [UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1];
            [self.sendButton setEnabled:NO];
        });
      
      
    } attachmentUploadProgressHandler:^(Message *message, double totalBytesSent, double totalBytesExpectedToSend) {
        NSLog(@"total byte send  : %f",totalBytesSent);
        NSLog(@"total byte expected to send  : %f",totalBytesExpectedToSend);
      
    }];
    
   
}
@end
