//
//  FPObjectsManager.m
//  FunnyPuzzle
//
//  Created by Misha on 21.05.14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import "FPLevelManager.h"
#import "FPGameManager.h"

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
- (void)dealloc
{
    
}
- (void)parce
{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"Levels/items" ofType:@"plist"];
    _plist = [NSMutableArray arrayWithContentsOfFile:plistPath];
    _levels = [_plist objectAtIndex:_gameType];
    _levelDict = [_levels objectAtIndex:_level];
    [self initField:_levelDict];
}
- (void)memoryCareParce
{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"Levels/items" ofType:@"plist"];
    _plist = [NSMutableArray arrayWithContentsOfFile:plistPath];
    _mcLevel = [NSMutableDictionary new];
    _levels = [_plist objectAtIndex:_gameType];
    _levelDict = [_levels objectAtIndex:_level];
    [self mcInitField:_levelDict];
}
- (void)mcInitField:(NSMutableDictionary *)level
{
    _pathToLevel = [NSString stringWithFormat:@"Levels/%@",
                    [level valueForKey:@"folder"],
                    nil];
    _pathToColor = [NSString stringWithFormat:@"%@/%@", _pathToLevel, [level valueForKey:@"color"]];
    NSString *color = [NSString stringWithFormat:@"%@_result", _pathToColor];
    NSString *gray = [NSString stringWithFormat:@"%@_gray", _pathToColor];
    NSString *gray_lined = [NSString stringWithFormat:@"%@_bordered", _pathToColor];
    NSString *full = [NSString stringWithFormat:@"%@_full", _pathToColor];
    NSString *notFull = [NSString stringWithFormat:@"%@_not-full", _pathToColor];
    [_mcLevel setObject:color forKey:@"colorPath"];
    [_mcLevel setObject:gray forKey:@"grayPath"];
    [_mcLevel setObject:gray_lined forKey:@"gray_linedPath"];
    [_mcLevel setObject:full forKey:@"full"];
    [_mcLevel setObject:notFull forKey:@"notFull"];
    _levelName = [level valueForKey:@"name"];
    _mcElements = [self getMCSegmentsFromElements:[level valueForKey:@"elements"]];
    _soundURL = [self getSoundURL];
    
}
- (NSArray *)getMCSegmentsFromElements:(NSArray *)elements
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (int i = 0; i<elements.count; i++) {
        NSDictionary *element = [NSDictionary dictionaryWithDictionary:[elements objectAtIndex:i]];
        CGPoint nativePoint = CGPointMake([[[element valueForKey:@"point"] valueForKey:@"x"] floatValue], [[[element valueForKey:@"point"] valueForKey:@"y"] floatValue]);
        NSString *path = [NSString stringWithFormat:@"%@%i",
                          _pathToColor,
                          i, nil];
        [result addObject:@{@"path":path, @"nativePoint":[NSValue valueWithCGPoint:nativePoint]}];
    }
    return [NSArray arrayWithArray:result];
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
    NSString *suffix = [FPGameManager sharedInstance].language;
    NSString *path_ = [NSString stringWithFormat:@"%@/%@_%@.mp3",[[NSBundle mainBundle] resourcePath], _pathToColor, suffix];
    result = [NSURL fileURLWithPath:path_];
    return result;
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:path_ ofType:@"mp3"];
    if (fullPath) {
        result = [NSURL URLWithString:fullPath];
    } else {
        result = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:path_ ofType:@"mp3"]];
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
#pragma mark - Custom Accssesors
- (NSInteger)segmentsCount
{
    return _segments.count;
}
- (NSInteger)levelsCount
{
    return _levels.count;
}
#pragma mark - Class Methods

+(FPLevelManager *)loadLevelWithType:(FPGameType)type mode:(FPGameMode)mode level:(int)level
{
    FPLevelManager *manager = [FPLevelManager new];
    manager.gameType = type;
    manager.level = level;
    [manager parce];
    return manager;
}
+ (FPLevelManager *)loadLevel:(int)level type:(FPGameType)type
{
    FPLevelManager *manager = [FPLevelManager new];
    manager.gameType = type;
    manager.level = level;
    [manager memoryCareParce];
    return manager;
}
+ (NSArray *)allLevels:(FPGameType)gameType
{
    NSMutableArray *levels = [[NSMutableArray alloc] init];
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"Levels/items" ofType:@"plist"];
    NSMutableArray *_plist = [NSMutableArray arrayWithContentsOfFile:plistPath];
    NSMutableDictionary *_levels = [_plist objectAtIndex:gameType];
    for (NSDictionary *level in _levels) {
        NSString *color = [NSString stringWithFormat:@"Levels/%@/%@_result", [level valueForKey:@"folder"], [level valueForKey:@"color"]];
        NSString *gray = [NSString stringWithFormat:@"Levels/%@/%@_gray", [level valueForKey:@"folder"], [level valueForKey:@"color"]];
        NSString *gray_lined = [NSString stringWithFormat:@"Levels/%@/%@_bordered", [level valueForKey:@"folder"], [level valueForKey:@"color"]];
        NSString *full = [NSString stringWithFormat:@"Levels/%@/%@_full", [level valueForKey:@"folder"], [level valueForKey:@"color"]];
        NSString *notFull = [NSString stringWithFormat:@"Levels/%@/%@_not-full", [level valueForKey:@"folder"], [level valueForKey:@"color"]];
        [levels addObject:@{@"color": color, @"gray":gray, @"gray_lined":gray_lined, @"name":[level valueForKey:@"name"], @"full":full, @"notFull":notFull}];
    }
    return [NSArray arrayWithArray:levels];
}
@end
