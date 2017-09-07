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
    NSTimer *timer;
    int seconds;
    int miniSeconds;
    int minutes;
    BOOL videoFlag;
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
    if ([notification.object class] == [RTCCall class]) {
        currentCall = notification.object;
    }
    [self updateStatus];
}
- (void) didUpdateCall : (NSNotification * ) notification {
    NSLog(@"%@",notification.object);
    if ([notification.object class] == [RTCCall class]) {
        currentCall = notification.object;
    }
    [self updateStatus];
    
}

- (void) statusChanged : (NSNotification * ) notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        RTCMediaStream * remoteVideoStream = [[ServicesManager sharedInstance].rtcService remoteVideoStreamForCall:currentCall];
        
        if (remoteVideoStream != nil && videoFlag) {
            [_remoteVideoStream setHidden:YES];
            
            [[[ServicesManager sharedInstance].rtcService remoteVideoStreamForCall:currentCall].videoTracks.lastObject removeRenderer:_remoteVideoStream];
            videoFlag = NO;
        }
        
        [self dismissViewControllerAnimated:NO completion:^{
            
        }];
    });
    
}

- (void) didRemoveCall : (NSNotification * ) notification {
    NSLog(@"%@",notification.object);
    [timer invalidate];
    timer = nil;
    
    
    // remove local video also
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
    
    if (_aContact.photoData) {
          _userImageView.image = [UIImage imageWithData:_aContact.photoData];
    }
    
    [_localVideoStream setHidden:YES];
    [_remoteVideoStream setHidden:YES];
    
    seconds = 0;
    miniSeconds = 0;
    minutes = 0;
    
    videoFlag = NO;
}

- (void) updateStatus {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // check feature also
        if (currentCall.features == 7 ||currentCall.features == 6 || currentCall.features == 2 || currentCall.features == 3) {
            RTCMediaStream * remoteVideoStream = [[ServicesManager sharedInstance].rtcService remoteVideoStreamForCall:currentCall];
            
            if (remoteVideoStream != nil && !videoFlag) {
                [_remoteVideoStream setHidden:NO];
                
                [[[ServicesManager sharedInstance].rtcService remoteVideoStreamForCall:currentCall].videoTracks.lastObject addRenderer:_remoteVideoStream];
                videoFlag = YES;
            }
          
        }
        else{
            RTCMediaStream * remoteVideoStream = [[ServicesManager sharedInstance].rtcService remoteVideoStreamForCall:currentCall];
            
            if (remoteVideoStream != nil && videoFlag) {
                [_remoteVideoStream setHidden:YES];
                [[[ServicesManager sharedInstance].rtcService remoteVideoStreamForCall:currentCall].videoTracks.lastObject removeRenderer:_remoteVideoStream];
            }
            
        }
        
     
        
        switch (currentCall.status) {
            case 0:
                _statusLabel.text = @"Ringing ...";
                break;
            case 1:
                _statusLabel.text = @"Connecting ...";
                break;
            case 2:
                _statusLabel.text = @"Declined ...";
                break;
            case 3:
                _statusLabel.text = @"Timeout ...";
                break;
            case 4:
                _statusLabel.text = @"Canceled ...";
                break;
            case 5:
                if (timer == nil) {
                     timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
                }
                break;
            case 6:{
                _statusLabel.text = @"Hangup ...";
                RTCMediaStream * remoteVideoStream = [[ServicesManager sharedInstance].rtcService remoteVideoStreamForCall:currentCall];
                
                if (remoteVideoStream != nil && videoFlag) {
                    [_remoteVideoStream setHidden:YES];
                    
                    [[[ServicesManager sharedInstance].rtcService remoteVideoStreamForCall:currentCall].videoTracks.lastObject removeRenderer:_remoteVideoStream];
                    videoFlag = NO;
                }

            }
               
                break;
                
                
            default:
                break;
        }

    });
   }

- (void) startCounter {
    
}


-(void)timerTick:(NSTimer *)sender
{
    miniSeconds++;
    if (miniSeconds == 60)
    {
        miniSeconds = 0;
        seconds++;
        if (seconds == 60)
        {
            seconds = 0;
            minutes++;
        }
    }
     _statusLabel.text = [NSString stringWithFormat:@"%02i:%02i:%02i",minutes,seconds,miniSeconds];
}
-(void)nextLevelTime
{
    [timer invalidate];
    miniSeconds = 0;
    seconds = 0;
    minutes = 0;
}

#pragma mark - Call Actions
- (IBAction)muteAction:(UIButton *)sender {
    
    if (sender.isSelected) {
        [[ServicesManager sharedInstance].rtcService unMuteLocalAudioForCall:currentCall];
        [sender setSelected:NO];
        [sender setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        [[ServicesManager sharedInstance].rtcService muteLocalAudioForCall:currentCall];
       
        [sender setSelected:YES];
        [sender setBackgroundColor:APPLICATION_BLUE_COLOR];
    }
    
}
- (IBAction)speakerAction:(UIButton *)sender {
    
    if (sender.isSelected) {
        [[ServicesManager sharedInstance].rtcService unForceAudioOnSpeaker];
        
        [sender setSelected:NO];
        [sender setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        [[ServicesManager sharedInstance].rtcService requestMicrophoneAccess];
        [[ServicesManager sharedInstance].rtcService forceAudioOnSpeaker];
    
        [sender setSelected:YES];
        [sender setBackgroundColor:APPLICATION_BLUE_COLOR];
    }
}
- (IBAction)videoAction:(UIButton *)sender {
    
    if (sender.isSelected) {
       
        [[ServicesManager sharedInstance].rtcService removeVideoMediaFromCall:currentCall];
      
        [[[ServicesManager sharedInstance].rtcService localVideoStreamForCall:currentCall].videoTracks.lastObject removeRenderer:_localVideoStream];
        
        [_localVideoStream setHidden:YES];
        
        [_speakerButton setSelected:NO];
        [_speakerButton setBackgroundColor:[UIColor whiteColor]];
        
        [sender setSelected:NO];
        [sender setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        
       [[ServicesManager sharedInstance].rtcService addVideoMediaToCall:currentCall];
        
        
       [[[ServicesManager sharedInstance].rtcService localVideoStreamForCall:currentCall].videoTracks.lastObject addRenderer:_localVideoStream];
      
       [_localVideoStream setHidden:NO];
        
        
        [_speakerButton setSelected:YES];
        [_speakerButton setBackgroundColor:APPLICATION_BLUE_COLOR];
       
        
        [sender setSelected:YES];
        [sender setBackgroundColor:APPLICATION_BLUE_COLOR];
    }
}



- (IBAction)endCallAction:(UIButton *)sender {
    [[ServicesManager sharedInstance].rtcService cancelOutgoingCall:currentCall];
    [[ServicesManager sharedInstance].rtcService hangupCall:currentCall];
    // what the difference btw hangup and cancel?
    [self dismissViewControllerAnimated:NO completion:^{
        [timer invalidate];
        timer = nil;
    }];
}

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}


@end
