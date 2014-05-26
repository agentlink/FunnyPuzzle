//
//  FPGameManager.m
//  FunnyPuzzle
//
//  Created by Stas Volskyi on 23.05.14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import "FPGameManager.h"

@interface FPGameManager()<GADInterstitialDelegate>{
    GADInterstitial *interstitial_;
}

@end

@implementation FPGameManager


static FPGameManager *_instance=nil;

+ (FPGameManager*) sharedInstance{
    @synchronized(self){
        if (nil==_instance) {
            _instance=[[self alloc] init];
            [_instance loadNewAdv];
        }        
    }
    return _instance;
}

- (void) setSettings{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:VIBRATE]) {
        [defaults setBool:YES forKey:VIBRATE];
        [defaults setBool:YES forKey:PLAY_SOUND_WHEN_IMAGE_APPEAR];
        [defaults setBool:YES forKey:DISPLAY_INNER_BORDERS];
        [defaults setBool:YES forKey:DISPLAY_WORDS];
        [defaults setBool:YES forKey:MUSIC];
        [defaults setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] forKey:LANGUAGE];
        [defaults setInteger:0 forKey:@"CurrentLevel"];
        [defaults setInteger:FPGameModeEase forKey:@"FPGameMode"];
        [defaults synchronize];
        _vibrate=YES;
        _playSoundWhenImageAppear=YES;
        _displayInnerBorders=YES;
        _language = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
        _currentLevel = 0;
        _gameMode = FPGameModeEase;
    }
    else{
        _vibrate=[defaults boolForKey:VIBRATE];
        _playSoundWhenImageAppear=[defaults boolForKey:PLAY_SOUND_WHEN_IMAGE_APPEAR];
        _displayInnerBorders=[defaults boolForKey:DISPLAY_INNER_BORDERS];
        _music=[defaults boolForKey:MUSIC];
        _currentLevel = (int)[defaults integerForKey:@"CurrentLevel"];
        _gameMode = (int)[defaults integerForKey:@"FPGameMode"];
        _language = [defaults objectForKey:LANGUAGE];
    }
}

- (void) changeSettings:(BOOL)value forKey:(NSString*)key{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setBool:value forKey:key];
    [defaults synchronize];
}

- (void) showFullScreenAdvertisment:(UIViewController*)viewController{
    [interstitial_ presentFromRootViewController:viewController];
}

- (void) loadNewAdv{
    _instance->interstitial_.delegate=nil;
    _instance->interstitial_=nil;
    _instance->interstitial_ = [[GADInterstitial alloc] init];    
    _instance->interstitial_.delegate=_instance;
    _instance->interstitial_.adUnitID = GOOGLE_ADMOBS_ID;
    [_instance->interstitial_ loadRequest:[GADRequest request]];
}

#pragma mark - GADInterstitialDelegate

- (void) interstitialDidReceiveAd:(GADInterstitial *)ad{
    
}

- (void) interstitialDidDismissScreen:(GADInterstitial *)ad{
    [_instance loadNewAdv];
}

@end
