//
//  KGGameObject.h
//  KG
//
//  Created by Misha on 20.05.14.
//  Copyright (c) 2014 KG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPLevelManager.h"
#import "GamePlayViewController.h"

@interface GameModel : NSObject

@property (nonatomic) FPGameMode gameMode;
@property (nonatomic) FPGameType gameType;
@property (nonatomic) int lastLevel;
@property (nonatomic) BOOL levelCompleet;
@property (nonatomic, strong) FPLevelManager *level;
@property (nonatomic) CGRect fieldFrame;
@property (nonatomic) CGPoint fieldOrigin;
@property (nonatomic) PDFImageView *currentField;
@property (nonatomic, weak) GamePlayViewController *gamePlayViewController;
@property (nonatomic) NSInteger objectsLeft;

- (void)checkForRightPlace:(Segment *)segment;
- (FPLevelManager *)nextLevel;
- (FPLevelManager *)prewLevel;
- (CGRect)calcRect:(Segment *)segment;


- (void)itemSelected;
- (void)itemDrop;
- (void)itemDropInPlace;
- (void)itemWillSelectFromPlace;
- (void)levelComplet;


+ (GameModel *)sharedInstance;

@end
