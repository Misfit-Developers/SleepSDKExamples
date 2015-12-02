//
//  SettingsViewController.m
//  QuantumDemo
//
//  Created by Phillip Pasqual on 11/17/15.
//  Copyright © 2015 Misfit. All rights reserved.
//

#import "SettingsViewController.h"
#import <MisfitSleepSDK/MisfitSleepSDK.h>

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
}


- (IBAction)onRefreshButtonPressed:(UIButton *)sender
{
    [[MisfitSleepSDK sharedInstance] refreshServiceStatus:^(NSDictionary
                                                            *data, MFHError *error) {
        if (error) {
            NSLog(@"error: %@", error);
        }
        //the device that is currently synced in the Misfit App is
        //returned in the data dictionary
        NSLog(@"Device serial number: %@", data[@"serialNumber"]);
    }];
}

@end