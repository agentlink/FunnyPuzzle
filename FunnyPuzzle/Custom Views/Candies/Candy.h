//
//  Candies.h
//  FunnyPuzzle
//
//  Created by Mac on 5/21/14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BonusLevelFinished <NSObject>

-(void)PickUpCandy;

@end

@interface Candy : UIView

@property (nonatomic) CGRect centrBascket;
@property (nonatomic) bool Animation;
@property (nonatomic) int BonusLevelKind;
@property (nonatomic) bool click;
@property (nonatomic) bool Size;

@property (nonatomic, strong) UIDynamicItemBehavior *CandiesPropertiesBehavior;
@property (nonatomic, strong) UIDynamicAnimator *animator;

@property (nonatomic) id<BonusLevelFinished> delegate;

- (void)Move:(bool)animate;
- (void) cleanObject;

@end
