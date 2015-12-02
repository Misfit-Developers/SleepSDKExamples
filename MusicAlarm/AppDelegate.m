//
//  AppDelegate.m
//  MusicAlarmTutorial2
//
//  Created by Phillip Pasqual on 11/17/15.
//  Copyright © 2015 Misfit. All rights reserved.
//

#import "AppDelegate.h"
#import <MisfitSleepSDK/MisfitSleepSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)registerUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    UIUserNotificationType types = UIUserNotificationTypeBadge |
    UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *mySettings =
    [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    BOOL canHandle = NO;
    if ([[MisfitSleepSDK sharedInstance] canHandleOpenUrl:url])
    {
        canHandle = [[MisfitSleepSDK sharedInstance] handleOpenURL:url];
    }
    return canHandle;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[MisfitSleepSDK sharedInstance] handleDidBecomeActive];
}

@end
