//
//  StartViewController.m
//  KG
//
//  Created by Misha on 19.05.14.
//  Copyright (c) 2014 KG. All rights reserved.
//

#import "StartViewController.h"
#import "BallView.h"
#import "FPLevelManager.h"
#import "GameModel.h"
#import <PDFImage/PDFImage.h>
#import "FPPreferences.h"
#import <AVFoundation/AVFoundation.h>
#import "FPSoundManager.h"
#import "GamePlayViewController.h"

@interface StartViewController ()

@property (nonatomic, weak) IBOutlet BallView *gamemodeFirst;
@property (nonatomic, weak) IBOutlet BallView *gamemodeSecond;
@property (nonatomic, weak) IBOutlet PDFImageView *ground1;
@property (nonatomic, weak) IBOutlet PDFImageView *ground2;
@property (nonatomic, weak) IBOutlet PDFImageView *ground3;
@property (nonatomic, weak) IBOutlet PDFImageView *ground4;
@property (nonatomic, weak) IBOutlet PDFImageView *ground5;

//settingsButtonFall
@property (weak, nonatomic) IBOutlet UIView *groundForSettingsButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (nonatomic, strong) UIDynamicItemBehavior *settingsButtonPropertiesBehavior;
@property (nonatomic) int settingsButtonOriginX;

@property (nonatomic) UIDynamicAnimator *animator;

- (void)play:(id)sender type:(FPGameType)type;
- (IBAction)goToSettings:(id)sender;
@end

@implementation StartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _gamemodeFirst.image = [PDFImage imageNamed:@"ball1"];
    _gamemodeSecond.image = [PDFImage imageNamed:@"ball2"];
    _gamemodeFirst.tap = ^{
        [self play:self type:FPGameTypeFirs];
    };
    _gamemodeSecond.tap =  ^{
        [self play:self type:FPGameTypeSecond];
    };
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    CGMutablePathRef aPath = CGPathCreateMutable();
    float x = CGRectGetMidX(_gamemodeFirst.frame);
    float y = CGRectGetMidY(_gamemodeFirst.frame);
    _gamemodeFirst.layer.anchorPoint = CGPointMake(0.5, 0.8);
    CGPathMoveToPoint(aPath,nil,x,y);        //Origin Point
    CGPathAddCurveToPoint(aPath,nil, x,y,   //Control Point 1
                          x+10,y+1,  //Control Point 2
                          x+20,y); // End Point
    animation.rotationMode = @"auto";
    animation.path = aPath;
    animation.duration = 3;
    animation.autoreverses = YES;
    animation.removedOnCompletion = NO;
    animation.repeatCount = 100.0f;
    animation.timingFunction = [CAMediaTimingFunction
                                functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CAKeyframeAnimation *animS = animation;
    animS.duration = 1;
    [self cofigGround];
    [[FPGameManager sharedInstance] setSettings];
    //[_gamemodeFirst.layer addAnimation:animation forKey:@"position"];
    //[_gamemodeSecond.layer addAnimation:animation forKey:@"position"];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    [[FPGameManager sharedInstance] setSettings];
    [self setSettingsControl];
    
}

- (void) viewWillAppear:(BOOL)animated{
     [self dropSettings];
}

- (void)cofigGround
{
    UIInterpolatingMotionEffect *horisontal1 =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horisontal1.minimumRelativeValue = @(-10);
    horisontal1.maximumRelativeValue = @(10);
    
    UIInterpolatingMotionEffect *horisontal2 =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horisontal2.minimumRelativeValue = @(-15);
    horisontal2.maximumRelativeValue = @(15);
    UIInterpolatingMotionEffect *horisontal3 =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horisontal3.minimumRelativeValue = @(-20);
    horisontal3.maximumRelativeValue = @(20);
    
    _ground1.image = [PDFImage imageNamed:@"ground1"];
    _ground2.image = [PDFImage imageNamed:@"ground3"];
    _ground3.image = [PDFImage imageNamed:@"ground2"];
    _ground4.image = [PDFImage imageNamed:@"ground5"];
    _ground5.image = [PDFImage imageNamed:@"ground4"];

    [_ground1 addMotionEffect:horisontal1];
    [_ground2 addMotionEffect:horisontal2];
    [_ground3 addMotionEffect:horisontal3];
}

- (void)layerAnimate
{
    
}

#pragma mark - UIActions

- (void)play:(id)sender type:(FPGameType)type
{
    GamePlayViewController *cont = (GamePlayViewController *)[[UIStoryboard storyboardWithName:@"GameField" bundle:nil] instantiateViewControllerWithIdentifier:@"GameFieldController"];
        [GameModel sharedInstance].gameType = type;
    [self.navigationController pushViewController:cont animated:YES];
}
//- (IBAction)playFirst:(id)sender
- (IBAction)goToSettings:(id)sender {
    FPPreferences *preferences = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Preferences"];
    [self.navigationController pushViewController:preferences animated:YES];
}

#pragma mark - Other Methods

- (void) setSettingsControl{
    PDFImageView *settingsImage=[[PDFImageView alloc] initWithFrame:_settingsButton.frame];
    settingsImage.image=[PDFImage imageNamed:@"prefs"];
    [_settingsButton setImage:[settingsImage currentUIImage]  forState:UIControlStateNormal];
    _settingsButtonOriginX=_settingsButton.frame.origin.x;
    UIGravityBehavior *gravityBeahvior = [[UIGravityBehavior alloc] initWithItems:@[_settingsButton]];
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[_settingsButton, _groundForSettingsButton]];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    self.settingsButtonPropertiesBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[_settingsButton]];
    self.settingsButtonPropertiesBehavior.elasticity = 0.4;
    [_animator addBehavior:self.settingsButtonPropertiesBehavior];
    [_animator addBehavior:gravityBeahvior];
    [_animator addBehavior:collisionBehavior];
}

- (void) dropSettings{
    [_settingsButtonPropertiesBehavior addLinearVelocity:CGPointMake(0, -1 * [_settingsButtonPropertiesBehavior linearVelocityForItem:_settingsButton].y) forItem:_settingsButton];
    _settingsButton.center = CGPointMake(_settingsButtonOriginX, 10);
    [_animator updateItemUsingCurrentState:_settingsButton];
}

@end
