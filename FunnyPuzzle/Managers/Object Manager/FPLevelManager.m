//
//  FPObjectsManager.m
//  FunnyPuzzle
//
//  Created by Misha on 21.05.14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import "FPLevelManager.h"
@interface FPLevelManager ()
@property (nonatomic, strong) NSMutableArray *levels;
@property (nonatomic) NSMutableArray *plist;
@property (nonatomic) float multiplayer;
@property (nonatomic) NSString *pathToColor;
@property (nonatomic) NSString *folderName;
@property (nonatomic) NSString *pathToLevel;
@property (nonatomic) NSMutableDictionary *levelDict;

@end

@implementation FPLevelManager
@synthesize multiplayer;
- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)parce
{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"Levels/items" ofType:@"plist"];
    _plist = [NSMutableArray arrayWithContentsOfFile:plistPath];
    _levels = [_plist objectAtIndex:_gameType];
    _levelDict = [_levels objectAtIndex:_level];
    [self initField:_levelDict];
}
- (void)initField:(NSMutableDictionary *)level
{
    _pathToLevel = [NSString stringWithFormat:@"Levels/%@",
                    [level valueForKey:@"folder"],
                    nil];
    _pathToColor = [NSString stringWithFormat:@"%@/%@", _pathToLevel, [level valueForKey:@"color"]];
    PDFImage *color = [PDFImage imageNamed:[NSString stringWithFormat:@"%@_result", _pathToColor]];
    PDFImage *gray = [PDFImage imageNamed:[NSString stringWithFormat:@"%@_gray", _pathToColor]];
    PDFImage *gray_lined = [PDFImage imageNamed:[NSString stringWithFormat:@"%@_bordered", _pathToColor]];
    [self calcMultiplayerFromSize:color.size];
    _fieldFrame = [self getAdaptedRectFromSize:color.size];
    _colorField = [[PDFImageView alloc] initWithFrame:_fieldFrame];
    _grayField = [[PDFImageView alloc] initWithFrame:_fieldFrame];
    _grayLinedFiewld = [[PDFImageView alloc] initWithFrame:_fieldFrame];
    _colorField.image = color;
    _grayField.image = gray;
    _grayLinedFiewld.image = gray_lined;
    _levelName = [level valueForKey:@"name"];
    _segments = [self getSegmentsFromElements:[level valueForKey:@"elements"]];
    _soundURL = [self getSoundURL];
    
}
- (NSArray *)getSegmentsFromElements:(NSArray *)elements
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (int i = 0; i<elements.count; i++) {
        NSDictionary *element = [NSDictionary dictionaryWithDictionary:[elements objectAtIndex:i]];
        CGPoint nativePoint = CGPointMake([[[element valueForKey:@"point"] valueForKey:@"x"] floatValue], [[[element valueForKey:@"point"] valueForKey:@"y"] floatValue]);
        NSString *path = [NSString stringWithFormat:@"%@%i",
                          _pathToColor,
                          i, nil];
        
        PDFImage *image = [PDFImage imageNamed:path];
        CGRect adaptedFrame = CGRectMake(((nativePoint.x)*multiplayer)+CGRectGetMinX(_fieldFrame), ((nativePoint.y)*multiplayer)+CGRectGetMinY(_fieldFrame), image.size.width*multiplayer, image.size.height*multiplayer);
        Segment *segment = [[Segment alloc] initWithFrame:[self getAdaptedRectFromSize:image.size]];
        segment.image = image;
        segment.rect = adaptedFrame;
        //segment.backgroundColor = [UIColor redColor];
        [result addObject:segment];
    }
    return [NSArray arrayWithArray:result];
}
- (CGRect)getAdaptedRectFromSize:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width*multiplayer, size.height*multiplayer);
    return rect;
}
- (void)configFields:(NSDictionary *)level
{
    PDFImage *color = [PDFImage imageNamed:[NSString stringWithFormat:@"Levels/%@/%@", [level valueForKey:@"folder"], [level valueForKey:@"color"]]];
    [self calcMultiplayer:CGRectMake(0, 0, color.size.width, color.size.height)];
    PDFImage *gray = [PDFImage imageNamed:[NSString stringWithFormat:@"Levels/%@/%@", [level valueForKey:@"folder"], [level valueForKey:@"gray"]]];
    PDFImage *gray_lined = [PDFImage imageNamed:[NSString stringWithFormat:@"Levels/%@/%@", [level valueForKey:@"folder"], [level valueForKey:@"gray_lined"]]];
    CGRect rect = CGRectMake(0, 0, color.size.width*multiplayer, color.size.height*multiplayer);
    _colorField = [[PDFImageView alloc] initWithFrame:rect];
    _colorField.image = color;
    _grayField = [[PDFImageView alloc] initWithFrame:rect];
    _grayField.image = gray;
    _grayLinedFiewld = [[PDFImageView alloc] initWithFrame:rect];
    _grayLinedFiewld.image = gray_lined;
}

- (void)calcMultiplayerFromSize:(CGSize)size
{
    if (size.width>=size.height)
    {
        multiplayer = 280/size.width;
    }
    /*else if (size.height>=size.width)
    {
        multiplayer = 280/size.height;
    }*/ else {
        multiplayer = 280/size.height;
    }
}
- (NSURL *)getSoundURL
{
    NSURL *result;
    NSString *suffix = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *path_ = [NSString stringWithFormat:@"%@_%@", _pathToColor, suffix];
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:path_ ofType:@"mp3"];
    if (fullPath) {
        result = [NSURL URLWithString:fullPath];
    } else {
        result = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:_pathToColor ofType:@"mp3"]];
    }
    return result;
}
- (void)calcMultiplayer:(CGRect)rect
{
    if (rect.size.width>=rect.size.height)
    {
        multiplayer = 280/rect.size.width;
    }
    else if (rect.size.height>=rect.size.width)
    {
        multiplayer = 280/rect.size.height;
    } else {
        multiplayer = 1.0f;
    }
}
- (CGRect)getAdaptedRectFromRect:(CGRect)rect
{
    CGRect result;
    result.size.height = rect.size.height*multiplayer;
    result.size.width = rect.size.width*multiplayer;
    return result;
}

#pragma mark - Custom Accssesors
- (NSInteger)segmentsCount
{
    return _segments.count;
}
- (NSInteger)levelsCount
{
    return _levels.count;
}
#pragma mark - Publick Medoths

+(FPLevelManager *)gameObjectsWithType:(FPGameType)type mode:(FPGameMode)mode level:(int)level
{
    FPLevelManager *manager = [FPLevelManager new];
    manager.gameType = type;
    manager.level = level;
    [manager parce];
    return manager;
}
@end
