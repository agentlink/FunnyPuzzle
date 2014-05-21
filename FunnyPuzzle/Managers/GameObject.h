//
//  KGGameObject.h
//  KG
//
//  Created by Misha on 20.05.14.
//  Copyright (c) 2014 KG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constansts.h"

@interface GameObject : NSObject
@property (nonatomic) FPGameMode *gameMode;
@property (nonatomic) FPGameType *gameType;
@property (nonatomic) int points;

+ (GameObject *)sharedInstance;
@end
