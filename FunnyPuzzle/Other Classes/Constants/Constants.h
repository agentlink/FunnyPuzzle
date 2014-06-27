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
#define MUSIC @"music"
#define LANGUAGE @"language"
#define CANDIES_COUNT @"candiesCount"

//AdMob ID
#define GOOGLE_ADMOBS_ID @"ca-app-pub-1787934849363418/8173411882"

#define ITUNES_LINK @"https://itunes.apple.com/us/app/funny-puzzle/id892755717"
#define RATE_APP_LINK @"https://itunes.apple.com/ua/app/tic-tac-toe-online/id885035754?mt=8"

#define CLIENT_ID @"640872702054-144cgnd8ukdb2s0vf2b22oc1dmg22q6v.apps.googleusercontent.com"

#endif

#pragma mark - enums

typedef enum {
    FPGameModeEase = 0,
    FPGameModeHard
}FPGameMode;

typedef enum {
    FPGameTypeFirst,
    FPGameTypeSecond,
    FPGameTypeBonus
}FPGameType;

typedef enum {
    FPGameplayAnimationModeLevelCompleet,
    FPGameplayAnimationModeNewLevel,
}FPGameplayAnimationMode;
//AnimationDuration
typedef enum {
    VibrateModeDragOrDrop,
    VibrateModeInPlace
}FPVibrateMode;
typedef NS_ENUM (int, FPSoundBlobType)
{
    FPSoundBlobTypeOnce,
    FPSoundBlobTypeTwice,
    FPSoundBlobTypeApear
};
typedef NS_ENUM (int, FPGameplayNavigationType)
{
    FPGameplayNavigationTypeNone,
    FPGameplayNavigationTypeNext,
    FPGameplayNavigationTypePrew,
    FPGameplayNavigationTypeNextPrew
};

static double kAnimationDuration = 0.3;

//static const double kAnimationDuration = 0.3f;

static NSString *FPLocalizedTable = @"Localizable";

#pragma mark - Views tag
typedef enum {
    FPTagRay = 42,
    FPTagBasket,
    FPTagWinImageFiled
} FPTag;
