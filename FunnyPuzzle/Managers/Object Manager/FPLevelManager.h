 //
//  FPObjectsManager.h
//  FunnyPuzzle
//
//  Created by Misha on 21.05.14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PDFImage/PDFImage.h>
#import "Segment.h"

@interface FPLevelManager : NSObject

@property (nonatomic, strong) NSArray *segments;
@property (nonatomic, strong) NSArray *mcElements;
@property (nonatomic, strong) PDFImageView *colorField;
@property (nonatomic, strong) PDFImageView *grayField;
@property (nonatomic, strong) PDFImageView *grayLinedFiewld;
@property (nonatomic) FPGameType gameType;
@property (nonatomic) int level;
@property (nonatomic) NSString *levelName;
@property (nonatomic) NSURL *soundURL;
@property (nonatomic) CGRect fieldFrame;
@property (nonatomic, readonly) NSInteger segmentsCount;
@property (nonatomic, readonly) NSInteger levelsCount;
@property (nonatomic, readonly) NSMutableDictionary *mcLevel;


+ (FPLevelManager *)loadLevelWithType:(FPGameType)type mode:(FPGameMode)mode level:(int)level;
+ (FPLevelManager *)loadLevel:(int)level type:(FPGameType)type;
+ (NSArray *)allLevels:(FPGameType)gameType;
@end
