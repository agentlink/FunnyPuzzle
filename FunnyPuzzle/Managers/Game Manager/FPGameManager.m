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
                                   @"Español",
                                   @"Українська",
                                   @"हिन्दी",
                                   @"汉语",
                                   @"العربية",
                                   @"Magyar"];
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
        [defaults setInteger:0 forKey:CANDIES_COUNT];
        [defaults setObject:[self getDefaultLanguage] forKey:LANGUAGE];
        [defaults synchronize];
        _vibrate=YES;
        _playSoundWhenImageAppear=YES;
        _displayInnerBorders=YES;
        _candiesCount = 0;
        _language = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
    }
    else{
        _vibrate=[defaults boolForKey:VIBRATE];
        _playSoundWhenImageAppear=[defaults boolForKey:PLAY_SOUND_WHEN_IMAGE_APPEAR];
        _displayInnerBorders=[defaults boolForKey:DISPLAY_INNER_BORDERS];
        _music=[defaults boolForKey:MUSIC];
        _language = [defaults objectForKey:LANGUAGE];
        _candiesCount = (int)[defaults integerForKey:CANDIES_COUNT];
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
    else if ([language_ isEqualToString:@"Українська"]) {
        return @"uk";
    }
    else if ([language_ isEqualToString:@"Magyar"]) {
        return @"hu";
    }
    else if ([language_ isEqualToString:@"हिन्दी"]) {
        return @"hi";
    }
    else if ([language_ isEqualToString:@"汉语"]) {
        return @"zh-Hant";
    }
    else if ([language_ isEqualToString:@"العربية"]) {
        return @"ar";
    }
    return @"en";
}

- (NSArray*) getLanguages{
    return _instance.languages;
}

- (void) pickUpCandies:(int)candies{
    _candiesCount+=candies;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:_candiesCount forKey:@"candiesCount"];
    [defaults synchronize];
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
