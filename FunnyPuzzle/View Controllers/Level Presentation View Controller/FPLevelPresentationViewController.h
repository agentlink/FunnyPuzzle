//
//  FPLevelPresentationViewController.h
//  FunnyPuzzle
//
//  Created by Misha on 29.05.14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StartViewController.h"
@interface FPLevelPresentationViewController : UIViewController
@property (nonatomic) FPGameType gameType;
@property (nonatomic) StartViewController *parrent;
- (void)startEnterAnimation;
@end
