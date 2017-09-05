//
//  CallViewController.m
//  RainbowSampleProject
//
//  Created by Asal Tech on 8/15/17.
//  Copyright © 2017 Asaltech. All rights reserved.
//

#import "CallViewController.h"


@interface CallViewController (){
    RTCCall * currentCall;
}

@end

@implementation CallViewController

#pragma mark - Application LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    currentCall = [[ServicesManager sharedInstance].rtcService beginNewOutgoingCallWithContact:_aContact withFeatures:(RTCCallFeatureAudio)];
    NSArray * testArray = [[ServicesManager sharedInstance].rtcService calls];
    NSLog(@"%@",testArray);
    // Do any additional setup after loading the view from its nib.
}

- (void) didCallSuccess : (NSNotification * ) notification {
    NSLog(@"%@",notification.object);
}
- (void) didUpdateCall : (NSNotification * ) notification {
    NSLog(@"%@",notification.object);
}

- (void) statusChanged : (NSNotification * ) notification {
    NSLog(@"%@",notification.object);
}

- (void) didRemoveCall : (NSNotification * ) notification {
    NSLog(@"%@",notification.object);
}
- (void) didAllowMicrophone : (NSNotification * ) notification {
    NSLog(@"%@",notification.object);
}
- (void) didRefuseMicrophone : (NSNotification * ) notification {
    NSLog(@"%@",notification.object);
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setup {
    _muteButton.layer.borderColor = APPLICATION_BLUE_COLOR.CGColor;
    _muteButton.layer.borderWidth = 1.0;
    _speakerButton.layer.borderColor = APPLICATION_BLUE_COLOR.CGColor;
    _speakerButton.layer.borderWidth = 1.0;
    _videoButton.layer.borderColor = APPLICATION_BLUE_COLOR.CGColor;
    _videoButton.layer.borderWidth = 1.0;
    
    _nicknameLabel.text = _aContact.fullName;
    _userImageView.image = [UIImage imageWithData:_aContact.photoData];
    
}

#pragma mark - Call Actions
- (IBAction)muteAction:(UIButton *)sender {
    if (sender.isSelected) {
        [[ServicesManager sharedInstance].rtcService muteLocalAudioForCall:currentCall];
        [sender setSelected:NO];
        [sender setBackgroundColor:[UIColor whiteColor]];
    }
    else{
         [[ServicesManager sharedInstance].rtcService unMuteLocalAudioForCall:currentCall];
        [sender setSelected:YES];
         [sender setBackgroundColor:APPLICATION_BLUE_COLOR];
    }
    
}
- (IBAction)speakerAction:(UIButton *)sender {
    if (sender.isSelected) {
        [[ServicesManager sharedInstance].rtcService requestMicrophoneAccess];
        [[ServicesManager sharedInstance].rtcService forceAudioOnSpeaker];
        
        [sender setSelected:NO];
         [sender setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        [[ServicesManager sharedInstance].rtcService unForceAudioOnSpeaker];
        [sender setSelected:YES];
        [sender setBackgroundColor:APPLICATION_BLUE_COLOR];
    }
}
- (IBAction)videoAction:(UIButton *)sender {
    if (sender.isSelected) {
        
        [[ServicesManager sharedInstance].rtcService addVideoMediaToCall:currentCall];
        [sender setSelected:NO];
         [sender setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        [[ServicesManager sharedInstance].rtcService remoteVideoStreamForCall:currentCall];
        [sender setSelected:YES];
        [sender setBackgroundColor:APPLICATION_BLUE_COLOR];
    }
}

- (IBAction)endCallAction:(UIButton *)sender {
    [[ServicesManager sharedInstance].rtcService cancelOutgoingCall:currentCall];
    //or
    //[[ServicesManager sharedInstance].rtcService hangupCall:currentCall];
    // what the difference btw hangup and cancel?
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}


@end
