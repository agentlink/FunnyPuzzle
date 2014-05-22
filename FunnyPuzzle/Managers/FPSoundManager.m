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
            _instance.soundToPlay = _instance.soundWin1;
            _instance.exelentSounPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_instance.soundToPlay error:&error];
            _instance.exelentSounPlayer.numberOfLoops=0;
            

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

- (void) playSound:(NSString*)sound{
    NSError *error;
    if ([sound isEqualToString:@"soundWin1"]) {
        [_exelentSounPlayer stop];
        _exelentSounPlayer = [_exelentSounPlayer initWithContentsOfURL:_soundWin error:&error];
    }
    else{
        [_exelentSounPlayer stop];
        _exelentSounPlayer = [_exelentSounPlayer initWithContentsOfURL:_soundWin1 error:&error];
    }
    [_exelentSounPlayer prepareToPlay];
    [_exelentSounPlayer play];
}


- (void) dealloc{
    _backGroundMusicPlayer=nil;
    _exelentSounPlayer=nil;
}


@end
