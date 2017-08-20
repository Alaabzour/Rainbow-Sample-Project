# Rainbow-Sample-Project 
---
## Description
---
###### add a description about rainbow sdk

## Installation
---
###  Add Rainbow to your iOS Project
It's time to add Rainbow to your app. To do this you'll need an iOS project and a Rainbow configuration  for your app.

1. Download the framework SDK zip (this is a ~100MB file and may take some time).
2. Unzip and see next steps for which Frameworks to include in to your project.
3. Drag-n-Drop RainbowSDK.framework into your xcode project.
4. Drag-n-Drop WebRTC.framework into your xcode project.

### Configure the SDK

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

### Initialize Rainbow in your app
The final step is to add initialization code to your application. You may have already done this as part of adding Rainbow to your app.

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
---

## Next steps
Learn about Rainbow :
- [Managing Contacts](../master/Managing_Contacts.md)
    - how  to use the SDK for retrieving the existing contacts, searching for a contact by name, retrieving full information on a contact found and finally adding him to the network or removing him
  
- [Managing Contacts Presence](../master/Managing_Contacts.md)
    - how to use the SDK that explains the API to use for getting the connected user presence, changing the presence status and retrieving the presence of contacts from user's network

- [ Make an IM conversation](../master/Managing_Contacts.md)
    - sending a message, listening to incoming message and managing message receipts

- [Make an PSTN call](../master/Managing_Contacts.md) 
    - launch a PSTN call to Contact using WebRTC.framework
    


## Credits
---
###### highlight and link to the authors of project.


## License
---
###### For more information on choosing a license, check out GitHub’s licensing guide!

