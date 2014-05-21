//
//  FPObjectsManager.m
//  FunnyPuzzle
//
//  Created by Misha on 21.05.14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import "FPObjectsManager.h"
@interface FPObjectsManager ()

@end

@implementation FPObjectsManager

- (id)init
{
    self = [super init];
    if (self) {
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"Levels/items" ofType:@"plist"];
        _segments = [NSArray arrayWithContentsOfFile:plistPath];
        
    }
    return self;
}
@end
