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

@interface FPObjectsManager : NSObject

@property (nonatomic, strong) NSArray *segments;
@property (nonatomic) NSArray *segmentsStrings;
@property (nonatomic, strong) PDFImageView *colorField;
@property (nonatomic, strong) PDFImageView *grayField;
@property (nonatomic, strong) PDFImageView *grayLinedFiewld;
@property (nonatomic) FPGameType gameType;
@property (nonatomic) int level;
@property (nonatomic) NSString *levelName;
@property (nonatomic) NSURL *soundURL;
@property (nonatomic) CGRect fieldFrame;
//@property (nonatomic, strong)

+(FPObjectsManager *)gameObjectsWithType:(FPGameType)type mode:(FPGameMode)mode level:(int)level;
@end
