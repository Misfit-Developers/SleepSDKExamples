//
//  AlarmSetupViewController.m
//  QuantumDemo
//
//  Created by Phillip Pasqual on 11/25/15.
//  Copyright © 2015 Misfit. All rights reserved.
//

#import "AlarmSetupViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MusicManager.h"
#import <MisfitSleepSDK/MisfitSleepSDK.h>

@interface AlarmSetupViewController () <UITableViewDataSource,UITableViewDelegate,MPMediaPickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (nonatomic) NSDate *alarmTime;

@end

@implementation AlarmSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    _songPickerTableView.delegate = self;
    _songPickerTableView.dataSource = self;
    if (self.alarmTime) {
        [_alarmTimePicker setDate:self.alarmTime];
    }
}

- (IBAction)onSaveButtonPressed:(UIButton *)sender
{
    if ([[MusicManager defaultManager] songTitle]) {
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate setAlarmTime:[_alarmTimePicker date]];
    }
}

- (void)pushWithAlarmTime:(NSDate*)alarmTime
{
    self.alarmTime = alarmTime;
}


#pragma mark - song picker
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *songCellIdentifier = @"songCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:songCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:songCellIdentifier];
    }
    
    cell.textLabel.text = [[MusicManager defaultManager] songTitle];
    cell.detailTextLabel.text = [[MusicManager defaultManager] songArtist];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = NO;
    mediaPicker.prompt = NSLocalizedString(@"Select Wakeup Song", nil);
    [mediaPicker loadView];
    [self.navigationController presentViewController:mediaPicker animated:YES completion:nil];
}

#pragma mark - MPMediaPickerController delegate

- (void) mediaPicker:(MPMediaPickerController *) mediaPicker2 didPickMediaItems:(MPMediaItemCollection *) mediaItemCollection {
    [self dismissViewControllerAnimated:YES completion:nil];
    [MusicManager defaultManager].mediaItemCollection = mediaItemCollection;
    [_songPickerTableView reloadData];
}

- (void) mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end