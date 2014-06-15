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

@property (nonatomic, strong) NSArray *languages;

@end

@implementation FPGameManager


static FPGameManager *_instance=nil;

+ (FPGameManager*) sharedInstance{
    @synchronized(self){
        if (nil==_instance) {
            _instance=[[self alloc] init];
            [_instance loadNewAdv];
            _instance.languages= @[@"English",
                                   @"Русский",
                                   @"Français",
                                   @"Deutschland",
                                   @"Español"];
        }
    }
    return _instance;
}

-(void)setCandiesCount:(int)CandiesCount
{
    _CandiesCount+=CandiesCount;
}
- (void) setSettings{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:VIBRATE]) {
        [defaults setBool:YES forKey:VIBRATE];
        [defaults setBool:YES forKey:PLAY_SOUND_WHEN_IMAGE_APPEAR];
        [defaults setBool:YES forKey:DISPLAY_INNER_BORDERS];
        [defaults setBool:YES forKey:DISPLAY_WORDS];
        [defaults setBool:YES forKey:MUSIC];
        [defaults setObject:[self getDefaultLanguage] forKey:LANGUAGE];
        [defaults synchronize];
        _vibrate=YES;
        _playSoundWhenImageAppear=YES;
        _displayInnerBorders=YES;
        _language = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
    }
    else{
        _vibrate=[defaults boolForKey:VIBRATE];
        _playSoundWhenImageAppear=[defaults boolForKey:PLAY_SOUND_WHEN_IMAGE_APPEAR];
        _displayInnerBorders=[defaults boolForKey:DISPLAY_INNER_BORDERS];
        _music=[defaults boolForKey:MUSIC];
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

- (NSString*) getDefaultLanguage{
    NSString *defaultLanguage;
    NSArray *iPhoneLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    for (int j=0; j<iPhoneLanguages.count; j++) {
        defaultLanguage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:j];
        for (int i=0; i<_instance.languages.count; i++) {
            if ([[_instance languageCode:[_instance.languages objectAtIndex:i]] isEqualToString:defaultLanguage]) {
                return defaultLanguage;
            }
        }
    }
    return @"en";
}

- (NSString*) languageCode:(NSString*)language_{
    
    if ([language_ isEqualToString:@"English"]) {
        return @"en";
    }
    else if ([language_ isEqualToString:@"Русский"]) {
        return @"ru";
    }
    else if ([language_ isEqualToString:@"Français"]) {
        return @"fr";
    }
    else if ([language_ isEqualToString:@"Deutschland"]) {
        return @"de";
    }
    else if ([language_ isEqualToString:@"Español"]) {
        return @"es";
    }
    return @"en";
}

- (NSArray*) getLanguages{
    return _instance.languages;
}

         
- (void) dealloc{
    _instance.languages=nil;
}

#pragma mark - GADInterstitialDelegate

- (void) interstitialDidReceiveAd:(GADInterstitial *)ad{
    
}

- (void) interstitialDidDismissScreen:(GADInterstitial *)ad{
    [_instance loadNewAdv];
}

@end
