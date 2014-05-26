//
//  StartViewController.m
//  KG
//
//  Created by Misha on 19.05.14.
//  Copyright (c) 2014 KG. All rights reserved.
//

#import "StartViewController.h"
#import "BallView.h"
#import "FPObjectsManager.h"
#import "GameModel.h"
#import <PDFImage/PDFImage.h>
#import "FPPreferences.h"
#import <AVFoundation/AVFoundation.h>
#import "FPSoundManager.h"

@interface StartViewController ()

@property (nonatomic, weak) IBOutlet BallView *gamemodeFirst;
@property (nonatomic, weak) IBOutlet BallView *gamemodeSecond;
@property (nonatomic, weak) IBOutlet PDFImageView *ground1;
@property (nonatomic, weak) IBOutlet PDFImageView *ground2;
@property (nonatomic, weak) IBOutlet PDFImageView *ground3;
@property (nonatomic, weak) IBOutlet PDFImageView *ground4;
@property (nonatomic, weak) IBOutlet PDFImageView *ground5;

@property (nonatomic) UIDynamicAnimator *animator;
- (IBAction)play:(id)sender;
- (IBAction)goToSettings:(id)sender;
@end

@implementation StartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    _gamemodeFirst.image = [PDFImage imageNamed:@"ball1.pdf"];
    _gamemodeSecond.image = [PDFImage imageNamed:@"ball2.pdf"];
    _gamemodeFirst.tap = ^{
        [self play:self];
    };
    _gamemodeSecond.tap =  ^{
        [self play:self];
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
    [[FPGameManager sharedInstance] setSettings];
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
- (IBAction)play:(id)sender
{
    UIViewController *cont = [[UIStoryboard storyboardWithName:@"GameField" bundle:nil] instantiateViewControllerWithIdentifier:@"GameFieldController"];
    [self.navigationController pushViewController:cont animated:YES];
}

- (IBAction)goToSettings:(id)sender {
    FPPreferences *preferences = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Preferences"];
    [self.navigationController pushViewController:preferences animated:YES];
}

@end
