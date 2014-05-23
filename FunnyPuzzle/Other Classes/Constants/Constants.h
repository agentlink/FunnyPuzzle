//
//  Constansts.h
//
//  Created by Misha on 20.05.14.
//  Copyright (c) 2014 KG. All rights reserved.
//

#ifndef FP_Constants_h
#define FP_Constants_h

#define DISPLAY_INNER_BORDERS @"displayInnerBorders"
#define PLAY_SOUND_WHEN_IMAGE_APPEAR @"playSoundWhenImageAppear"
#define DISPLAY_WORDS @"displayWords"
#define VIBRATE_WHEN_DRAG_PUZZLES @"vibrateWhenDragPuzzles"
#define VIBRATE_WHEN_PIECE_IN_PLACE @"vibrateWhenPieceInPlace"
#define MUSIC @"music"

#endif


#pragma mark - enums

typedef enum {
    FPGameModeEase,
    FPGameModeHard
}FPGameMode;

typedef enum {
    FPGameTypeFirs,
    FPGameTypeSecond,
    FPGameTypeBonus
}FPGameType;

typedef enum {
    apple,
    carrot,
    chicken,
    cochlea,
    dove,
    elephant,
    excellent,
    fish,
    icecream,
    lamb,
    octopus,
    owl,
    pencil,
    pig,
    rabbit,
    snail,
    squirrel,
    toad,
    wellDone
}FPGameSounds;
