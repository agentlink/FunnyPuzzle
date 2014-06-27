//
//  FPObjectsManager.m
//  FunnyPuzzle
//
//  Created by Misha on 21.05.14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import "FPLevelManager.h"
#import "FPGameManager.h"
@interface Level : NSObject
@property (nonatomic) NSString *levelName;
@property (nonatomic) NSString *colorPath;
@property (nonatomic) NSString *grayPath;
@property (nonatomic) NSString *borderedPath;
@property (nonatomic) NSString *fullPath;
@property (nonatomic) NSString *notFullPath;
@property (nonatomic) int levelNumber;
@property (nonatomic) BOOL compleet;
@end

@implementation Level
@end

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
#pragma makr - Custom Accssesors

#pragma mark - Private
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

    NSString *documentsPlist = [FPLevelManager itemsPlistPath];
    _plist = [NSMutableArray arrayWithContentsOfFile:documentsPlist];
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
    _levelDone = [[FPLevelManager getLevelCompletation:level] boolValue];
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
    PDFImage *color = [PDFImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@_result", _pathToColor]];
    PDFImage *gray = [PDFImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@_gray", _pathToColor]];
    PDFImage *gray_lined = [PDFImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@_bordered", _pathToColor]];
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
        
        PDFImage *image = [PDFImage imageWithContentsOfFile:path];
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
    PDFImage *color = [PDFImage imageWithContentsOfFile:[NSString stringWithFormat:@"Levels/%@/%@", [level valueForKey:@"folder"], [level valueForKey:@"color"]]];
    [self calcMultiplayer:CGRectMake(0, 0, color.size.width, color.size.height)];
    PDFImage *gray = [PDFImage imageWithContentsOfFile:[NSString stringWithFormat:@"Levels/%@/%@", [level valueForKey:@"folder"], [level valueForKey:@"gray"]]];
    PDFImage *gray_lined = [PDFImage imageWithContentsOfFile:[NSString stringWithFormat:@"Levels/%@/%@", [level valueForKey:@"folder"], [level valueForKey:@"gray_lined"]]];
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
    NSString *suffix = [[FPGameManager sharedInstance].language isEqualToString:@"en"] ? @"" :     [NSString stringWithFormat:@"_%@", [FPGameManager sharedInstance].language];
    NSString *path_ = [NSString stringWithFormat:@"%@/%@%@.mp3",[[NSBundle mainBundle] resourcePath], _pathToColor, suffix];
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

+ (NSString *)itemsPlistPath
{
    NSString *pathInDocument = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    pathInDocument = [pathInDocument stringByAppendingString:@"/items.plist"];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:pathInDocument])
    {
        NSString *source = [[NSBundle mainBundle] pathForResource:@"Levels/items" ofType:@"plist"];
        NSError *error;
        [fileManager copyItemAtPath:source toPath:pathInDocument error:&error];
    }
    return pathInDocument;
}

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
    FPLevelManager *manager = [[FPLevelManager alloc] init];
    manager.gameType = type;
    manager.level = level;
    [manager memoryCareParce];
    return manager;
}
+ (NSArray *)allLevels:(FPGameType)gameType
{
    NSMutableArray *levels = [[NSMutableArray alloc] init];
    NSString* plistPath = [FPLevelManager itemsPlistPath];
    NSMutableArray *_plist = [NSMutableArray arrayWithContentsOfFile:plistPath];
    NSMutableDictionary *_levels = [_plist objectAtIndex:gameType];
    for (NSDictionary *level in _levels) { //        Level *levelObj = [Level new];
//        levelObj.colorPath = [NSString stringWithFormat:@"Levels/%@/%@_result", [level valueForKey:@"folder"], [level valueForKey:@"color"]];
//        levelObj.grayPath =  [NSString stringWithFormat:@"Levels/%@/%@_gray", [level valueForKey:@"folder"], [level valueForKey:@"color"]];
//        levelObj.borderedPath = [NSString stringWithFormat:@"Levels/%@/%@_bordered", [level valueForKey:@"folder"], [level valueForKey:@"color"]];
//        levelObj.fullPath = [NSString stringWithFormat:@"Levels/%@/%@_not-full", [level valueForKey:@"folder"], [level valueForKey:@"color"]];
//        levelObj.notFullPath = [NSString stringWithFormat:@"Levels/%@/%@_not-full", [level valueForKey:@"folder"], [level valueForKey:@"color"]];
//        levelObj.compleet = [[level valueForKey:@"compleet"] boolValue];
//        [levels addObject:level];
        NSString *color = [NSString stringWithFormat:@"Levels/%@/%@_result", [level valueForKey:@"folder"], [level valueForKey:@"color"]];
        NSString *gray = [NSString stringWithFormat:@"Levels/%@/%@_gray", [level valueForKey:@"folder"], [level valueForKey:@"color"]];
        NSString *gray_lined = [NSString stringWithFormat:@"Levels/%@/%@_bordered", [level valueForKey:@"folder"], [level valueForKey:@"color"]];
        NSString *full = [NSString stringWithFormat:@"Levels/%@/%@_full", [level valueForKey:@"folder"], [level valueForKey:@"color"]];
        NSString *notFull = [NSString stringWithFormat:@"Levels/%@/%@_not-full", [level valueForKey:@"folder"], [level valueForKey:@"color"]];
        NSNumber *compleet = [self getLevelCompletation:level];
        [levels addObject:@{@"color": color, @"gray":gray, @"gray_lined":gray_lined, @"name":[level valueForKey:@"name"], @"full":full, @"notFull":notFull, @"compleet":compleet}];
    }
    return [NSArray arrayWithArray:levels];
}
+ (NSNumber *)getLevelCompletation:(NSDictionary *)level
{
    return [level valueForKey:[FPGameManager sharedInstance].language]?@1:@0;
}

#pragma mark - Private
+ (NSString *)localStringForKey:(NSString *)key
{
    NSBundle *bundle =[ NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[[NSUserDefaults standardUserDefaults] objectForKey:LANGUAGE] ofType:@"lproj"]];
        return  NSLocalizedStringFromTableInBundle(key, @"altLocalization", bundle, nil);
}

#pragma mark - Class Methods
+ (NSString *)gameLocalizedStringForKey:(NSString *)key
{
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[FPGameManager sharedInstance].language ofType:@"lproj"]];

    NSString *result = NSLocalizedStringFromTableInBundle(key, @"Localizable", bundle, nil);

    return result;
}
+ (PDFImage *)imageNamed:(NSString *)name
{
    NSString *resourcesPath = [[NSBundle mainBundle] resourcePath];
    resourcesPath = [resourcesPath stringByAppendingString:[NSString stringWithFormat:@"/%@.pdf",name]];
    return [PDFImage imageWithContentsOfFile:resourcesPath];
}
+ (void)saveLevel:(NSUInteger)level gameType:(FPGameType)type
{
    NSString *plistFile = [FPLevelManager itemsPlistPath];
    NSMutableArray *savedLevels = [NSMutableArray arrayWithContentsOfFile:plistFile];
    [savedLevels[type][level] setObject:@1 forKey:[FPGameManager sharedInstance].language];
    [savedLevels writeToFile:plistFile atomically:YES];
}
@end
