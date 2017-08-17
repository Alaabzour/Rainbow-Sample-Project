# Rainbow-Sample-Project 

## Description
###### add a description about rainbow sdk
---

## Installation

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

| Title | Description |
| --- | --- |
| `git status` | List all *new or modified* files |
| `git diff` | [Contribution guidelines for this project](../master/Managing_Contacts.md) |

---

4. Connect to Rainbow official

```objective-c
[[ServicesManager sharedInstance].loginManager connect];
```

You are now connecting to Rainbow server, login manager notifications will give you feedback on the connection status (DidLogin, DidFailedToAuthenticate).

- Connect to Rainbow sanbox mode

```objective-c
[[NSNotificationCenter defaultCenter] postNotificationName:kChangeServerURLNotification object:@{ @"serverURL": @"your sandbox URL"}];     
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
[[ServicesManager sharedInstance].loginManager connect];

});
```

---


