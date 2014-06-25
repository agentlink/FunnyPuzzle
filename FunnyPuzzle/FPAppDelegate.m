//
//  FPAppDelegate.m
//  FunnyPuzzle
//
//  Created by Misha on 21.05.14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import "FPAppDelegate.h"
#import "FPGameManager.h"
#import <GooglePlus/GooglePlus.h>

@implementation FPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
    [[FPGameManager sharedInstance] setSettings];
    
}

- (BOOL)application: (UIApplication *)application openURL: (NSURL *)url  sourceApplication: (NSString *)sourceApplication annotation: (id)annotation {
    return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
}

@end
