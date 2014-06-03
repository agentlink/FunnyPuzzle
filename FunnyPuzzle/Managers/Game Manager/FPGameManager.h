                                                                                                                                                                                                                                                                                                                                                                                            //
//  FPGameManager.h
//  FunnyPuzzle
//
//  Created by Stas Volskyi on 23.05.14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GADInterstitial.h"

@interface FPGameManager : NSObject

+ (FPGameManager*) sharedInstance;

@property (nonatomic) BOOL music;
@property (nonatomic) BOOL displayInnerBorders;
@property (nonatomic) BOOL playSoundWhenImageAppear;
@property (nonatomic) BOOL vibrate;
@property (nonatomic, weak) NSString* language;
@property (nonatomic) int CandiesCount;

- (void) setSettings;
- (void) changeSettings:(BOOL)value forKey:(NSString*)key;
- (void) showFullScreenAdvertisment:(UIViewController*)viewController;
- (NSArray*) getLanguages;
@end
