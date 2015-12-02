//
//  MainViewController.m
//  MusicAlarmTutorial2
//
//  Created by Phillip Pasqual on 11/17/15.
//  Copyright © 2015 Misfit. All rights reserved.
//

#import "MainViewController.h"
#import "AlarmSetupViewController.h"
#import "GradientBackground.h"
#import "MusicManager.h"
#import <MisfitSleepSDK/MisfitSleepSDK.h>

@interface MainViewController () <MisfitSleepTrackingEventDelegate,  MisfitSleepDeviceStateDelegate, AlarmSetupViewControllerDelegate>

@end

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //apply background gradient
    CAGradientLayer *bgLayer = [GradientBackground purpleGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
    //connect to Misfit if needed
    if (![[MisfitSleepSDK sharedInstance] isConnected]) {
        [self showConnectAlert];
    }
    
    //add border lines above/below the alarm time
    [self addLines];
    
    [MisfitSleepSDK sharedInstance].trackingEventDelegate = self;
    [MisfitSleepSDK sharedInstance].stateChangeDelegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [self refreshUI];
}

#pragma mark - Nav Buttons
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    //only perform segue if the app has been authenticated
    if (![[MisfitSleepSDK sharedInstance] isConnected]) {
        [self showConnectAlert];
        return NO;
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //set this view controller as the delegate for AlarmSetupViewController.
    //this is used to pass the chosen alarm time back to this view controller
    //from AlarmSetupViewController.
    if ([segue.identifier isEqualToString:@"alarmTime"]) {
        AlarmSetupViewController *setupVC = [segue destinationViewController];
        setupVC.delegate = self;
        //if alarm time has been previously set, send this time to the AlarmSetupViewController
        if (_alarmTime) {
            [setupVC pushWithAlarmTime:_alarmTime];
        }
    }
}

- (void)setAlarmTime:(NSDate*)alarmTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *strTime = [dateFormatter stringFromDate:alarmTime];
    [_alarmTimeButton setTitle:strTime forState:UIControlStateNormal];
    _alarmTime = alarmTime;
    [self.alarmOnButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - UI
- (void)refreshUI
{
    BOOL isAlarmOn = [[MisfitSleepSDK sharedInstance] isWakeupTimeSet];
    if (isAlarmOn) {
        [self.songTitleLabel setAlpha:1.0];
        [self.songArtistLabel setAlpha:1.0];
        [self.alarmTimeButton setAlpha:1.0];
        [self.alarmTimeLabel setAlpha:1.0];
        [self.alarmOnButton setAlpha:1.0];
        [self.alarmOffButton setAlpha:0.35];
        [self.topLine setAlpha:1.0];
        [self.bottomLine setAlpha:1.0];
        
        [self.alarmOnButton setTitle:@"ON" forState:UIControlStateNormal];
        [self.alarmOffButton setTitle:@"off" forState:UIControlStateNormal];
    }else{
        [self.songTitleLabel setAlpha:0.35];
        [self.songArtistLabel setAlpha:0.35];
        [self.alarmTimeButton setAlpha:0.35];
        [self.alarmTimeLabel setAlpha:0.35];
        [self.alarmOnButton setAlpha:0.35];
        [self.alarmOffButton setAlpha:1.0];
        [self.topLine setAlpha:0.35];
        [self.bottomLine setAlpha:0.35];
        
        [self.alarmOnButton setTitle:@"on" forState:UIControlStateNormal];
        [self.alarmOffButton setTitle:@"OFF" forState:UIControlStateNormal];
    }
    
    if ([[MusicManager defaultManager] songTitle] && [[MusicManager defaultManager] songArtist]) {
        self.songTitleLabel.text = [[MusicManager defaultManager] songTitle];
        self.songArtistLabel.text = [[MusicManager defaultManager] songArtist];
        
        self.songTitleLabel.hidden = NO;
        self.songArtistLabel.hidden = NO;
    }else{
        self.songTitleLabel.hidden = YES;
        self.songArtistLabel.hidden = YES;
    }
}

- (void)addLines
{
    CGPoint topStart = CGPointMake(self.alarmTimeButton.frame.origin.x, self.alarmTimeButton.frame.origin.y - 10);
    CGPoint bottomStart = CGPointMake(self.alarmTimeButton.frame.origin.x, self.alarmTimeButton.frame.origin.y + self.alarmTimeButton.frame.size.height + 10);
    CGFloat width = self.alarmTimeButton.frame.size.width + self.alarmTimeLabel.frame.size.width;
    _topLine = [[UIView alloc] initWithFrame:CGRectMake(topStart.x, topStart.y, width, 3)];
    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(bottomStart.x, bottomStart.y, width, 3)];
    
    _topLine.backgroundColor = [UIColor whiteColor];
    _bottomLine.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_topLine];
    [self.view addSubview:_bottomLine];
}
#pragma mark - Alarm Controls
- (IBAction)alarmOnButtonPressed:(UIButton *)sender
{
    if (![[MisfitSleepSDK sharedInstance] isConnected]) {
        [self showConnectAlert];
    }
    if ([[MisfitSleepSDK sharedInstance] isConnected] && _alarmTime && [[MusicManager defaultManager] songTitle]) {
        self.isAlarmOn = YES;
        [self.alarmOnButton setEnabled:NO];
        [self.alarmOffButton setEnabled:YES];
        [self turnAlarmOn];
        [self refreshUI];
    }
}

- (IBAction)alarmOffButtonPressed:(UIButton *)sender
{
    if (![[MisfitSleepSDK sharedInstance] isConnected]) {
        [self showConnectAlert];
    }else{
        self.isAlarmOn = NO;
        [self.alarmOnButton setEnabled:YES];
        [self.alarmOffButton setEnabled:NO];
        [self turnAlarmOff];
        [self refreshUI];
    }
}

#pragma mark - Alarm Setup
- (void)turnAlarmOn
{
    if ([[MisfitSleepSDK sharedInstance] isConnected] && _alarmTime) {
        void (^AlarmCompletion)(MFHError * error) = ^(MFHError *error) {
            if (error)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(error.localizedTitle, nil)
                                                                message:NSLocalizedString(error.localizedMessage, nil)
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                [self turnAlarmOff];
                return;
            }
            [self refreshUI];
        };
        
        //convert alarm time to hours and minutes
        NSDate *date = _alarmTime;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
        NSInteger hour = [components hour];
        NSInteger minute = [components minute];
        //set the alarm
        [[MisfitSleepSDK sharedInstance] setWakeupTimeForHour:hour minute:minute completion:AlarmCompletion];
    }
}

- (void)turnAlarmOff
{
    [[MisfitSleepSDK sharedInstance] stopWakeupTracking];
    [[MusicManager defaultManager] stop];
    [self stopBackupAlarm];
}

#pragma mark - Misfit Auth
- (void)showConnectAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connect to Misfit"
                                                    message:@"You must be connected to Misfit to use this app."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (buttonIndex == 1) {
        [self connectToMisfit];
    }
}

-(void)connectToMisfit
{
    [[MisfitSleepSDK sharedInstance] connectWithAppId:@"musicalarm"
                                            appSecret:@"xakQTasL0RdlLaOB5GLG6KfQdl7E5xLR"
                                           completion:^(NSDictionary * data, MFHError* error)
     {
         if (error)
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(error.localizedTitle, nil)
                                                             message:NSLocalizedString(error.localizedMessage, nil)
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
             [alert show];
         }else{
             NSLog(@"success");
             
             NSString * token = [data objectForKey:@"access_token"];
             NSLog(@"Token: %@",token);
         }
     }];
}

#pragma mark - Misfit Events
- (void) performActionByEvent:(MisfitTrackingEventType) event
{
    if(event == MisfitTrackingEventTypeFallAsleep)
    {
        [[MusicManager defaultManager] stop];
    }
    else if(event == MisfitTrackingEventTypeWakeup)
    {
        [[MusicManager defaultManager] play];
    }
}

- (void) onDeviceStateChangeWithState:(MisfitDeviceState)state
                         serialNumber:(NSString *)serialNumber
{
    if (state == MisfitDeviceStateDisconnected) {
        [self startBackupAlarm];
        [self.deviceStatusLabel setText:@"device: disconnected"];
        self.deviceStatusLabel.hidden = NO;
    }
    else if (state == MisfitDeviceStateConnecting){
        [self.deviceStatusLabel setText:@"device: connecting"];
    }
    else if (state == MisfitDeviceStateConnected){
        [self stopBackupAlarm];
        self.deviceStatusLabel.hidden = YES;
    }
}

//if the device becomes disconnected at any point during the night,
//a backup alarm should be scheduled that will ensure that an alarm
//sound is still triggred at the alarm time
- (void)startBackupAlarm
{
    if ([[MisfitSleepSDK sharedInstance] isWakeupTimeSet]) {
        UILocalNotification *alarmNotification = [[UILocalNotification alloc] init];
        alarmNotification.fireDate = _alarmTime;
        alarmNotification.timeZone = [NSTimeZone defaultTimeZone];
        alarmNotification.alertBody = @"Time to wake up!";
        alarmNotification.soundName = @"Caffeine.m4a";
        [[UIApplication sharedApplication] scheduleLocalNotification:alarmNotification];
    }
}

//if the disconnected device is reconnected, clear any scheduled backup alarms
- (void)stopBackupAlarm
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

@end
