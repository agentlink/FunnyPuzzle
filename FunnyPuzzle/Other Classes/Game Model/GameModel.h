//
//  KGGameObject.h
//  KG
//
//  Created by Misha on 20.05.14.
//  Copyright (c) 2014 KG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPObjectsManager.h"
#import "FPGameManager.h"

@interface GameModel : NSObject

@property (nonatomic) FPGameMode *gameMode;
@property (nonatomic) FPGameType *gameType;
@property (nonatomic) int points;
@property (nonatomic, strong) FPObjectsManager *manager;
@property (nonatomic) CGRect fieldFrame;
@property (nonatomic) CGPoint fieldOrigin;
@property (nonatomic) PDFImageView *currentField;

- (void)checkForRightPlace:(Segment *)segment;
+ (GameModel *)sharedInstance;

@end
