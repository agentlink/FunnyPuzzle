//
//  FPSoundManager.h
//  Sound manager
//
//  Created by Stas Volskyi on 22.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface FPSoundManager : NSObject

@property (nonatomic, strong) AVAudioPlayer *backGroundMusicPlayer;
@property (nonatomic, strong) AVAudioPlayer *exelentSoundPlayer;

@property (nonatomic, strong) NSURL *soundWin;
@property (nonatomic, strong) NSURL *soundWin1;


+ (FPSoundManager*)sharedInstance;

- (void) playMusic;
- (void) stopMusic;
- (void) playSound:(FPGameSounds)sound;

@end
