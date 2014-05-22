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
