//
//  FPBulbSound.m
//  FunnyPuzzle
//
//  Created by Stas Volskyi on 27.06.14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import "FPBulbSound.h"
#import <AVFoundation/AVFoundation.h>

@interface FPBulbSound() <AVAudioPlayerDelegate>

@property (nonatomic) NSURL *soundUrl;
@property (nonatomic) AVAudioPlayer *player;

@end

@implementation FPBulbSound

- (id) init{
    NSError *error;
    self.soundUrl = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"Blop" ofType:@"mp3"]];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.soundUrl error:&error];
    self.player.numberOfLoops = 0;
    self.player.volume = 0.6;
    self.player.delegate = self;
    [self.player prepareToPlay];
    return self;
}

- (void) play
{
    [self.player play];
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    self.soundUrl = nil;
    self.player = nil;
    [self.delegate deleteBlobById:self];
}



@end
