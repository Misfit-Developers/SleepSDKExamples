//
//  AlarmSetupViewController.h
//  QuantumDemo
//
//  Created by Phillip Pasqual on 11/25/15.
//  Copyright © 2015 Misfit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlarmSetupViewControllerDelegate <NSObject>
- (void)setAlarmTime:(NSDate*)timestamp;
@end

@interface AlarmSetupViewController : UIViewController

@property (nonatomic, weak) id <AlarmSetupViewControllerDelegate> delegate;

- (void)pushWithAlarmTime:(NSDate*)alarmTime;

@property (strong, nonatomic) IBOutlet UIDatePicker *alarmTimePicker;
@property (strong, nonatomic) IBOutlet UITableView  *songPickerTableView;

@end

