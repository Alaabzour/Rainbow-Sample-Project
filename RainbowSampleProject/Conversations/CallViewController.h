//
//  CallViewController.h
//  RainbowSampleProject
//
//  Created by Asal Tech on 8/15/17.
//  Copyright © 2017 Asaltech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Rainbow/Rainbow.h>

@interface CallViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *muteButton;
@property (weak, nonatomic) IBOutlet UIButton *speakerButton;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIButton *endCallButton;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property (weak, nonatomic) IBOutlet UILabel *videoLabel;
@property (weak, nonatomic) IBOutlet UILabel *speakerLabel;
@property (weak, nonatomic) IBOutlet UILabel *muteLabel;

@property (nonatomic,weak) Contact* aContact;

@property (weak, nonatomic) IBOutlet RTCEAGLVideoView *localVideoStream;
@property (weak, nonatomic) IBOutlet RTCEAGLVideoView *remoteVideoStream;


- (void) didCallSuccess : (NSNotification * ) notification;
- (void) didUpdateCall : (NSNotification * ) notification;
- (void) statusChanged : (NSNotification * ) notification;
- (void) didRemoveCall : (NSNotification * ) notification;
- (void) didAllowMicrophone : (NSNotification * ) notification;
- (void) didRefuseMicrophone : (NSNotification * ) notification;

@end
