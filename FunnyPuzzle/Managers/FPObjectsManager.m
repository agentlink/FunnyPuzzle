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
    _levels = [[NSArray arrayWithContentsOfFile:plistPath] objectAtIndex:(long)_gameType];
    [self configFields:[_levels objectAtIndex:_level]];
    _segments = [self configSegments:[_levels objectAtIndex:_level]];
   
}
- (NSArray *)configSegments:(NSDictionary *)level
{
    NSArray *elements = [level valueForKey:@"elements"];
    _levelName = [level valueForKey:@"name"];
    NSMutableArray *result = [NSMutableArray new];
    for (NSDictionary *segmentEl in elements) {
        NSString *path = [NSString stringWithFormat:@"Levels/%@/%@",[level valueForKey:@"folder"],[segmentEl valueForKey:@"name"]];
        PDFImage *im = [PDFImage imageNamed:path];
        Segment *ss = [[Segment alloc] initWithFrame:CGRectMake(0, 0, im.size.width, im.size.height)];
        CGPoint point = CGPointMake([[[segmentEl valueForKey:@"point"] valueForKey:@"x"] floatValue]*multiplayer, [[[segmentEl valueForKey:@"point"] valueForKey:@"y"] floatValue]*multiplayer);
        ss.frame = CGRectMake(0, 0, im.size.width*multiplayer, im.size.height*multiplayer);
        ss.rect = CGRectMake(point.x*multiplayer, point.y*multiplayer, im.size.width*multiplayer, im.size.height*multiplayer);
        ss.image = im;
        [result addObject:ss];
    }
    return [NSArray arrayWithArray:result];
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
- (void)dealloc
{
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
