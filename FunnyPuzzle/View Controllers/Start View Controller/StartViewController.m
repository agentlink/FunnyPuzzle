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
#import "GameObject.h"
#import <PDFImage/PDFImage.h>

@interface StartViewController ()
@property (nonatomic, weak) IBOutlet BallView *gamemodeFirst;
@property (nonatomic, weak) IBOutlet BallView *gamemodeSecond;
@property (nonatomic) UIDynamicAnimator *animator;
- (IBAction)play:(id)sender;
@end

@implementation StartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    _gamemodeFirst.image = [PDFImage imageNamed:@"ball1.pdf"];
    _gamemodeSecond.image = [PDFImage imageNamed:@"ball2.pdf"];
    _gamemodeFirst.tap = ^{
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
    //[_gamemodeFirst.layer addAnimation:animation forKey:@"position"];
    //[_gamemodeSecond.layer addAnimation:animation forKey:@"position"];
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)layerAnimate
{
    
}
- (IBAction)play:(id)sender
{
    UIViewController *cont = [[UIStoryboard storyboardWithName:@"GameField" bundle:nil] instantiateViewControllerWithIdentifier:@"GameFieldController"];
    [self.navigationController pushViewController:cont animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
