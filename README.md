# ALE Rainbow SDK for iOS
---

Welcome to the Alcatel-Lucent Enterprise **Rainbow Software Development Kit for iOS**!

The Alcatel-Lucent Enterprise (ALE) Rainbow Software Development Kit (SDK) is an npm package for connecting your iOS application to Rainbow.



## Preamble
---

Its powerfull APIs enable you to create the best iOS applications that connect to Alcatel-Lucent Enterprise [Rainbow](https://www.openrainbow.com).

This documentation will help you to use it.


## Rainbow developer account
---

Your need a Rainbow **developer** account in order to use the Rainbow SDK for iOS.

Please contact the Rainbow [support](mailto:support@openrainbow.com) team if you need one.


## Install
---

1. Download the framework SDK zip .
2. Unzip and see next steps for which Frameworks to include in to your project.
3. Drag-n-Drop RainbowSDK.framework into your xcode project.
4. Drag-n-Drop WebRTC.framework into your xcode project.


## Configuration
---

- Add in your *info.plist* the following entries : 
    - `UIBackgroundModes` (type Array)
        - `Item 0` (type String)
            - `audio`
    - `NSCameraUsageDescription` (type String) 
        - `a text explaining that you want access to camera`
    - `NSMicrophoneUsageDescription` (type String) 
        - `a text explaining that you want access to  microphone`
    - `NSAppTransportSecurity` (type Dictionary)
        - `NSAllowsArbitraryLoads` (type Boolean) YES
    - `NSContactsUsageDescription` (type String) 
        - `a text explaining that you want access to contacts`
    - `NSPhotoLibraryUsageDescription` (type String) 
        - `a text explaining that you want access to photo library`
    - `NSUserActivityTypes` (type Array)
        - `Item 0` (type String)
            - `INStartAudioCallIntent`

- Disable bitcode :
    - Select your project, select your target, select Build settings, search Enable Bitcode, select NO

- Add RainbowSDK framework and WebRTC framework into embebed binaries
    - Select your project, select your target, select General, drag-n-drop RainbowSDK.framework and WebRTC.framework from Navigator to the Embedded Binaries section.
   
   
## Usage
---

1. Import the Rainbow module in your UIApplicationDelegate subclass:

```objective-c
#import <Rainbow/Rainbow.h>
```

2. Set your username and your password

```objective-c
[[ServicesManager sharedInstance].loginManager setUsername:@"myRainbowUser@domain.com" andPassword:@"MyPassword"];
[[ServicesManager sharedInstance].loginManager connect];
```

3. Monitor login manager notifications

```objective-c
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin:) name:kLoginManagerDidLoginSucceeded object:nil];
-(void) didLogin:(NSNotification *) notification {
  NSLog(@"DID LOGIN");
}
```

This will login to Rainbow offical server , if you want to login to Sandbox server you need to change the server as follow,

```objective-c

 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin:) name:kLoginManagerDidLoginSucceeded object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kChangeServerURLNotification object:@{ @"serverURL": @"you sandbox url"}];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[ServicesManager sharedInstance].loginManager connect];
        
    });
    
```

```objective-c
-(void) didLogin:(NSNotification *) notification {
  NSLog(@"DID LOGIN");
}
```


That's all! Your application should be connected to Rainbow, congratulation!


## Events
---

### Listen to events

Once you have called the `connect()` method, you will begin receiving events from the SDK. If you want to catch them, you have simply to add the following lines to your code:

```objective-c
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin:) name:kLoginManagerDidLoginSucceeded object:nil];

[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFailedToLogin:) name:kLoginManagerDidFailedToAuthenticate object:nil];

```

```objective-c
-(void) didLogin:(NSNotification *) notification {
 // do something when the SDK is ready to be used
  NSLog(@"DID LOGIN");
}
```

```objective-c
-(void) didFailedToLogin:(NSNotification *) notification {
  NSLog(@"DID FAILED TO LOGIN");
}
```

### List of events

Here is the complete list of the events that you can subscribe on:

#### Connection Events

| Name | Description |
|------|------------|
| **`kLoginManagerDidLoginSucceeded`** | Fired when the SDK is connected to Rainbow and ready to be used |
| **`kLoginManagerDidLogoutSucceeded`** | Fired when the SDK has successfully logout from the server |
| **`kLoginManagerDidLostConnection`** | Fired when the SDK lost the connection with Rainbow |
| **`kLoginManagerDidReconnect`** | Fired when the SDK didn't succeed to reconnect |
| **`kLoginManagerDidFailedToAuthenticate`** |Fired when something goes wrong (ie: bad 'configurations' parameter...) |
| **`kLoginManagerDidChangeServer`** | Fired when the message has been received by the server |
| **`kLoginManagerDidChangeUser`** | Fired when the SDK is connected to Sandbox Server |
| **`kLoginManagerTryToReconnect`** | Fired when the SDK tries to reconnect |

#### Contacts Events
| Name | Description |
|------|------------|
| **`kContactsManagerServiceDidAddContact`** | Fired when the SDK has successfully retrieve you contacts |
| **`kContactsManagerServiceDidUpdateContact`** | Fired when the a contact is updated |
| **`kContactsManagerServiceDidRemoveContact`** | Fired when the contact is removed from your contacts list |
| **`kContactsManagerServiceDidInviteContact`** | Fired when you invite contact to Rainbow or add a rainbow user to your contact list |
| **`kContactsManagerServiceDidFailedToInviteContact`** | Fired when the SDK is failed to invite |
| **`kContactsManagerServiceDidUpdateMyContact`** | Fired when you update your information |
| **`kContactsManagerServiceDidChangeContactDisplayUserSettings`** | notification sent when device contact display parameter is changed |
| **`kContactsManagerServiceLocalAccessGrantedNotification`** | Fired when the addressBook access is granted) |
| **`kContactsManagerServiceClickToCallMobile`** |  |
| **`kContactsManagerServiceDidAddInvitation`** | Fired when a new invitation is added (could be a sent or received one) |
| **`kContactsManagerServiceDidUpdateInvitation`** | Fired when  an invitation is updated (status changed) |
| **`kContactsManagerServiceDidRemoveInvitation`** |  |
| **`kContactsManagerServiceDidUpdateInvitationPendingNumber`** |  |
| **`kContactsManagerServiceLocalAccessGrantedNotification`** | Fired when the addressBook access is granted) |

#### Conversation Events

| Name | Description |
|------|------------|
| **`kConversationsManagerDidAddConversation`** | Fired when the SDK has successfully retrieve you conversation |
| **`kConversationsManagerDidRemoveConversation`** | Fired when the you remove a conversation  |
| **`kConversationsManagerDidRemoveAllConversations`** | Fired when the you remove all conversation |
| **`kConversationsManagerDidUpdateConversation`** | Fired when the conversation is updated |
| **`kConversationsManagerDidStartConversation`** | Fired when you start a conversation with contact |
| **`kConversationsManagerDidStopConversation`** | Fired when you stop a conversation with contact |
| **`kConversationsManagerDidReceiveNewMessageForConversation`** | Fired when the conversation receive a new message |
| **`kConversationsManagerDidReceiveComposingMessage`** |  |
| **`kConversationsManagerDidAckMessageNotification`** |  |
| **`kConversationsManagerDidUpdateMessagesUnreadCount`** | Fired when the SDK did update Messages unread count |

#### Audio/Video Call Events

| Name | Description |
|------|------------|
| **`kRTCServiceDidAddCallNotification`** | Fired when the SDK has successfully retrieve or start a call |
| **`kRTCServiceDidUpdateCallNotification`** | Fired when current call status is updated   |
| **`kRTCServiceDidRemoveCallNotification`** | Fired when the you remove current call |
| **`kRTCServiceCallStatsNotification`** | Fired when new stats available for current call |
| **`kRTCServiceDidAllowMicrophoneNotification`** | Fired when you allow Microphone access |
| **`kRTCServiceDidRefuseMicrophoneNotification`** |Fired when you refuse Microphone access |
| **`kConversationsManagerDidReceiveNewMessageForConversation`** | Fired when the conversation receive a new message |
| **`kRTCServiceDidAddLocalVideoTrackNotification`** | Fired when you add local video to call |
| **`kRTCServiceDidRemoveLocalVideoTrackNotification`** | Fired when you remove local video from the call |
| **`kRTCServiceDidAddRemoteVideoTrackNotification`** | Fired when you add remote video to call]
| **`kRTCServiceDidRemoveRemoteVideoTrackNotification`** | Fired when you remove remote video from the call |


## Instant Messaging
---

### Retrieve Conversations
Retrieving all messages done as follow,

```objective-c
 NSArray<Conversation *> *conversationsArray = [ServicesManager sharedInstance].conversationsManagerService.conversations;
 
```
This will show you a list of all conversations you make.

If you want to listen to changes of all conversations you can use this `kConversationsManagerDidUpdateConversation` notification as follow,

```objective-c
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateConversation:) name:kConversationsManagerDidUpdateConversation object:nil];
 
```

```objective-c
 Conversation * updatedConversation = (Conversation *)notification.object;
 // do some thing with this updatedConversation ...
 ...
 
```


### Listen to incoming messages and answer to them

#### Listen to incoming messages

Listening to instant messages that come from other users is very easy. You just have to use the  `kConversationsManagerDidReceiveNewMessageForConversation` event:

```objective-c

 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNewMessage:) name:kConversationsManagerDidReceiveNewMessageForConversation object:nil];
 
 ```
 

```objective-c
 - (void) didReceiveNewMessage : (NSNotification *) notification {
   
    Conversation * receivedConversation  = notification.object;
    //do something with **recivedConversation** object
    
 }
```

#### Sending a new message
You can send a new message to contact as follow ,

```objective-c
 [[ServicesManager sharedInstance].conversationsManagerService sendMessage:@"Message to send" fileAttachment:nil to:conversation completionHandler:^(Message *message, NSError *error) {
        // do something with **message**
        ...
        
        });
      
      
    } attachmentUploadProgressHandler:^(Message *message, double totalBytesSent, double totalBytesExpectedToSend) {
        NSLog(@"total byte send  : %f",totalBytesSent);
        NSLog(@"total byte expected to send  : %f",totalBytesExpectedToSend);
      
    }];
```


### Manually send a 'read' receipt

If you want to mark all messages as read for a conversation you can use `markAsReadByMeAllMessageForConversation` method, as follow,

```objective-c
...
  [[ServicesManager sharedInstance].conversationsManagerService markAsReadByMeAllMessageForConversation:conversation];

```




### Listen to receipts

Receipts allow to know if the message has been successfully delivered to your recipient. Use the ID of your originated message to be able to link with the receipt received.


### Get Conversation History

You can get history for selected conversation, as follow,

```objective-c

// pageSize The maximum number of retrieved .
// preload retreive imediately from the local cache.

 MessagesBrowser *messagesBrowser = [[ServicesManager sharedInstance].conversationsManagerService messagesBrowserForConversation:currentConversation withPageSize:20 preloadMessages:YES];
                        
 messagesBrowser.delegate = self;
            
```

```objective-c
#pragma mark - CKItemsBrowserDelegate
-(void) itemsBrowser:(CKItemsBrowser*)browser didAddCacheItems:(NSArray*)newItems atIndexes:(NSIndexSet*)indexes {

    
    dispatch_async(dispatch_get_main_queue(), ^{
        [messagesArray insertObjects:newItems atIndexes:indexes];
        [self.tableView reloadData];
         NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:messagesArray.count-1 inSection:0];
         [self.tableView scrollToRowAtIndexPath:rowIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];

    });
  
    

}
-(void) itemsBrowser:(CKItemsBrowser*)browser didRemoveCacheItems:(NSArray*)removedItems atIndexes:(NSIndexSet*)indexes{
    NSLog(@"Removed!");
}
-(void) itemsBrowser:(CKItemsBrowser*)browser didUpdateCacheItems:(NSArray*)changedItems atIndexes:(NSIndexSet*)indexes {
    dispatch_async(dispatch_get_main_queue(), ^{
        [messagesArray replaceObjectsAtIndexes:indexes withObjects:changedItems];
        [self.tableView reloadData];
        
    });

 
}

-(void) itemsBrowser:(CKItemsBrowser*)browser didReorderCacheItemsAtIndexes:(NSArray*)oldIndexes toIndexes:(NSArray*)newIndexes {
    NSLog(@"Reorderd!");
}

-(void) itemsBrowser:(CKItemsBrowser*)browser didReceiveItemsAddedEvent:(NSArray*)addedItems{
    
     NSLog(@"ReceivedItemsAdded!");
}

-(void) itemsBrowser:(CKItemsBrowser*)browser didReceiveItemsDeletedEvent:(NSArray*)deletedItems{
    
     NSLog(@"ReceivedItemsDeleted!");
}

-(void) itemsBrowserDidReceivedAllItemsDeletedEvent:(CKItemsBrowser*)browser{
    
     NSLog(@"ReceivedAllItemsDeleted!");
}


```

## Contacts
---

### Retrieve the list of contacts

Once connected, you can retrieve the list of your contact as follow,

```objective-c
 [[ServicesManager sharedInstance].contactsManagerService requestAddressBookAccess];
    
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddContact:) name:kContactsManagerServiceDidAddContact object:nil];
 
```

```objective-c
-(void) didAddContact:(NSNotification *) notification {
 
    Contact *contact = (Contact *)notification.object;
    // add contact object to your contactsArray 
    
}

```

**Note**: `requestAddressBookAccess`  will add your local contact to your contact list, so you can invite them to use Rainbow.

### Retrieve a contact information

Accessing individually an existing contact can be done using the API `fetchRemoteContactDetail:`

```objective-c
  [[ServicesManager sharedInstance].contactsManagerService fetchRemoteContactDetail:_aContact];
    
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetInfo:) name:kContactsManagerServiceDidUpdateContact object:nil];

```

```objective-c
-(void) didGetInfo:(NSNotification *) notification {
     Contact *contact = (Contact *)[notification.object objectForKey:@"contact"];  
}
```


### Searching for a contact by name
You can search for a contact by his name as follow,

```objective-c
[[ServicesManager sharedInstance].contactsManagerService searchRemoteContactsWithPattern:searchedText withCompletionHandler:^(NSString *searchPattern, NSArray<Contact *> *foundContacts) {
       // do something with **foundContacts**
      
    }];
    
```

### Adding the contact to the user network
You can add a Rainbow user to your network or invite a local contact to use Rainbow, by using this notification:`kContactsManagerServiceDidInviteContact` as follow,

```objective-c
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didInviteContact:) name:kContactsManagerServiceDidInviteContact object:nil];
 
```

``` objective-c
-(void) didInviteContact:(NSNotification *) notification {
    NSLog(@"Invited");
}
```

### Removing the contact from the user network
You can remove a contact from your network using this notification:`kContactsManagerServiceDidRemoveContact` as follow,

```objective-c
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRemoveContact:) name:kContactsManagerServiceDidRemoveContact object:nil];
```

```objective-c

-(void) didRemoveContact:(NSNotification *) notification {
    NSLog(@"Removed");
  
}
```
### Listen to contact presence change

When the presence of a contact changes, the following event is fired:

```objective-c
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdadeContact:) name: kContactsManagerServiceDidUpdateContact object:nil];
  
```
```objective-c
-(void) didUpdadeContact:(NSNotification *) notification {
    
    Contact *contact = (Contact *)[notification.object objectForKey:@"contact"];
    // check property **presence**
}

```

The presence and status of a Rainbow user can take several values as described in the following table:

| Presence | Status | Meaning |
|----------------|--------------|---------|
| **`ContactPresenceAvailable`** | | The contact is connected to Rainbow through a desktop application and is available |
| **`ContactPresenceAvailable`** | **mobile** | The contact is connected to Rainbow through a mobile application and is available |
| *`ContactPresenceAway`** | | The contact is connected to Rainbow but hasn't have any activity for several minutes |
| **`ContactPresenceDoNotDisturb`** | | The contact is connected to Rainbow and doesn't want to be disturbed at this time |
| **`ContactPresenceBusy`** | **presentation** | The contact is connected to Rainbow and uses an application in full screen (presentation mode) |
| **`ContactPresenceBusy`** | **phone** | The contact is connected to Rainbow and currently engaged in an audio call (PBX) |
| **`ContactPresenceBusy`** | **audio** | The contact is connected to Rainbow and currently engaged in an audio call (WebRTC) |
| **`ContactPresenceBusy`** | **video** | The contact is connected to Rainbow and currently engaged in a video call (WebRTC) |
| **`ContactPresenceBusy`** | **sharing** | The contact is connected to Rainbow and currently engaged in a screen sharing presentation (WebRTC) |
| **`ContactPresenceInvisible`** | | The contact is not connected to Rainbow |
| **`ContactPresenceUnavailable`** | | The presence of the Rainbow user is not known (not shared with the connected user) |

Notice: With this SDK version, if the contact uses several devices at the same time, only the latest presence information is taken into account.

## Presence

### Change presence manually

The SDK for iOS allows to change the presence of the connected user by calling the following api:

```objective-c

  [[ServicesManager sharedInstance].contactsManagerService changeMyPresence:[Presence presenceAvailable]];

```

The following Methods are supported:

| Presence constant | value | Meaning |
|------------------ | ----- | ------- |
| **`presenceAvailable`** | "online" | The connected user is seen as **available** |
| **`presenceDoNotDistrub`** | "dnd" | The connected user is seen as **do not disturb** |
| **`presenceAway`** | "away" | The connected user is seen as **away** |
| **`presenceExtendedAway`** | "invisible" | The connected user is connected but **seen as offline** |



## Serviceability
---

### Stopping the SDK

At any time, you can stop the connection to Rainbow by calling the API `stop()`. This will stop all services. The only way to reconnect is to call the API `disconnect` again.

```objective-c


```



## Features provided
---
Here is the list of features supported by the Rainbow-iOS-SDK


### Instant Messaging

 - Send and receive One-to-One messages

 - Message Delivery Receipts (received and read)

 - Retrieving or creating a conversation from a contact

 - Listening for a incoming message

### Contacts

 - Get the list of contacts

 - Get contact individually
 
 - Managing contacts updates
 
 - Displaying contact full information
 
 - Searching for a contact by name
 
 - Adding the contact to the user network
 
 - Removing the contact from the user network



### Presence

- Get the presence of contacts

- Set the user connected presence


## Authors
---

## License
---

