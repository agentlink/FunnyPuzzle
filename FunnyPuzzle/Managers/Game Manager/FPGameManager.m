//
//  FPGameManager.m
//  FunnyPuzzle
//
//  Created by Stas Volskyi on 23.05.14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import "FPGameManager.h"

@implementation FPGameManager{
    GADInterstitial *interstitial_;
}


static FPGameManager *_instance=nil;

+ (FPGameManager*) sharedInstance{
    @synchronized(self){
        if (nil==_instance) {
            _instance=[[self alloc] init];
            _instance->interstitial_ = [[GADInterstitial alloc] init];
            _instance->interstitial_.adUnitID = GOOGLE_ADMOBS_ID;
            [_instance->interstitial_ loadRequest:[GADRequest request]];
        }        
    }
    return _instance;
}

- (void) setSettings{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:MUSIC]) {
        [defaults setBool:YES forKey:VIBRATE_WHEN_DRAG_PUZZLES];
        [defaults setBool:YES forKey:VIBRATE_WHEN_PIECE_IN_PLACE];
        [defaults setBool:YES forKey:PLAY_SOUND_WHEN_IMAGE_APPEAR];
        [defaults setBool:YES forKey:DISPLAY_INNER_BORDERS];
        [defaults setBool:YES forKey:DISPLAY_WORDS];
        [defaults synchronize];
        _vibrateWhenDragPuzzles=YES;
        _vibrateWhenPieceInPlace=YES;
        _playSoundWhenImageAppear=YES;
        _displayWords=YES;
        _displayInnerBorders=YES;
    }
    else{
        _vibrateWhenDragPuzzles=[defaults boolForKey:VIBRATE_WHEN_DRAG_PUZZLES];
        _vibrateWhenPieceInPlace=[defaults boolForKey:VIBRATE_WHEN_PIECE_IN_PLACE];
        _playSoundWhenImageAppear=[defaults boolForKey:PLAY_SOUND_WHEN_IMAGE_APPEAR];
        _displayWords=[defaults boolForKey:DISPLAY_WORDS];
        _displayInnerBorders=[defaults boolForKey:DISPLAY_INNER_BORDERS];
    }
}

- (void) changeSettings:(BOOL)value forKey:(NSString*)key{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setBool:value forKey:key];
    [defaults synchronize];
}

@end
