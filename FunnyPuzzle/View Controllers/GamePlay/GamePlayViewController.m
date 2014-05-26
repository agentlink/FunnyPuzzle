//
//  GamePlayViewController.m
//  KG
//
//  Created by Misha on 19.05.14.
//  Copyright (c) 2014 KG. All rights reserved.
//

#import "GamePlayViewController.h"
#import "GameModel.h"

@interface GamePlayViewController ()
{
  NSArray *images;
}
@property (nonatomic, weak) IBOutlet UIView *leftView;
@property (nonatomic, weak) IBOutlet UIView *rightView;
@property (nonatomic, weak) IBOutlet UIView *centerView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *leftConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *rightConstraint;
@property (nonatomic, weak) IBOutlet UIButton *next;
@property (nonatomic, weak) IBOutlet UIButton *prew;
@property (nonatomic, weak) IBOutlet UIButton *back;

@property (nonatomic) FPLevelManager *level;
@property (nonatomic, weak) IBOutlet PDFImageView *field;

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

- (void)viewDidAppear:(BOOL)animated
{
    for (Segment *s in _level.segments) {
        [self.view addSubview:s];
        CGRect rect = s.frame;
        rect.origin.x = arc4random()%(int)(CGRectGetHeight(_leftView.frame)-CGRectGetHeight(s.frame)-40);
        rect.origin.y = arc4random()%(int)(CGRectGetWidth(_leftView.frame)-CGRectGetWidth(s.frame)-40);
        s.frame = rect;
        s.transform = CGAffineTransformMakeScale(0, 0);
        s.alpha = 0;
        [UIView animateWithDuration:0.2 delay:[_level.segments indexOfObject:s]*0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            s.transform = CGAffineTransformMakeScale(1.2, 1.2);
            s.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1f animations:^{
                s.transform = CGAffineTransformMakeScale(1, 1);
            }];
        }];
    }
    [_centerView addSubview:[GameModel sharedInstance].currentField];
    _field = [GameModel sharedInstance].currentField;
    CGPoint centerPoint = CGPointMake(CGRectGetMidX(_centerView.bounds), CGRectGetMidY(_centerView.bounds));
    CGPoint origin;
    centerPoint.x = centerPoint.x-(CGRectGetWidth(_level.grayLinedFiewld.bounds)*.5f);
    centerPoint.y = centerPoint.y-(CGRectGetHeight(_level.grayLinedFiewld.bounds)*.5f);
    [GameModel sharedInstance].level.grayLinedFiewld = _level.grayLinedFiewld;
    origin.x = centerPoint.x+CGRectGetMinX(_level.grayLinedFiewld.superview.frame);
    origin.y = centerPoint.y+CGRectGetMinY(_level.grayLinedFiewld.superview.frame);
    _level.grayLinedFiewld.frame = CGRectMake(centerPoint.x, centerPoint.y, CGRectGetWidth(_level.grayLinedFiewld.frame), CGRectGetHeight(_level.grayLinedFiewld.frame));
    [GameModel sharedInstance].fieldFrame = _level.grayLinedFiewld.frame;
    [GameModel sharedInstance].fieldOrigin = origin;
    _field.transform = CGAffineTransformMakeScale(0, 0);
    _field.alpha = 0;
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _field.transform = CGAffineTransformMakeScale(1.2, 1.2);
        _field.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f animations:^{
            _field.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _level = [GameModel sharedInstance].level;
    UIFont *font = [UIFont fontWithName:@"KBCuriousSoul" size:60];
    _next.titleLabel.font = font;
    _prew.titleLabel.font = font;
    _next.layer.zPosition = MAXFLOAT;
    _prew.layer.zPosition = MAXFLOAT;
    
}
- (void) updateLevel
{
    _level = [GameModel sharedInstance].level;
    [self viewDidAppear:YES];
}
- (void)removeObjects
{
    for (UIView *v in _level.segments) {
        [UIView animateWithDuration:0.3 animations:^{
            v.transform = CGAffineTransformMakeScale(0, 0);
            v.alpha = 0;
            _field.transform = CGAffineTransformMakeScale(0, 0);
            _field.alpha = 0;
        } completion:^(BOOL finished) {
            [v removeFromSuperview];
        }];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)next:(id)sender
{
    [self removeObjects];
    _level = [[GameModel sharedInstance] nextLevel];
    [self updateLevel];
}
- (IBAction)prew:(id)sender
{
    [self removeObjects];
    _level = [[GameModel sharedInstance] prewLevel];
    [self updateLevel];
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
