//
//  FPGameManager.h
//  FunnyPuzzle
//
//  Created by Stas Volskyi on 23.05.14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FPGameManager : NSObject

+ (FPGameManager*) sharedInstance;

@property (nonatomic) BOOL music;
@property (nonatomic) BOOL displayInnerBorders;
@property (nonatomic) BOOL playSoundWhenImageAppear;
@property (nonatomic) BOOL displayWords;
@property (nonatomic) BOOL vibrateWhenDragPuzzles;
@property (nonatomic) BOOL vibrateWhenPieceInPlace;

- (void) setSettings;
- (void) changeSettings:(BOOL)value forKey:(NSString*)key;

@end
