//
//  GamePlayViewController.m
//  KG
//
//  Created by Misha on 19.05.14.
//  Copyright (c) 2014 KG. All rights reserved.
//

#import "GamePlayViewController.h"
#import "GameObject.h"
@interface GamePlayViewController ()
@property (nonatomic, weak) IBOutlet UIView *leftView;
@property (nonatomic, weak) IBOutlet UIView *rightView;
@property (nonatomic, weak) IBOutlet UIView *centerView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *leftConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *rightConstraint;
@property (nonatomic, weak) IBOutlet UIButton *next;
@property (nonatomic, weak) IBOutlet UIButton *prew;

- (IBAction)next:(id)sender;
- (IBAction)prew:(id)sender;
- (IBAction)back:(id)sender;


@end

@implementation GamePlayViewController

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
    //FPGameType *gt=[GameObject sharedInstance].gameType;
    FPGameType gt=FPGameModeFirs;
    switch (gt) {
        case FPGameModeFirs:
            NSLog(@"Hello1 x  %f   y  %f", self.rightView.frame.origin.x, self.rightView.frame.origin.y);
            
            break;
        case FPGameModeSecond:
            NSLog(@"Hello2");
            break;
        case FPGameModeBonus:
            NSLog(@"Hello3");
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)next:(id)sender
{
    
}
- (IBAction)prew:(id)sender
{
    
}
- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) dealloc
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
