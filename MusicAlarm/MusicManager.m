//
//  MusicManager.m
//  QuantumDemo
//
//  Created by Phillip Pasqual on 11/12/15.
//  Copyright © 2015 Misfit. All rights reserved.
//
#import "MusicManager.h"

@interface MusicManager()

@property (nonatomic, strong, readwrite) NSString *songTitle;
@property (nonatomic, strong, readwrite) NSString *songArtist;

@property (nonatomic) MPMusicPlayerController *musicPlayer;

@end

@implementation MusicManager


static MusicManager *_defaultManager = nil;
+ (MusicManager *)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultManager = [[MusicManager alloc] init];
    });
    return _defaultManager;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
        self.songTitle = nil;
        self.songArtist = nil;
    }
    return self;
}

- (void)setMediaItemCollection:(MPMediaItemCollection *)mediaItemCollection
{
    MPMediaItem *mediaItem = [[mediaItemCollection items] objectAtIndex:0];
    self.songTitle = [mediaItem valueForProperty:MPMediaItemPropertyTitle];
    self.songArtist = [mediaItem valueForProperty:MPMediaItemPropertyArtist];
    _mediaItemCollection = mediaItemCollection;
    [_musicPlayer setQueueWithItemCollection:_mediaItemCollection];
}

- (void)play
{
    [_musicPlayer play];
    [_musicPlayer beginGeneratingPlaybackNotifications];
}

- (void)stop
{
    [_musicPlayer stop];
}

@end

