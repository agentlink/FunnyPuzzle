//
//  FPLevelPresentationViewController.h
//  FunnyPuzzle
//
//  Created by Misha on 29.05.14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StartViewController.h"
#import "FPGamePlayController.h"

@interface FPLevelPresentationViewController : UIViewController<FPGamePlayViewControllerDelegate>

@property (nonatomic) FPGameType gameType;
@property (nonatomic) StartViewController *parrent;

@property (nonatomic) UIImage *ImageScreenShot;
@property (nonatomic) bool ScreenShotActivate;

- (void)startEnterAnimation;

- (void)nextLevel;
- (void)previousLevel;
@end
