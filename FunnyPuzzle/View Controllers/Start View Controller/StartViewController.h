//
//  StartViewController.h
//  KG
//
//  Created by Misha on 19.05.14.
//  Copyright (c) 2014 KG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPBonusViewController.h"


@interface StartViewController : UIViewController

@property (nonatomic) bool ScreenShotActivate;

- (void)returnFromLevelSelection;
- (UIImage *)snapshot;
@end
