//
//  FPObjectsManager.m
//  FunnyPuzzle
//
//  Created by Misha on 21.05.14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import "FPObjectsManager.h"
#import "Segment.h"
@interface FPObjectsManager ()
@property (nonatomic, strong) NSArray *levels;
@property (nonatomic) float multiplayer;
@property (nonatomic) NSString *pathToColor;
@property (nonatomic) NSString *folderName;
@property (nonatomic) NSString *pathToLevel;
@end

@implementation FPObjectsManager
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
    _levels = [[NSArray arrayWithContentsOfFile:plistPath] objectAtIndex:_gameType];
    //[self configFields:[_levels objectAtIndex:_level]];
    //_segments = [self getSegmentsFromElements:[_levels objectAtIndex:_level]];
    [self initField:[_levels objectAtIndex:_level]];
   
}
- (void)initField:(NSDictionary *)level
{
    _pathToLevel = [NSString stringWithFormat:@"Levels/%@",
                    [level valueForKey:@"folder"],
                    nil];
    _pathToColor = [NSString stringWithFormat:@"%@/%@", _pathToLevel, [level valueForKey:@"color"]];
    PDFImage *color = [PDFImage imageNamed:_pathToColor];
    PDFImage *gray = [PDFImage imageNamed:[NSString stringWithFormat:@"%@_gray", _pathToColor]];
    PDFImage *gray_lined = [PDFImage imageNamed:[NSString stringWithFormat:@"%@_gray_lines", _pathToColor]];
    [self calcMultiplayerFromSize:color.size];
    _colorField = [[PDFImageView alloc] initWithFrame:[self getAdaptedRectFromSize:color.size]];
    _grayField = [[PDFImageView alloc] initWithFrame:[self getAdaptedRectFromSize:color.size]];
    _grayLinedFiewld = [[PDFImageView alloc] initWithFrame:[self getAdaptedRectFromSize:color.size]];
    _colorField.image = color;
    _grayField.image = gray;
    _grayLinedFiewld.image = gray_lined;
    _segments = [self getSegmentsFromElements:[level valueForKey:@"elements"]];
    _soundURL = [self getSoundURL];
    
}
- (NSArray *)getSegmentsFromElements:(NSArray *)elements
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (NSDictionary *element in elements) {
        CGPoint nativePoint = CGPointMake([[[element valueForKey:@"point"] valueForKey:@"x"] floatValue], [[[element valueForKey:@"point"] valueForKey:@"y"] floatValue]);
        NSString *path = [NSString stringWithFormat:@"%@%i",
                          _pathToColor,
                          [elements indexOfObject:element]+1, nil];
        
        PDFImage *image = [PDFImage imageNamed:path];
        CGRect adaptedFrame = CGRectMake(nativePoint.x*multiplayer, nativePoint.y*multiplayer, image.size.width*multiplayer, image.size.height*multiplayer);
        Segment *segment = [[Segment alloc] initWithFrame:[self getAdaptedRectFromSize:image.size]];
        segment.image = image;
        segment.rect = adaptedFrame;
        segment.backgroundColor = [UIColor redColor];
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
    if (size.width>=280)
    {
        multiplayer = 280/size.width;
    }
    else if (size.height>=280)
    {
        multiplayer = 280/size.height;
    } else {
        multiplayer = 1.0f;
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
    if (rect.size.width>=280)
    {
        multiplayer = 280/rect.size.width;
    }
    else if (rect.size.height>=280)
    {
        multiplayer = 280/rect.size.height;
    } else {
        multiplayer = 1.0f;
    }
}
- (CGRect)getAdaptedRectFromRect:(CGRect)rect
{
    CGRect result;
    if (rect.size.width>=280)
    {
        multiplayer = 280/rect.size.width;
    }
    else if (rect.size.height>=280)
    {
        multiplayer = 280/rect.size.height;
    }
    result.size.height = rect.size.height*multiplayer;
    result.size.width = rect.size.width*multiplayer;
    return result;
}
+(FPObjectsManager *)gameObjectsWithType:(FPGameType)type mode:(FPGameMode)mode level:(int)level
{
    FPObjectsManager *manager = [FPObjectsManager new];
    manager.gameType = type;
    manager.level = level;
    [manager parce];
    return manager;
}
@end
