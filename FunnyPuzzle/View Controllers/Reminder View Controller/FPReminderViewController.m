//
//  FPReminderViewController.m
//  FunnyPuzzle
//
//  Created by Stas Volskyi on 25.06.14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import "FPReminderViewController.h"

@interface FPReminderViewController ()

@property (weak, nonatomic) IBOutlet UIView *reminderView;
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UIButton *laterButton;
@property (weak, nonatomic) IBOutlet UIButton *noButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIView *rootView;
@property (nonatomic) BOOL willClose;
@property (nonatomic) BOOL needToClose;
@property (nonatomic) BOOL open;

- (IBAction)rateTheApp:(id)sender;
- (IBAction)rateTheAppLater:(id)sender;
- (IBAction)dontRateApp:(id)sender;
@end

@implementation FPReminderViewController

#pragma mark - Lifecycle

- (void) viewWillAppear:(BOOL)animated
{
    [self setViewControls];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self openView];
}

- (void) viewDidDisappear:(BOOL)animated
{
    self.presentingViewController.modalPresentationStyle = UIModalPresentationFullScreen;
}

#pragma mark - UIActions

- (IBAction)rateTheApp:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"alreadyRated"];
    [defaults synchronize];
    NSString* url = RATE_APP_LINK;
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url ]];

    [self closeView];
}

- (IBAction)rateTheAppLater:(id)sender
{
    [self closeView];
}

- (IBAction)dontRateApp:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"DontRateApp"];
    [defaults synchronize];
    [self closeView];
}

#pragma mark - Animations

- (void) openView
{
    self.open = YES;
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.fromValue = @0.0;
    scale.toValue = @1.2;
    scale.duration = kAnimationDuration*0.6;
    scale.removedOnCompletion = NO;
    scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scale.delegate = self;
    [self.reminderView.layer addAnimation:scale forKey:@"move forward by scaling"];
    self.reminderView.transform = CGAffineTransformIdentity;
    CABasicAnimation* fadein= [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadein.fromValue = @0.0;
    fadein.toValue = @0.6;
    fadein.duration = kAnimationDuration;
    fadein.delegate = self;
    [[self.rootView layer]addAnimation:fadein forKey:@"opacity"];
    self.rootView.layer.opacity = 0.6;
}

- (void) closeView
{
    self.willClose = true;
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.fromValue = @1.0;
    scale.toValue = @1.2;
    scale.duration = kAnimationDuration*0.4;
    scale.removedOnCompletion = NO;
    scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scale.delegate = self;
    [self.reminderView.layer addAnimation:scale forKey:@"move forward by scaling"];
    self.reminderView.transform = CGAffineTransformIdentity;
  
}

#pragma mark - Other methods

- (void) setViewControls
{
    self.reminderView.layer.zPosition = 0;
    [self.yesButton setTitle:NSLocalizedString(@"Yes", nil) forState:UIControlStateNormal];
    [self.noButton setTitle:NSLocalizedString(@"No", nil) forState:UIControlStateNormal];
    [self.laterButton setTitle:NSLocalizedString(@"Later", nil) forState:UIControlStateNormal];
    self.yesButton.layer.borderWidth = 1.0;
    self.yesButton.layer.borderColor = [UIColor colorWithRed:(52.0/255.0) green:(73.0/255.0) blue:(94.0/255.0) alpha:1].CGColor;
    self.noButton.layer.borderWidth = 1.0;
    self.noButton.layer.borderColor = [UIColor colorWithRed:(52.0/255.0) green:(73.0/255.0) blue:(94.0/255.0) alpha:1].CGColor;
    self.laterButton.layer.borderWidth = 1.0;
    self.laterButton.layer.borderColor = [UIColor colorWithRed:(52.0/255.0) green:(73.0/255.0) blue:(94.0/255.0) alpha:1].CGColor;
}

#pragma mark - AnimationDelegate

- (void) animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
    if (self.needToClose){
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    if (self.open) {
        self.open=NO;
        CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scale.fromValue = @1.2;
        scale.toValue = @1.0;
        scale.duration = kAnimationDuration*0.4;
        scale.removedOnCompletion = YES;
        scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.reminderView.layer addAnimation:scale forKey:@"move forward by scaling"];
        self.reminderView.transform = CGAffineTransformIdentity;
    }
    if (self.willClose){
        self.willClose=NO;
        self.needToClose = YES;
        CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scale.fromValue = @1.2;
        scale.toValue = @0.0;
        scale.duration = kAnimationDuration*0.6;
        scale.removedOnCompletion = NO;
        scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        scale.delegate = self;
        [self.reminderView.layer addAnimation:scale forKey:@"move forward by scaling"];
        self.reminderView.transform = CGAffineTransformIdentity;
        self.reminderView.transform = CGAffineTransformMakeScale(0.0, 0.0);
        CABasicAnimation* fadein= [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadein.toValue = @0.0;
        fadein.fromValue = @0.6;
        fadein.duration = kAnimationDuration*0.6;
        [[self.rootView layer] addAnimation:fadein forKey:@"opacity"];
        self.rootView.layer.opacity = 0;
    }
    

}


@end
