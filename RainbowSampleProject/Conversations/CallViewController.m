//
//  CallViewController.m
//  RainbowSampleProject
//
//  Created by Asal Tech on 8/15/17.
//  Copyright © 2017 Asaltech. All rights reserved.
//

#import "CallViewController.h"
#import <Rainbow/Rainbow.h>

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCallSuccess:) name:kRTCServiceDidAddCallNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateCall:) name:kRTCServiceDidUpdateCallNotification object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusChanged:) name:kRTCServiceCallStatsNotification object:nil];
    
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
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setup {
    _muteButton.layer.borderColor = [UIColor colorWithRed:39.0/255.0 green:129.0/255.0 blue:187.0/255.0 alpha:1.0].CGColor;
    _muteButton.layer.borderWidth = 1.0;
    _speakerButton.layer.borderColor = [UIColor colorWithRed:39.0/255.0 green:129.0/255.0 blue:187.0/255.0 alpha:1.0].CGColor;
    _speakerButton.layer.borderWidth = 1.0;
    _videoButton.layer.borderColor = [UIColor colorWithRed:39.0/255.0 green:129.0/255.0 blue:187.0/255.0 alpha:1.0].CGColor;
    _videoButton.layer.borderWidth = 1.0;
}

#pragma mark - Call Actions
- (IBAction)muteAction:(UIButton *)sender {
    if (sender.isSelected) {
        [sender setSelected:NO];
        [sender setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        [sender setSelected:YES];
         [sender setBackgroundColor:[UIColor colorWithRed:39.0/255.0 green:129.0/255.0 blue:187.0/255.0 alpha:1.0]];
    }
    
}
- (IBAction)speakerAction:(UIButton *)sender {
    if (sender.isSelected) {
        [sender setSelected:NO];
         [sender setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        [sender setSelected:YES];
        [sender setBackgroundColor:[UIColor colorWithRed:39.0/255.0 green:129.0/255.0 blue:187.0/255.0 alpha:1.0]];
    }
}
- (IBAction)videoAction:(UIButton *)sender {
    if (sender.isSelected) {
        [sender setSelected:NO];
         [sender setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        [sender setSelected:YES];
        [sender setBackgroundColor:[UIColor colorWithRed:39.0/255.0 green:129.0/255.0 blue:187.0/255.0 alpha:1.0]];
    }
}

- (IBAction)endCallAction:(UIButton *)sender {
    [[ServicesManager sharedInstance].rtcService cancelOutgoingCall:currentCall];
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

@end
