//
//  GamePlayViewController.m
//  KG
//
//  Created by Misha on 19.05.14.
//  Copyright (c) 2014 KG. All rights reserved.
//

#import "GamePlayViewController.h"
#import "GameModel.h"
#import <CoreMotion/CoreMotion.h>

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
@property (nonatomic) Segment *dragingSegment;
@property (nonatomic) CGPoint touchPoint;

@property (nonatomic) FPLevelManager *level;
@property (nonatomic, weak) IBOutlet PDFImageView *field;

- (IBAction)next:(id)sender;
- (IBAction)prew:(id)sender;
- (IBAction)back:(id)sender;



@end

@implementation GamePlayViewController

#pragma mark - Lifecicle
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
    
    [_centerView addSubview:[GameModel sharedInstance].currentField];
    _field = [GameModel sharedInstance].currentField;
    CGPoint centerPoint = CGPointMake(CGRectGetMidX(_centerView.bounds), CGRectGetMidY(_centerView.bounds));
    CGPoint origin;
    centerPoint.x = centerPoint.x-(CGRectGetWidth(_field.bounds)*.5f);
    centerPoint.y = centerPoint.y-(CGRectGetHeight(_field.bounds)*.5f);
    [GameModel sharedInstance].level.grayLinedFiewld = _level.grayLinedFiewld;
    origin.x = centerPoint.x+CGRectGetMinX(_field.superview.frame);
    origin.y = centerPoint.y+CGRectGetMinY(_field.superview.frame);
    _field.frame = CGRectMake(centerPoint.x, centerPoint.y, CGRectGetWidth(_field.frame), CGRectGetHeight(_field.frame));
    [GameModel sharedInstance].fieldFrame = _field.frame;
    for (Segment *s in _level.segments) {
        [self.view addSubview:s];
        CGRect rect = s.frame;
        rect.origin.x = arc4random()%(int)(CGRectGetHeight(_leftView.frame)-CGRectGetHeight(s.frame)-40);
        rect.origin.y = arc4random()%(int)(CGRectGetWidth(_leftView.frame)-CGRectGetWidth(s.frame)-40);
        s.frame = rect;
        s.rect = [[GameModel sharedInstance] calcRect:s];
        if ([GameModel sharedInstance].levelWin) {
            s.frame = s.rect;
            s.hidden = YES;
        } /*else {
            rect.origin.x = arc4random()%(int)(CGRectGetHeight(_leftView.frame)-CGRectGetHeight(s.frame)-40);
            rect.origin.y = arc4random()%(int)(CGRectGetWidth(_leftView.frame)-CGRectGetWidth(s.frame)-40);
        }*/
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
    NSOperationQueue *theQueue = [[NSOperationQueue alloc] init];
    
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
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    
    [self.view addGestureRecognizer:pan];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) dealloc
{
    [self.view removeGestureRecognizer:[self.view.gestureRecognizers firstObject]];
}



#pragma mark - Private
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
#pragma mark - IBAction
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
#pragma mark - GestureRecognizers

- (void)panGestureRecognizer:(UIGestureRecognizer *)recognizer
{
    
   // if (recognizer.state == UIGestureRecognizerStateBegan)
    //{
    _dragingSegment.layer.anchorPoint = _touchPoint;
        _dragingSegment.layer.position = [recognizer locationInView:self.view];
        //NSLog(@"touchBegan");
    //}
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        [[GameModel sharedInstance] checkForRightPlace:_dragingSegment];
        
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch1 = [touches anyObject];
    CGPoint touchLocation = [touch1 locationInView:self.view];
    _dragingSegment = nil;
    NSMutableArray *tapSegments = [[NSMutableArray alloc] init];
    for (Segment *s in _level.segments) {
        if (CGRectContainsPoint(s.frame, touchLocation)) {
            if (s.inPlase) {
                [UIView animateWithDuration:0.1 animations:^{
                    s.transform = CGAffineTransformMakeScale(1.2, 1.2);
                    
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.1 animations:^{
                        s.transform = CGAffineTransformMakeScale(1, 1);
                    }];
                }];
            } else {
                [tapSegments addObject:s];
            }
            
        }
        
    }
    if (tapSegments.count>1) {
        for (Segment *s in tapSegments) {
            if (s.layer.zPosition == 1 && !CGColorGetAlpha([[s colorOfPoint:[touch1 locationInView:s]] CGColor])==0)
            {
                s.layer.zPosition = 1;
                _dragingSegment = s;
                _touchPoint = CGPointMake([touch1 locationInView:s].x/s.frame.size.width, [touch1 locationInView:s].y/s.frame.size.height);
            } else if (!_dragingSegment && !CGColorGetAlpha([[s colorOfPoint:[touch1 locationInView:s]] CGColor])==0) {
                s.layer.zPosition = 1;
                _dragingSegment = s;
                _touchPoint = CGPointMake([touch1 locationInView:s].x/s.frame.size.width, [touch1 locationInView:s].y/s.frame.size.height);
            } else {
                s.layer.zPosition = 0;
            }
        }
    } else {
        Segment *s = [tapSegments firstObject];
        if (!CGColorGetAlpha([[s colorOfPoint:[touch1 locationInView:s]] CGColor])==0) {
            for (Segment *ss in _level.segments) {
                ss.layer.zPosition = 0;
            }
            s.layer.zPosition = 1;
            _dragingSegment = s;
            _touchPoint = CGPointMake([touch1 locationInView:s].x/s.frame.size.width, [touch1 locationInView:s].y/s.frame.size.height);
        }
    }
}

//if (!CGColorGetAlpha([[s colorOfPoint:[touch1 locationInView:s]] CGColor])==0 && !_dragingSegment) {
//    if (s.layer.zPosition == 1) {
//        _touchPoint = CGPointMake([touch1 locationInView:s].x/s.frame.size.width, [touch1 locationInView:s].y/s.frame.size.height);
//        _dragingSegment = s;
//        s.layer.zPosition = 1;
//    }
//} else {
//    s.layer.zPosition = 0;
//}

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
