//
//  FPAppDelegate.m
//  FunnyPuzzle
//
//  Created by Misha on 21.05.14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import "FPAppDelegate.h"
#import "FPGameManager.h"

@implementation FPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
    [[FPGameManager sharedInstance] setSettings];
}
							

@end
