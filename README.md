# ALE Rainbow SDK for iOS
---

Welcome to the Alcatel-Lucent Enterprise **Rainbow Software Development Kit for iOS**!

The Alcatel-Lucent Enterprise (ALE) Rainbow Software Development Kit (SDK) is an npm package for connecting your iOS application to Rainbow.



## Preamble
---

Its powerfull APIs enable you to create the best iOS applications that connect to Alcatel-Lucent Enterprise [Rainbow](https://www.openrainbow.com).

This documentation will help you to use it.


## Rainbow developper account
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


## Instant Messaging
---

### Listen to incoming messages and answer to them

Listening to instant messages that come from other users is very easy. You just have to use the `events` public property and to subscribe to the `rainbow_onmessagereceived` event:

```js

...
rainbowSDK.events.on('rainbow_onmessagereceived', function(message) {
    // test if the message comes from a bubble of from a conversation with one participant
    if(message.type == "groupchat") {
        // Send the answer to the bubble
        messageSent = rainbowSDK.im.sendMessageToBubbleJid('The message answer', message.fromBubbleJid);
    }
    else {
        // send the answer to the user directly otherwise
        messageSent = rainbowSDK.im.sendMessageToJid('The message answer', message.fromJid);
    }
});

```

### Managing additionnal content

You can add extra content when sending a message to a user:

- Define the language of the message

- Define an additionnal text format

- Define a subject

Modify your code like in the following to add extra content:


```js

...
// Send a message in English to a user with a markdown format and a subject
messageSent = rainbowSDK.im.sendMessageToJid('A message', user.jid, "en", {"type": "text/markdown", "message": "**A message**"}, "My Title");

// Send a message in English to a bubble with a markdown format and a subject
messageSent = rainbowSDK.im.sendMessageToBubbleJid('A message for a bubble', bubble.jid, "en", {"type": "text/markdown", "message": "**A message** for a _bubble_"}, "My ‡Title");

```


### Manually send a 'read' receipt

By default or if the `sendReadReceipt` property is not set, the 'read' receipt is sent automatically to the sender when the message is received so than the sender knows that the message as been read.

If you want to send it manually  when you want, you have to set this parameter to false and use the method `markMessageAsRead()`

```js

...
rainbowSDK.events.on('rainbow_onmessagereceived', function(message) {
    // do something with the message received 
    ...
    // send manually a 'read' receipt to the sender
    rainbowSDK.im.markMessageAsRead(message);
});

```

Notice: You not have to send receipt for message having the property `isEvent` equals to true. This is specific Bubble messages indicating that someone entered the bubble or juste leaved it.



### Listen to receipts

Receipts allow to know if the message has been successfully delivered to your recipient. Use the ID of your originated message to be able to link with the receipt received.

When the server receives the message you just sent, a receipt is sent to you:

```js

...
rainbowSDK.events.on('rainbow_onmessageserverreceiptreceived', function(receipt) {
    // do something when the message has been received by the Rainbow server
    ...
});

```

Then, when the recipient receives the message, the following receipt is sent to you:

```js

...
rainbowSDK.events.on('rainbow_onmessagereceiptreceived', function(receipt) {
    // do something when the message has been received by the recipient
    ...
});

```

Finally, when the recipient read the message, the following receipt is sent to you:

```js

...
rainbowSDK.events.on('rainbow_onmessagereceiptreadreceived', function(receipt) {
    // do something when the message has been read by the recipient
    ...
});

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

The SDK for Node.js allows to change the presence of the connected user by calling the following api:

```js

...
rainbowSDK.presence.setPresenceTo(rainbowSDK.presence.RAINBOW_PRESENCE_DONOTDISTURB).then(function() {
    // do something when the presence has been changed
    ...
}).catch(function(err) {
    // do something if the presence has not been changed
    ...
});

```

The following values are accepted:

| Presence constant | value | Meaning |
|------------------ | ----- | ------- |
| **RAINBOW_PRESENCE_ONLINE** | "online" | The connected user is seen as **available** |
| **RAINBOW_PRESENCE_DONOTDISTURB** | "dnd" | The connected user is seen as **do not disturb** |
| **RAINBOW_PRESENCE_AWAY** | "away" | The connected user is seen as **away** |
| **RAINBOW_PRESENCE_INVISIBLE** | "invisible" | The connected user is connected but **seen as offline** |

Notice: Values other than the ones listed will not be taken into account.



## Proxy management

### Configuration

If you need to access to Rainbow through an HTTP proxy, you have to add the following part to your `options` parameter:

```js

...
proxy: {
    host: '192.168.0.254',
    port: 8080,             // Default to 80 if not provided
    protocol: 'http'       // Default to 'http' if not provided
}

```


## Serviceability

### Retrieving SDK version

You can retrieve the SDK Node.JS version by calling the API `version`

```js

let version = rainbowSDK.version;

```


### Logging to the console

By default, the Rainbow SDK for Node.js logs to the shell console used (ie. that starts the Node.js process).

You can disable it by setting the parameter `enableConsoleLogs` to false

```js

...
logs: {
    enableConsoleLogs: false
    ...
}

```


### Logging to files

By default, the SDK logs information in the shell console that starts the Node.js process.

You can save these logs into a file by setting the parameter `enableFileLogs` to true. (False by default).

```js

...
logs: {
    enableFileLogs: true
    ...
}
```

You can modify the path where the logs are saved and the log level by modifying the parameter `file` like the following:

```js
...
logs: {
    file: {
        path: '/var/tmp/mypath/',
        level: 'error'
    }
}

```

The available log levels are: `error`, `warn`, `info` and `debug`

Notice: Each day a new file is created.


### Stopping the SDK

At any time, you can stop the connection to Rainbow by calling the API `stop()`. This will stop all services. The only way to reconnect is to call the API `start()` again.

```js

...
rainbowSDK.events.on('rainbow_onstopped', () => {
    // do something when the SDK has been stopped
    ...
});


rainbowSDK.stop().then((res) => {
    // Do something when the SDK has been stopped
    ...
});

```


### Auto-reconnection

When the SDK for Node.JS is disconnected from Rainbow, attempts are made to try to reconnect automatically.

This reconnection step can be followed by listening to events `rainbow_ondisconnected`, `rainbow_onreconnecting`, `rainbow_onconnected` and `rainbow_onready`.

```js

...
rainbowSDK.events.on('rainbow_ondisconnected', () => {
    // do something when the SDK has been disconnected
    ...
});


rainbowSDK.events.on('rainbow_onreconnecting', () => {
    // do something when the SDK tries to reconnect to Rainbow
    ...
});

rainbowSDK.events.on('rainbow_onconnected', () => {
    // do something when the SDK has connected to Rainbow
    ...
});

rainbowSDK.events.on('rainbow_onready', () => {
    // do something when the SDK is ready to be used 
    ...
});

```


### API Return codes

Here is the table and description of the API return codes:

| Return code | Label | Message | Meaning |
|------------------ | ----- | ------ | ------ |
| 1 | **"SUCCESSFULL"** | "" | The request has been successfully executed |
| -1 | **"INTERNALERROR"** | "An error occured. See details for more information" | A error occurs. Check the details property for more information on this issue |
| -2 | **"UNAUTHORIZED"** | "The email or the password is not correct" | Either the login or the password is not correct. Check your Rainbow account |
| -4 | **"XMPPERROR"** | "An error occured. See details for more information" | An error occurs regarding XMPP. Check the details property for more information on this issue |
| -16 | **"BADREQUEST"** | "One or several parameters are not valid for that request." | You entered bad parameters for that request. Check this documentation for the list of correct values |

When there is an issue calling an API, an error object is returned like in the following example:

```js

{
    code: -1                // The error code
    label: "INTERNALERROR"  // The error label
    msg: "..."              // The error message
    details: ...            // The JS error
}

```

Notice: In case of successfull request, this object is returned only when there is no other information returned.


## Features provided

Here is the list of features supported by the Rainbow-Node-SDK


### Instant Messaging

 - Send and receive One-to-One messages

 - XEP-0045: Multi-user Chat: Send and receive messages in Bubbles

 - XEP-0184: Message Delivery Receipts (received and read)

 - XEP-0280: Message Carbon


### Contacts

 - Get the list of contacts

 - Get contact individually


### Bubbles

 - Create a new Bubble
 
 - Get the list of bubbles

 - Get bubble individually

 - Invite contact to a bubble

 - Remove contact from a bubble

 - Leave a bubble

 - Delete a bubble

 - Be notified of an invitation to join a bubble

 - Be notified when affiliation of users changes in a bubble

 - Be notified when my affiliation changes in a bubble

 - Accept to join a bubble

 - Decline to join a bubble


### Presence

- Get the presence of contacts

- Set the user connected presence


### Serviciability

 - Support of connection through an HTTP Proxy 

 - Logs into file & console

 - XEP-0199: XMPP Ping

 - REST token automatic renewal and auto-relogin
