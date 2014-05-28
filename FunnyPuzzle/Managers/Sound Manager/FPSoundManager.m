//
//  FPSoundManager.m
//  Sound manager
//
//  Created by Stas Volskyi on 22.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import "FPSoundManager.h"
#import "FPGameManager.h"

@interface FPSoundManager()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *backGroundMusicPlayer;
@property (nonatomic, strong) AVAudioPlayer *backGroundGamePlayer;
@property (nonatomic, strong) AVAudioPlayer *soundPlayer;
@property (nonatomic, strong) NSURL *backGroundMusic;
@property (nonatomic, strong) NSURL *gameMusic;
@property (nonatomic, strong) NSURL *soundToPlay;
@property (nonatomic, strong) NSURL *excellent;
@property (nonatomic, strong) NSURL *well_done;
@property (nonatomic) SystemSoundID vibration;

@end

@implementation FPSoundManager

static FPSoundManager *_instance=nil;

NSTimer *timer;

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
    if ([FPGameManager sharedInstance].music==YES) {
        NSError *error;
        _backGroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_instance.backGroundMusic error:&error];
        _backGroundMusicPlayer.numberOfLoops=-1;
        [_backGroundMusicPlayer prepareToPlay];
        [_backGroundMusicPlayer play];
    }
}

- (void) stopBackgroundMusic{
    if ([_backGroundMusicPlayer isPlaying]==YES){
        [_backGroundMusicPlayer stop];
        _backGroundMusicPlayer=nil;
    }
}

- (void) playGameMusic{
    if ([FPGameManager sharedInstance].music==YES) {
        NSError *error;
        _backGroundGamePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_instance.gameMusic error:&error];
        _backGroundGamePlayer.numberOfLoops=-1;
        [_backGroundGamePlayer prepareToPlay];
        [_backGroundGamePlayer play];
    }
}

- (void) stopGameMusic{
    if ([_backGroundGamePlayer isPlaying]==YES){
        [_backGroundGamePlayer stop];
        _backGroundGamePlayer=nil;
    }
}

- (void) playSound:(NSURL*)sound{
    if ([FPGameManager sharedInstance].playSoundWhenImageAppear==YES){
        NSError *error;
        [_soundPlayer stop];
        _soundToPlay = sound;
        NSURL *url;
        int random=1+arc4random()%2;
        if (random==1) {
            url=_well_done;
        }
        else{
            url=_excellent;
        }
        _soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        _soundPlayer.delegate=(id)self;
        [_soundPlayer prepareToPlay];
        [_soundPlayer play];
    }
}

- (void) vibrate{
    if ([FPGameManager sharedInstance].vibrate==YES){
        _vibration = kSystemSoundID_Vibrate;
        AudioServicesCreateSystemSoundID(nil, &_vibration);
        timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(stopTimer) userInfo:nil repeats:YES];
        timerTick=0;
    }
}
int timerTick=0;

- (void) stopTimer{
    timerTick++;
    switch (timerTick) {
        case 1:
             AudioServicesPlaySystemSound(_vibration);
        break;
        default:{
            AudioServicesDisposeSystemSoundID(_vibration);
            [timer invalidate];
        }
    }
    
}

+ (void) loadData{
    NSError *error;
    //initialize Menu background player
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"menu_background_music" ofType:@"mp3"];
    NSURL *fileURL = [NSURL URLWithString:soundPath];
    _instance.backGroundMusic=fileURL;
    _instance.backGroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
    [_instance.backGroundMusicPlayer prepareToPlay];
    _instance.backGroundMusicPlayer.numberOfLoops=-1;
    //initialize Game background player
    soundPath = [[NSBundle mainBundle] pathForResource:@"game_background_music" ofType:@"mp3"];
    fileURL = [NSURL URLWithString:soundPath];
    _instance.gameMusic=fileURL;
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
    if ([[[NSLocale preferredLanguages] objectAtIndex:0] isEqualToString:@"ru"]){
        soundPath = [[NSBundle mainBundle] pathForResource:@"excellent_ru" ofType:@"mp3"];
        _instance.excellent = [NSURL URLWithString:soundPath];
        soundPath = [[NSBundle mainBundle] pathForResource:@"well_done_ru" ofType:@"mp3"];
        _instance.well_done = [NSURL URLWithString:soundPath];
    }
    else{
        soundPath = [[NSBundle mainBundle] pathForResource:@"excellent" ofType:@"mp3"];
        _instance.excellent = [NSURL URLWithString:soundPath];
        soundPath = [[NSBundle mainBundle] pathForResource:@"well_done" ofType:@"mp3"];
        _instance.well_done = [NSURL URLWithString:soundPath];
    }

}


- (void) dealloc{
    _backGroundMusicPlayer=nil;
    _backGroundGamePlayer=nil;
    _soundPlayer=nil;
    _excellent=nil;
    _well_done=nil;
    _soundToPlay=nil;
}

#pragma mark - AudioPlayerDelegate

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (flag==YES) {
        if (_soundToPlay) {
            [_soundPlayer stop];
            _soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_soundToPlay error:nil];
            _soundPlayer.numberOfLoops=0;
            [_soundPlayer prepareToPlay];
            [_soundPlayer play];
            _soundToPlay=nil;
        }
    }
}


@end
