//
//  KGGameObject.m
//  KG
//
//  Created by Misha on 20.05.14.
//  Copyright (c) 2014 KG. All rights reserved.
//

#import "GameModel.h"
@implementation GameModel
static GameModel *_instance = nil;

- (FPObjectsManager *)manager
{
    _manager = [FPObjectsManager gameObjectsWithType:FPGameTypeFirs mode:FPGameModeEase level:0];
    return _manager;
}

- (void)checkForRightPlace:(Segment *)segment
{
    CGPoint currentPoint = [segment frame].origin;
    CGPoint oser = [_manager.grayLinedFiewld convertPoint:CGPointZero toView:segment];
    CGPoint win = _manager.fieldFrame.origin;
    //if (CGPointEqualToPoint ())
}

#pragma mark - Class Medoths
+ (GameModel *)sharedInstance
{
    @synchronized(self) {
        if (nil == _instance) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

@end
