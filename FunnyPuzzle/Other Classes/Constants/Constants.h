//
//  Constansts.h
//
//  Created by Misha on 20.05.14.
//  Copyright (c) 2014 KG. All rights reserved.
//
#ifndef FP_Constants_h
#define FP_Constants_h

//UserDefaults
#define DISPLAY_INNER_BORDERS @"displayInnerBorders"
#define PLAY_SOUND_WHEN_IMAGE_APPEAR @"playSoundWhenImageAppear"
#define DISPLAY_WORDS @"displayWords"
#define VIBRATE @"vibrate"
#define MUSIC @"music"
#define LANGUAGE @"language"

//AdMob ID
#define GOOGLE_ADMOBS_ID @"ca-app-pub-1787934849363418/8173411882"

#endif

#pragma mark - enums

typedef enum {
    FPGameModeEase = 0,
    FPGameModeHard
}FPGameMode;

typedef enum {
    FPGameTypeFirs,
    FPGameTypeSecond,
    FPGameTypeBonus
}FPGameType;

typedef enum {
    VibrateModeDragOrDrop,
    VibrateModeInPlace
}FPVibrateMode;

