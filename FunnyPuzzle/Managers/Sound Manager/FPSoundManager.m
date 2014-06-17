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
@property (nonatomic, weak) NSTimer *backgoroundMusicTimer;
@property (nonatomic, weak) NSTimer *gameMusicMusicTimer;
@property (nonatomic) BOOL gameVolumeUp;
@property (nonatomic) BOOL backgroundVolumeUp;

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
    if ([FPGameManager sharedInstance].music==YES) {
        NSError *error;
        _backGroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_instance.backGroundMusic error:&error];
        _backGroundMusicPlayer.numberOfLoops=-1;
        [_backGroundMusicPlayer prepareToPlay];
        _backgoroundMusicTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(changeBackgroundVolume) userInfo:nil repeats:YES];
        _backgroundVolumeUp=YES;
        _backGroundMusicPlayer.volume=0;
        [_backGroundMusicPlayer play];
    }
}

- (void) stopBackgroundMusic{
    if ([_backGroundMusicPlayer isPlaying]==YES){
        _backgoroundMusicTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeBackgroundVolume) userInfo:nil repeats:YES];
        _backgroundVolumeUp=NO;
        _backGroundMusicPlayer.volume = 0.6;
    }
}

- (void) playGameMusic{
    if ([FPGameManager sharedInstance].music==YES) {
        NSError *error;
        _backGroundGamePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_instance.gameMusic error:&error];
        _backGroundGamePlayer.numberOfLoops=-1;
        [_backGroundGamePlayer prepareToPlay];
        _gameMusicMusicTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(changeGameVolume) userInfo:nil repeats:YES];
        _gameVolumeUp=YES;
        _backGroundGamePlayer.volume=0;
        [_backGroundGamePlayer play];;
    }
}

- (void) stopGameMusic{
    if ([_backGroundGamePlayer isPlaying]==YES){
        _gameMusicMusicTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeGameVolume) userInfo:nil repeats:YES];
        _gameVolumeUp=NO;
        _backGroundGamePlayer.volume = 0.6;
    }
}

- (void) playSound:(NSURL*)sound{
    if ([FPGameManager sharedInstance].playSoundWhenImageAppear==YES){
        NSError *error;
        [_soundPlayer stop];
        _soundToPlay = sound;
        _soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:sound error:&error];
        //_soundPlayer.delegate=(id)self;
        [_soundPlayer prepareToPlay];
        [_soundPlayer play];

//        NSURL *url;
//        int random=1+arc4random()%2;
//        if (random==1) {
//            url=_well_done;
//        }
//        else{
//            url=_excellent;
//        }
//        _soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
//        _soundPlayer.delegate=(id)self;
//        [_soundPlayer prepareToPlay];
//        [_soundPlayer play];
    }
}

- (void)playPraise
{
    NSArray *allPrices = @[/*@"excellent", */@"good_job", @"perfect", @"well_done", @"wonderfull"];
    NSString *suffix = [FPGameManager sharedInstance].language;
    NSUInteger soundIndex = arc4random_uniform(allPrices.count);
    NSURL *soundURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@Levels/Price/%@_%@.mp3", [[NSBundle mainBundle] resourcePath], allPrices[soundIndex], suffix]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[soundURL path]])
        [self playSound:soundURL];
    else
        [self playSound:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/Levels/Price/%@.mp3", [[NSBundle mainBundle] resourcePath], allPrices[soundIndex]]]];
}

- (void) vibrateWithMode:(FPVibrateMode)vibrateMode{
    if ([FPGameManager sharedInstance].vibrate==YES){
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        NSMutableArray* arr = [NSMutableArray array ];
        switch (vibrateMode) {
            case VibrateModeDragOrDrop:{
                [arr addObject:[NSNumber numberWithBool:YES]];
                [arr addObject:[NSNumber numberWithInt:50]];
            }
            break;
            case VibrateModeInPlace:{
                [arr addObject:[NSNumber numberWithBool:YES]]; //vibrate for 2000ms
                [arr addObject:[NSNumber numberWithInt:50]];
                [arr addObject:[NSNumber numberWithBool:NO]];  //stop for 1000ms
                [arr addObject:[NSNumber numberWithInt:100]];
                [arr addObject:[NSNumber numberWithBool:YES]];  //vibrate for 1000ms
                [arr addObject:[NSNumber numberWithInt:50]];
            }
            break;
        }
        [dict setObject:arr forKey:@"VibePattern"];
        [dict setObject:[NSNumber numberWithInt:1] forKey:@"Intensity"];
       // AudioServicesPlaySystemSoundWithVibration(4095,nil,dict);
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
    
    if ([[FPGameManager sharedInstance].language isEqualToString:@"ru"]){
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

int timerTick;

- (void) changeBackgroundVolume{
    if (_backgroundVolumeUp) {
        _backGroundMusicPlayer.volume+=0.05;
    }
    else {
        _backGroundMusicPlayer.volume-=0.05;
    }
    if (!_backgroundVolumeUp) {
         if (_backGroundMusicPlayer.volume<=0.05){
            [_backGroundMusicPlayer stop];
            _backGroundMusicPlayer=nil;
            [_backgoroundMusicTimer invalidate];
        }
    }
    else {
        if (_backGroundMusicPlayer.volume>=0.95){
            [_backgoroundMusicTimer invalidate];
        }
    }
}

- (void) changeGameVolume{
    if (_gameVolumeUp) {
        _backGroundGamePlayer.volume+=0.05;
    }
    else {
        _backGroundGamePlayer.volume-=0.05;
    }
    if (!_gameVolumeUp) {
        if (_backGroundGamePlayer.volume<=0.05){
            [_backGroundGamePlayer stop];
            _backGroundGamePlayer=nil;
            [_gameMusicMusicTimer invalidate];
        }
    }
    else {
        if (_backGroundGamePlayer.volume>=0.95){
            [_gameMusicMusicTimer invalidate];
        }
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
