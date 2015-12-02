//
//  MusicManager.h
//  QuantumDemo
//
//  Created by Phillip Pasqual on 11/12/15.
//  Copyright © 2015 Misfit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MusicManager : NSObject

@property (nonatomic, strong, readonly) NSString *songTitle;
@property (nonatomic, strong, readonly) NSString *songArtist;
@property (nonatomic, assign) MPMediaItemCollection *mediaItemCollection;

+ (MusicManager *) defaultManager;

- (void)play;
- (void)stop;

@end