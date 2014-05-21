//
//  StartViewController.m
//  KG
//
//  Created by Misha on 19.05.14.
//  Copyright (c) 2014 KG. All rights reserved.
//

#import "StartViewController.h"
#import <SpriteKit/SpriteKit.h>
#import <SVGKit/SVGKit.h>
#import <SVGKFastImageView.h>
#import "BallView.h"
@interface StartViewController ()
@property (nonatomic, weak) IBOutlet BallView *gamemodeFirst;
@property (nonatomic, weak) IBOutlet BallView *gamemodeSecond;

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
    // Do any additional setup after loading the view.
    SVGKImage *fImage = [SVGKImage imageNamed:@"ball1.svg"];
    SVGKImage *sImage = [SVGKImage imageNamed:@"ball2.svg"];
    _gamemodeFirst.image = fImage;
    _gamemodeSecond.image = sImage;
//    UIImage *im = [svg exportUIImageAntiAliased:YES curveFlatnessFactor:1 interpolationQuality:8];
//    UIImageView *imView = (UIImageView *) [self.view viewWithTag:123];
//    [imView setImage:im];
    //SVGKImage *svg = [SVGKImage imageNamed:@"chicken_gray.svg"];
    //[self.view addSubview:[[SVGKFastImageView alloc] initWithSVGKImage:svg]];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:im];
}
- (void)viewDidDisappear:(BOOL)animated
{
    _gamemodeFirst.isVisible = NO;
    _gamemodeSecond.isVisible = NO;
}
- (void)viewDidAppear:(BOOL)animated
{
    _gamemodeSecond.isVisible = YES;
    _gamemodeFirst.isVisible = YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)layerAnimate
{
    
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
