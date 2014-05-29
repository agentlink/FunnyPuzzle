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
@property (weak, nonatomic) IBOutlet UIView *leftView;

//ButtonsFall
@property (weak, nonatomic) IBOutlet UIView *groundForSettingsButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (nonatomic, strong) UIDynamicItemBehavior *settingsButtonPropertiesBehavior;
@property (weak, nonatomic) IBOutlet PDFImageView *candiesView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (nonatomic, strong) UISnapBehavior *snapSettingsBehavior;
@property (nonatomic, strong) UISnapBehavior *snapCandyBehavior;


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
    //[_gamemodeFirst.layer addAnimation:animation forKey:@"position"];
    //[_gamemodeSecond.layer addAnimation:animation forKey:@"position"];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    [[FPGameManager sharedInstance] setSettings];
    [self setSettingsControl];
    
}

- (void) viewWillAppear:(BOOL)animated{
     [self dropSettings];
    [[FPSoundManager sharedInstance] stopGameMusic];
    [[FPSoundManager sharedInstance] playBackgroundMusic];
    [self.animator removeBehavior:_snapCandyBehavior];
    [self.animator removeBehavior:_snapSettingsBehavior];
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
    CGPoint pointSettings = CGPointMake(_settingsButton.center.x,_settingsButton.frame.size.height/4);
    CGPoint pointCandy = CGPointMake(_candiesView.center.x,_candiesView.frame.size.height/4);
    // Remove the previous behavior.
    
    UISnapBehavior *snapSettingsBehavior = [[UISnapBehavior alloc] initWithItem:_settingsButton snapToPoint:pointSettings];
    snapSettingsBehavior.damping=1.0f;
    _snapSettingsBehavior = snapSettingsBehavior;
    UISnapBehavior *snapCandyBehavior = [[UISnapBehavior alloc] initWithItem:_candiesView snapToPoint:pointCandy];
    snapCandyBehavior.damping=1.0f;
    _snapCandyBehavior = snapCandyBehavior;
    [self.animator addBehavior:_snapCandyBehavior];
    [self.animator addBehavior:_snapSettingsBehavior];
    [_animator updateItemUsingCurrentState:_candiesView];
    [_animator updateItemUsingCurrentState:_settingsButton];
    [self presentViewController:preferences animated:YES completion:nil];
}

#pragma mark - Other Methods

- (void) setSettingsControl{
    _settingsButton.frame = CGRectMake(CGRectGetHeight(self.view.frame)/4, 0, CGRectGetWidth(_settingsButton.frame), CGRectGetHeight(_settingsButton.frame));
    _candiesView.frame = CGRectMake((CGRectGetHeight(self.view.frame)/4)*3, 0, CGRectGetWidth(_candiesView.frame), CGRectGetHeight(_candiesView.frame));
    PDFImageView *settingsImage=[[PDFImageView alloc] initWithFrame:_settingsButton.frame];
    settingsImage.image=[PDFImage imageNamed:@"prefs"];
    PDFImageView *candyImage=[[PDFImageView alloc] initWithFrame:_candiesView.frame];
    candyImage.image=[PDFImage imageNamed:@"candy"];
    _candiesView.image=candyImage.image;
    [_settingsButton setImage:[settingsImage currentUIImage]  forState:UIControlStateNormal];
    
    UIGravityBehavior *gravityBeahvior = [[UIGravityBehavior alloc] initWithItems:@[_settingsButton, _candiesView]];
    
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[_settingsButton, _groundForSettingsButton, _candiesView]];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    self.settingsButtonPropertiesBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[_settingsButton, _candiesView]];
    self.settingsButtonPropertiesBehavior.elasticity = 0.4;
    [_animator addBehavior:self.settingsButtonPropertiesBehavior];
    [_animator addBehavior:gravityBeahvior];
    [_animator addBehavior:collisionBehavior];
}

- (void) dropSettings{
    _settingsButton.center = CGPointMake(_settingsButton.center.x,0);
    _candiesView.center = CGPointMake(_candiesView.center.x,0);
    [_settingsButtonPropertiesBehavior addLinearVelocity:CGPointMake(0, -1 * [_settingsButtonPropertiesBehavior linearVelocityForItem:_settingsButton].y) forItem:_settingsButton];
    [_settingsButtonPropertiesBehavior addLinearVelocity:CGPointMake(0, -1 * [_settingsButtonPropertiesBehavior linearVelocityForItem:_candiesView].y) forItem:_candiesView];
    [_animator updateItemUsingCurrentState:_candiesView];
    [_animator updateItemUsingCurrentState:_settingsButton];
}

@end
