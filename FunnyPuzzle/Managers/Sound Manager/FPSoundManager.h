//
//  FPSoundManager.h
//  Sound manager
//
//  Created by Stas Volskyi on 22.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioServices.h>

@interface FPSoundManager : NSObject

+ (FPSoundManager*)sharedInstance;

- (void) playBackgroundMusic;
- (void) stopBackgroundMusic;
- (void) playGameMusic;
- (void) stopGameMusic;
- (void) playSound:(NSURL*)sound;
- (void) playBlob;
- (void)playBlobUp;
- (void)playBlobDown;

@end
