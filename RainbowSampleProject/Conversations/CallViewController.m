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
    
    [[ServicesManager sharedInstance].rtcService requestMicrophoneAccess];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCallSuccess:) name:kRTCServiceDidAddCallNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateCall:) name:kRTCServiceDidUpdateCallNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusChanged:) name:kRTCServiceCallStatsNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRemoveCall:) name:kRTCServiceDidRemoveCallNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAllowMicrophone:) name:kRTCServiceDidAllowMicrophoneNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRefuseMicrophone:) name:kRTCServiceDidRefuseMicrophoneNotification object:nil];

   currentCall = [[ServicesManager sharedInstance].rtcService beginNewOutgoingCallWithContact:_aContact withFeatures:(RTCCallFeatureAudio)];
    

    
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
        [sender setSelected:NO];
        [sender setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        [sender setSelected:YES];
         [sender setBackgroundColor:APPLICATION_BLUE_COLOR];
    }
    
}
- (IBAction)speakerAction:(UIButton *)sender {
    if (sender.isSelected) {
        [sender setSelected:NO];
         [sender setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        [sender setSelected:YES];
        [sender setBackgroundColor:APPLICATION_BLUE_COLOR];
    }
}
- (IBAction)videoAction:(UIButton *)sender {
    if (sender.isSelected) {
        [sender setSelected:NO];
         [sender setBackgroundColor:[UIColor whiteColor]];
    }
    else{
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
