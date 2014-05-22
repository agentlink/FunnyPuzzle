//
//  KGGameObject.m
//  KG
//
//  Created by Misha on 20.05.14.
//  Copyright (c) 2014 KG. All rights reserved.
//

#import "GameObject.h"

@implementation GameObject
static GameObject *_instance = nil;

- (FPObjectsManager *)manager
{
    return [FPObjectsManager gameObjectsWithType:FPGameTypeFirs mode:FPGameModeEase level:0];
}



#pragma mark - Class Medoths
+ (GameObject *)sharedInstance
{
    @synchronized(self) {
        if (nil == _instance) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

@end
