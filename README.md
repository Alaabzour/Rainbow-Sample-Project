# Rainbow-Sample-Project

# How to integrate Rainbow iOS SDK into existing app

## Integrate frameworks
- Drag-n-Drop RainbowSDK.framework into your xcode project
- Drag-n-Drop WebRTC.framework into your xcode project
- Add in your info.plist the following entries : 
- UIBackgroundModes (type Array)
    - Item 0 (type String) 
    - audio
- NSCameraUsageDescription (type String) 
    - a text explaining that you want access to camera
- NSMicrophoneUsageDescription (type String) 
    - a text explaining that you want access to  microphone
- NSAppTransportSecurity (type Dictionary)
- NSAllowsArbitraryLoads (type Boolean) YES
- NSContactsUsageDescription (type String) 
    - a text explaining that you want access to contacts
- NSPhotoLibraryUsageDescription (type String) 
    - a text explaining that you want access to photo library
- NSUserActivityTypes (type Array)
    - Item 0 (type String) INStartAudioCallIntent

- Disable bitcode :
- Select your project, select your target, select Build settings, search Enable Bitcode, select NO

- Add RainbowSDK framework and WebRTC framework into embebed binaries
- Select your project, select your target, select General, drag-n-drop RainbowSDK.framework and WebRTC.framework from Navigator to the Embedded Binaries section.


## Connect to Rainbow
- Import Rainbow


```objective-c
#import <Rainbow/Rainbow.h>
```

- Set your username and your password

```objective-c
[[ServicesManager sharedInstance].loginManager setUsername:@"myRainbowUser@domain.com" andPassword:@"MyPassword"];
```

- Monitor login manager notifications

```objective-c
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin:) name:kLoginManagerDidLoginSucceeded object:nil];
-(void) didLogin:(NSNotification *) notification {
NSLog(@"DID LOGIN");
}
```

- Connect to Rainbow official

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

