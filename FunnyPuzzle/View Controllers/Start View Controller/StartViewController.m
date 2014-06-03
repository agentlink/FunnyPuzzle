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
#import "FPLevelPresentationViewController.h"

@interface StartViewController () //<UIViewControllerTransitioningDelegate>

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
@property (nonatomic) CATransform3D transform;

@property (nonatomic) BOOL needToDropButtons;

@property (nonatomic) UIDynamicAnimator *animator;

- (void)play:(id)sender type:(FPGameType)type;
- (IBAction)goToSettings:(id)sender;
@end

@implementation StartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _needToDropButtons = NO;
    _gamemodeFirst.image = [PDFImage imageNamed:@"ball1"];
    _gamemodeSecond.image = [PDFImage imageNamed:@"ball2"];
    _gamemodeFirst.tap = ^{
        [self play:self type:FPGameTypeFirst];
    };
    _gamemodeSecond.tap =  ^{
        [self play:self type:FPGameTypeSecond];
    };
    
    [self cofigGround];

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

- (void) dealloc{
    _settingsButtonPropertiesBehavior=nil;
    _snapCandyBehavior=nil;
    _snapSettingsBehavior=nil;
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
    if (type == FPGameTypeFirst) {
        [GameModel sharedInstance].gameType = type;
        FPLevelPresentationViewController *controller = (FPLevelPresentationViewController *)[[UIStoryboard storyboardWithName:@"GameField" bundle:nil] instantiateInitialViewController];
        self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [controller.view setHidden:YES];
        [controller setGameType:FPGameTypeFirst];
        [controller setParrent:self];
        [self presentViewController:controller animated:NO completion:^{
            [UIView animateWithDuration:kAnimationDuration*1.5 animations:^{
                CATransform3D transform = CATransform3DIdentity;
                _transform = _gamemodeFirst.superview.layer.transform;
                transform = CATransform3DTranslate(transform, -_gamemodeFirst.superview.frame.origin.x-40, -_gamemodeFirst.superview.frame.origin.y-25, 0);
                NSLog(@"%f",-_gamemodeFirst.superview.frame.origin.x-40);
                transform = CATransform3DScale(transform, 0.3, 0.3, 0.3);
                [_gamemodeFirst.superview.layer setTransform:transform];
                [controller startEnterAnimation];
            } completion:^(BOOL finished) {
                
            }];
        }];
    } else {
        [GameModel sharedInstance].gameType = type;
        FPLevelPresentationViewController *controller = (FPLevelPresentationViewController *)[[UIStoryboard storyboardWithName:@"GameField" bundle:nil] instantiateInitialViewController];
        self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [controller.view setHidden:YES];
        [self presentViewController:controller animated:NO completion:^{
            controller.gameType=type;
            [controller setParrent:self];
            [UIView animateWithDuration:kAnimationDuration*1.5 animations:^{
                CATransform3D transform = CATransform3DIdentity;
                _transform = _gamemodeSecond.superview.layer.transform;
                transform = CATransform3DTranslate(transform, -_gamemodeSecond.superview.frame.origin.x-_leftView.frame.size.width-40, -_gamemodeSecond.superview.frame.origin.y-20, 0);
                NSLog(@"%f",-_gamemodeSecond.superview.frame.origin.x-_leftView.frame.size.width);
                
                transform = CATransform3DScale(transform, 0.3, 0.3, 0.3);
                [_gamemodeSecond.superview.layer setTransform:transform];
                [controller startEnterAnimation];
            } completion:^(BOOL finished) {
                
            }];
        }];
    }
}

- (void)returnFromLevelSelection
{
    if ([(FPLevelPresentationViewController *)self.presentedViewController gameType] == FPGameTypeFirst) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            [_gamemodeFirst.superview.layer setTransform:_transform];
        } completion:^(BOOL finished) {
            
        }];
    }
    if ([(FPLevelPresentationViewController *)self.presentedViewController gameType] == FPGameTypeSecond) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            [_gamemodeSecond.superview.layer setTransform:_transform];
        } completion:^(BOOL finished) {
            
        }];
    }
    self.navigationController.modalPresentationStyle = UIModalPresentationNone;
}

- (IBAction)goToSettings:(id)sender {
    _needToDropButtons = YES;
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
    if (_needToDropButtons==YES){
    _settingsButton.center = CGPointMake(_settingsButton.center.x,0);
    _candiesView.center = CGPointMake(_candiesView.center.x,0);
    [_settingsButtonPropertiesBehavior addLinearVelocity:CGPointMake(0, -1 * [_settingsButtonPropertiesBehavior linearVelocityForItem:_settingsButton].y) forItem:_settingsButton];
    [_settingsButtonPropertiesBehavior addLinearVelocity:CGPointMake(0, -1 * [_settingsButtonPropertiesBehavior linearVelocityForItem:_candiesView].y) forItem:_candiesView];
    [_animator updateItemUsingCurrentState:_candiesView];
    [_animator updateItemUsingCurrentState:_settingsButton];
        _needToDropButtons = NO;
    }
}

#pragma mark - Animations
//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
//{
//    return nil;
//}
//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
//{
//    return (id)presenting;
//}
//
//- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
//{
//    return nil;
//}
//- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
//{
//    return (id)animator;
//}


// Add this view to superview, and slide it in from the bottom
- (void)presentWithSuperview:(UIView *)superview {
    // Set initial location at bottom of superview
    CGRect frame = self.view.frame;
    frame.origin = CGPointMake(0.0, superview.bounds.size.height);
    self.view.frame = frame;
    [superview addSubview:self.view];
    
    // Animate to new location
    [UIView beginAnimations:@"presentWithSuperview" context:nil];
    frame.origin = CGPointZero;
    self.view.frame = frame;
    [UIView commitAnimations];
}

// Method called when removeFromSuperviewWithAnimation's animation completes
- (void)animationDidStop:(NSString *)animationID
                finished:(NSNumber *)finished
                 context:(void *)context {
    if ([animationID isEqualToString:@"removeFromSuperviewWithAnimation"]) {
        [self.view removeFromSuperview];
    }
}

// Slide this view to bottom of superview, then remove from superview
- (void)removeFromSuperviewWithAnimation {
    [UIView beginAnimations:@"removeFromSuperviewWithAnimation" context:nil];
    
    // Set delegate and selector to remove from superview when animation completes
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    // Move this view to bottom of superview
    CGRect frame = self.view.frame;
    frame.origin = CGPointMake(0.0, self.view.superview.bounds.size.height);
    self.view.frame = frame;
    
    [UIView commitAnimations];
}

@end
