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

@property (nonatomic, strong) NSDictionary *languages;
@property (nonatomic, strong) NSArray *langCodes;

@end

@implementation FPGameManager


static FPGameManager *_instance=nil;

+ (FPGameManager*) sharedInstance{
    @synchronized(self){
        if (nil==_instance) {
            _instance=[[self alloc] init];
            [_instance loadNewAdv];
            _instance.languages = @{@"en":@"English",
                                   @"ru":@"Русский",
                                    @"uk":@"Українська",
                                   @"fr":@"Français",
                                   @"de":@"Deutschland",
                                   @"es":@"Español",
                                   @"uk":@"Українська",
                                   @"hi":@"हिन्दी",
                                   @"zh-Hant":@"汉语",
                                   @"ar":@"العربية",
                                   @"hu":@"Magyar"};
            _instance.langCodes = @[@"en",@"ru", @"uk", @"fr",@"de",@"es",@"uk",@"hi",@"zh-Hant",@"ar",@"hu"];
        }
    }
    return _instance;
}
#pragma mark - Custom Accssesors

- (void) setSettings{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:CANDIES_COUNT]) {
        [defaults setBool:YES forKey:PLAY_SOUND_WHEN_IMAGE_APPEAR];
        [defaults setBool:YES forKey:DISPLAY_INNER_BORDERS];
        [defaults setBool:YES forKey:DISPLAY_WORDS];
        [defaults setBool:YES forKey:MUSIC];
        [defaults setInteger:0 forKey:CANDIES_COUNT];
        [defaults setObject:[self getDefaultLanguage] forKey:LANGUAGE];
        NSMutableArray *bonusLvl = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:0],
                                                                    [NSNumber numberWithInt:0],
                                                                    [NSNumber numberWithInt:0],  nil];
        [defaults setObject:bonusLvl forKey:@"bonusLvl"];
        [defaults synchronize];
        _playSoundWhenImageAppear=YES;
        _displayInnerBorders=YES;
        self.candiesCount = 0;
        _BonusLevels = bonusLvl;
        _language = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
    }
    else{
        _BonusLevels = [defaults objectForKey:@"bonusLvl"];
        _playSoundWhenImageAppear=[defaults boolForKey:PLAY_SOUND_WHEN_IMAGE_APPEAR];
        _displayInnerBorders=[defaults boolForKey:DISPLAY_INNER_BORDERS];
        _music=[defaults boolForKey:MUSIC];
        _language = [defaults objectForKey:LANGUAGE];
        self.candiesCount = (int)[defaults integerForKey:CANDIES_COUNT];
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
            if ([[_instance.langCodes objectAtIndex:i] isEqualToString:defaultLanguage]) {
                return defaultLanguage;
            }
        }
    }
    return @"en";
}

- (NSDictionary*) getLanguages{
    return _instance.languages;
}

- (NSArray*) getLanguagesCodes{
    return _langCodes;
}

- (void) pickUpCandies:(int)candies{
    self.candiesCount+=candies;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:self.candiesCount forKey:@"candiesCount"];
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
