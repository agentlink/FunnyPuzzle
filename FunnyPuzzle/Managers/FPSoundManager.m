//
//  FPSoundManager.m
//  Sound manager
//
//  Created by Stas Volskyi on 22.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import "FPSoundManager.h"

@implementation FPSoundManager

static FPSoundManager *_instance=nil;

+ (FPSoundManager*)sharedInstance{
    @synchronized(self){
        if (_instance==nil){
            _instance=[[self alloc] init];
            NSError *error;
            NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"backGroundMusic" ofType:@"mp3"];
            NSURL *fileURL = [NSURL URLWithString:soundPath];
            _instance.backGroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
            [_instance.backGroundMusicPlayer prepareToPlay];
            _instance.backGroundMusicPlayer.numberOfLoops=-1;
            soundPath = [[NSBundle mainBundle] pathForResource:@"exelentSound1" ofType:@"mp3"];
            _instance.soundWin = [NSURL URLWithString:soundPath];
            soundPath = [[NSBundle mainBundle] pathForResource:@"exelentSound2" ofType:@"mp3"];
            _instance.soundWin1 = [NSURL URLWithString:soundPath];
            _instance.exelentSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_instance.soundWin error:&error];
            _instance.exelentSoundPlayer.numberOfLoops=0;
            

        }
    }
    return _instance;
}

- (void) playMusic{
    [_backGroundMusicPlayer play];
}

- (void) stopMusic{
    [_backGroundMusicPlayer stop];
}

- (void) playSound:(FPGameSounds)sound{
    NSError *error;
    [_exelentSoundPlayer stop];
    switch (sound) {
        case SoundChicken:
            _exelentSoundPlayer = [_exelentSoundPlayer initWithContentsOfURL:_soundWin error:&error];
        break;
        case SoundFrog:
            _exelentSoundPlayer = [_exelentSoundPlayer initWithContentsOfURL:_soundWin error:&error];
        break;
        case SoundPig:
            _exelentSoundPlayer = [_exelentSoundPlayer initWithContentsOfURL:_soundWin error:&error];
        break;
        default:
        break;
    }
    [_exelentSoundPlayer prepareToPlay];
    [_exelentSoundPlayer play];
}


- (void) dealloc{
    _backGroundMusicPlayer=nil;
    _exelentSoundPlayer=nil;
}


@end
