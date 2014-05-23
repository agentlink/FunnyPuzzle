//
//  FPSoundManager.m
//  Sound manager
//
//  Created by Stas Volskyi on 22.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import "FPSoundManager.h"

@interface FPSoundManager()

@property (nonatomic, strong) AVAudioPlayer *backGroundMusicPlayer;
@property (nonatomic, strong) AVAudioPlayer *backGroundGamePlayer;
@property (nonatomic, strong) AVAudioPlayer *soundPlayer;
@property (nonatomic, strong) NSURL *apple;
@property (nonatomic, strong) NSURL *carrot;
@property (nonatomic, strong) NSURL *chicken;
@property (nonatomic, strong) NSURL *cochlea;
@property (nonatomic, strong) NSURL *dove;
@property (nonatomic, strong) NSURL *elephant;
@property (nonatomic, strong) NSURL *excellent;
@property (nonatomic, strong) NSURL *fish;
@property (nonatomic, strong) NSURL *lamb;
@property (nonatomic, strong) NSURL *icecream;
@property (nonatomic, strong) NSURL *octopus;
@property (nonatomic, strong) NSURL *owl;
@property (nonatomic, strong) NSURL *pencil;
@property (nonatomic, strong) NSURL *pig;
@property (nonatomic, strong) NSURL *rabbit;
@property (nonatomic, strong) NSURL *snail;
@property (nonatomic, strong) NSURL *squirrel;
@property (nonatomic, strong) NSURL *toad;
@property (nonatomic, strong) NSURL *well_done;

@end

@implementation FPSoundManager

static FPSoundManager *_instance=nil;

+ (FPSoundManager*)sharedInstance{
    @synchronized(self){
        if (_instance==nil){
            _instance=[[self alloc] init];
            [self loadData];
        }
    }
    return _instance;
}

- (void) playBackgroundMusic{
    [_backGroundMusicPlayer play];
}

- (void) stopBackgroundMusic{
    [_backGroundMusicPlayer stop];
}

- (void) playSound:(FPGameSounds)sound{
    NSError *error;
    [_soundPlayer stop];
    switch (sound) {
        case apple:
            _soundPlayer = [_soundPlayer initWithContentsOfURL:_apple error:&error];
        break;
        case carrot:
            _soundPlayer = [_soundPlayer initWithContentsOfURL:_carrot error:&error];
        break;
        case chicken:
            _soundPlayer = [_soundPlayer initWithContentsOfURL:_chicken error:&error];
        break;
        default:
        break;
    }
    [_soundPlayer prepareToPlay];
    [_soundPlayer play];
}

- (void) vibrate{
     AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

+ (void) loadData{
    NSError *error;
    //initialize Menu background player
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"menu_background_music" ofType:@"mp3"];
    NSURL *fileURL = [NSURL URLWithString:soundPath];
    _instance.backGroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
    [_instance.backGroundMusicPlayer prepareToPlay];
    _instance.backGroundMusicPlayer.numberOfLoops=-1;
    //initialize Game background player
    soundPath = [[NSBundle mainBundle] pathForResource:@"game_background_music" ofType:@"mp3"];
    fileURL = [NSURL URLWithString:soundPath];
    _instance.backGroundGamePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
    _instance.backGroundGamePlayer.numberOfLoops=-1;
    [_instance.backGroundGamePlayer prepareToPlay];
    //initialize Sound player
    soundPath = [[NSBundle mainBundle] pathForResource:@"well_done" ofType:@"mp3"];
    fileURL = [NSURL URLWithString:soundPath];
    _instance.soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
    _instance.soundPlayer.numberOfLoops=0;
    [_instance.soundPlayer prepareToPlay];
    
    //set sounds path
    soundPath = [[NSBundle mainBundle] pathForResource:@"apple" ofType:@"mp3"];
    _instance.apple = [NSURL URLWithString:soundPath];
}

- (void) dealloc{
    _backGroundMusicPlayer=nil;
    _backGroundGamePlayer=nil;
    _soundPlayer=nil;
}


@end
