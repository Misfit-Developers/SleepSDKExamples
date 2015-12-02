//
//  MainViewController.h
//  MusicAlarmTutorial2
//
//  Created by Phillip Pasqual on 11/17/15.
//  Copyright © 2015 Misfit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *songTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *songArtistLabel;
@property (strong, nonatomic) IBOutlet UIButton *alarmTimeButton;
@property (strong, nonatomic) IBOutlet UILabel *alarmTimeLabel;
@property (strong, nonatomic) IBOutlet UIButton *alarmOffButton;
@property (strong, nonatomic) IBOutlet UIButton *alarmOnButton;
@property (strong, nonatomic) IBOutlet UILabel *deviceStatusLabel;
@property (strong, nonatomic) IBOutlet UIButton *settingsButton;

@property (strong, nonatomic) UIView *topLine;
@property (strong, nonatomic) UIView *bottomLine;

@property (strong, nonatomic) NSDate *alarmTime;
@property (nonatomic, assign) BOOL isAlarmOn;

@end

