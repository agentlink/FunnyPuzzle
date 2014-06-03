//
//  KGGameObject.m
//  KG
//
//  Created by Misha on 20.05.14.
//  Copyright (c) 2014 KG. All rights reserved.
//

#import "GameModel.h"
#import "FPSoundManager.h"
#import "FPGameManager.h"

@interface GameModel ()
@property (nonatomic) NSUserDefaults *defaults;

@end
@implementation GameModel
@synthesize defaults;
static GameModel *_instance = nil;

- (FPLevelManager *)level
{
    [self loadPrefs];
    if (!_level)
    _level = [FPLevelManager loadLevelWithType:FPGameTypeFirst mode:_gameMode level:_lastLevel];
    _objectsLeft = _level.segmentsCount;
    _levelCompleet = [defaults boolForKey:_level.levelName];
        
    if ([FPGameManager sharedInstance].displayInnerBorders) {
        _currentField = _level.grayLinedFiewld;
    } else {
        _currentField = _level.grayField;
    }
    
    
    return _level;
}
- (void) loadPrefs
{
    defaults = [NSUserDefaults standardUserDefaults];
    _gameMode = (int)[defaults integerForKey:@"GameMode"];
    _lastLevel = (int)[defaults integerForKey:@"LastLevel"];
}
- (void)checkForRightPlace:(Segment *)segment
{
    CGPoint currentPoint = segment.frame.origin;
    CGPoint win = segment.rect.origin;

    BOOL xPos = 10>=abs(win.x-currentPoint.x);
    BOOL yPos = 10>=abs(win.y-currentPoint.y);
    if (xPos&&yPos&&segment)
    {
        [self itemDropInPlace];
        [UIView animateWithDuration:0.2 animations:^{
            segment.frame = CGRectMake(win.x, win.y, segment.frame.size.width, segment.frame.size.height);
            segment.transform = CGAffineTransformMakeScale(1.2, 1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                segment.transform = CGAffineTransformMakeScale(1, 1);
            }];
            [segment setInPlase:YES];
            if (_objectsLeft<=1) {
                [defaults setBool:YES forKey:_level.levelName];
                if ([_gamePlayViewController respondsToSelector:@selector(levelFinish)])
                    [_gamePlayViewController levelFinish];
            } else {
                _objectsLeft--;
            }
        }];
    }
}
- (FPLevelManager *)nextLevel
{
    if (_lastLevel+1<_level.levelsCount)
    {
         _lastLevel++;
    } else {
        _lastLevel = 0;
    }
    [defaults setInteger:_lastLevel forKey:@"LastLevel"];
    _level = [FPLevelManager loadLevelWithType:_gameType mode:_gameMode level:_lastLevel];
    _objectsLeft = _level.levelsCount;
    return _level;
}
- (FPLevelManager *)prewLevel
{
    if (_lastLevel-1>=0)
    {
        _lastLevel--;
    } else {
        _lastLevel = _level.levelsCount-1;
    }
    _level = [FPLevelManager loadLevelWithType:_gameType mode:_gameMode level:_lastLevel];
    [defaults setInteger:_lastLevel forKey:@"LastLevel"];
    _objectsLeft = _level.levelsCount;
    return _level;
}
- (CGRect)calcRect:(Segment *)segment
{
    CGPoint win = CGPointMake(CGRectGetMinX(_currentField.frame)+CGRectGetMinX(_currentField.superview.frame)+segment.rect.origin.x, CGRectGetMinY(_currentField.frame)+CGRectGetMinY(_currentField.superview.frame)+segment.rect.origin.y);
    return CGRectMake(win.x, win.y, CGRectGetWidth(segment.frame), CGRectGetHeight(segment.frame));
}
#pragma mark - Class Medoths
+ (GameModel *)sharedInstance
{
    @synchronized(self) {
        if (nil == _instance) {
            _instance = [[self alloc] init];
            [_instance loadPrefs];
        }
    }
    return _instance;
}

#pragma mark - Multimedia methods

- (void)itemSelected
{
    [[FPSoundManager sharedInstance] vibrateWithMode:VibrateModeDragOrDrop];
}
- (void)itemDrop
{
    [[FPSoundManager sharedInstance] vibrateWithMode:VibrateModeDragOrDrop];
}

- (void)itemDropInPlace
{
    [[FPSoundManager sharedInstance] vibrateWithMode:VibrateModeInPlace];
}
- (void)itemWillSelectFromPlace
{
    [[FPSoundManager sharedInstance] vibrateWithMode:VibrateModeInPlace];   
}

- (void)levelComplete:(NSURL*)url
{
    [[FPSoundManager sharedInstance] playSound:url];
}

@end
