//
//  FPAppDelegate.h
//  FunnyPuzzle
//
//  Created by Misha on 21.05.14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyReachability.h"

@interface FPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic) BOOL isInternet;
@property (nonatomic) NSTimer *rateAppTimer;
@property (nonatomic) NSTimer *internetTimer;
@property (nonatomic)  MyReachability *internet;

@end