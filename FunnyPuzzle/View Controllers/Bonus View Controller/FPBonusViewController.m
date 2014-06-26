//
//  FPBonusViewController.m
//  FunnyPuzzle
//
//  Created by Mac on 5/21/14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import "FPBonusViewController.h"
#import "Candy.h"
#import "FPFlover.h"
#import "AccelerometerManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import "FPGameManager.h"
#import "FPLevelPresentationViewController.h"



@interface FPBonusViewController ()<ShakeHappendDelegate,BonusLevelFinished>

{
    NSMutableArray *objectsCandies2,*objectsCandies,*objectsFlowers;
    NSArray *imagesCandy,*imagesCandySmall;
    int Numb;
    int xx;
    MPMoviePlayerController *moviePlayerController;
    NSTimer *timer;
    CAKeyframeAnimation *animation;
    CGMutablePathRef aPath;
    int ii;
    CGRect  MainRec;
    int lichulnuk;
}

@property (weak, nonatomic) IBOutlet UIButton *Bt;
- (IBAction)DeleteViewController:(id)sender;
@property (nonatomic, strong) UIDynamicItemBehavior *BTPropertiesBehavior;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) AccelerometerManager *accelerometer;

- (IBAction)next:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *next;



@end


@implementation FPBonusViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.CandiesCount=0;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _next.alpha = 0;
    UIImage *IM=[UIImage imageNamed:@"bonus_game_bg"];
    self.view.backgroundColor=[UIColor colorWithPatternImage:IM];
    MainRec=CGRectMake( 0, 0,  80, 68);
    xx=20;
    lichulnuk=0;
    imagesCandy=[NSArray arrayWithObjects:@"candy_blue",@"candy_green",@"candy_orange",@"candy_yellow_blue", nil];
    imagesCandySmall=[NSArray arrayWithObjects:@"candy_blue_small",@"candy_orange_small",@"candy_yellow_blue_small", nil];
    Numb=arc4random()%4;
    switch (Numb) {
        case 0:
            [self FirstBonusLevelLoad];
            break;
        case 1:
            [self SecondBonusLevelLoad];
            break;
        case 2:
            [self ThirdBonusLevelLoad];
            break;
        case 3:
            [self ForthBonusLevelLoad];
            break;
        default:
            break;
    }
    NSString *filepath   =   [[NSBundle mainBundle] pathForResource:@"Comp4_1" ofType:@"mp4"];
    NSURL    *fileURL    =   [NSURL fileURLWithPath:filepath];
    moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
    [moviePlayerController.view setFrame:MainRec];
    moviePlayerController.controlStyle=MPMovieControlStyleNone;
    moviePlayerController.scalingMode =MPMovieScalingModeAspectFit;
    [moviePlayerController prepareToPlay];
    moviePlayerController.view.backgroundColor=[UIColor clearColor];
    moviePlayerController.view.layer.zPosition=5;
    [self.view addSubview:moviePlayerController.view];
    [moviePlayerController play];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playMediaFinished:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:moviePlayerController];
    tick=0;
    timer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                             target: self
                                           selector: @selector(handleTimer)
                                           userInfo: nil
                                            repeats: YES];
}



-(void)FirstBonusLevelLoad
{
    MainRec=CGRectMake( self.view.frame.size.height/2-40, self.view.frame.size.width/2-34,  80, 68);
    UIImage *im=[UIImage imageNamed:@"basket_icon"];
    CGRect rec=CGRectMake(self.view.frame.size.height/2-im.size.height/2, self.view.frame.size.width/2-im.size.width/2, im.size.width, im.size.height);
    UIImageView *imView=[[UIImageView alloc]initWithFrame:rec];
    imView.image=im;
    imView.layer.zPosition=1;
    [self.view addSubview:imView];
    float x=20;
    float y=20;
    float deltaX=CGRectGetHeight([[UIScreen mainScreen] bounds])/10;
    objectsCandies=[[NSMutableArray alloc] init];
    _candiesCount=9;
    for(int i=1; i<10; i++)
    {
        Candy *c=[Candy new];
        UIImage *im = [UIImage imageNamed:[imagesCandy objectAtIndex:arc4random()%(imagesCandy.count)]];
        c.backgroundColor=[UIColor colorWithPatternImage:im];
        c.centrBascket=CGRectMake(imView.frame.origin.x, imView.frame.origin.y, im.size.height, im.size.width);
        c.layer.zPosition=2;
        CGRect r=CGRectMake(x, y, im.size.height, im.size.width);
        c.frame = r;
        c.BonusLevelKind=0;
        c.delegate=self;
        [self.view addSubview:c];
        [objectsCandies insertObject:c atIndex:i-1];
        x+=deltaX;
        [c Move:true];
    }
 
   
}

-(void)SecondBonusLevelLoad
{
    UIImage *im2=[UIImage imageNamed:@"sun_img"];
    float deltaX=CGRectGetHeight([[UIScreen mainScreen] bounds])/6;
    MainRec=CGRectMake( self.view.frame.size.height/2-40, self.view.frame.size.width/2,  80, 68);
    UIImageView *imView=[[UIImageView alloc]initWithFrame:CGRectMake( self.view.frame.size.height/2-im2.size.height/2, self.view.frame.size.width/2-im2.size.width,  im2.size.height, im2.size.width)];
    imView.image=im2;
    _candiesCount=5;
    [self.view addSubview:imView];
    [self SunMove:imView];
    objectsCandies=[[NSMutableArray alloc] init];
    objectsFlowers=[[NSMutableArray alloc] init];
    float x=50;
    for (int i=0; i<5; i++)
    {
        UIImage *im=[UIImage imageNamed:@"flower_img"];
        FPFlover *f=[[FPFlover alloc] initWithFrame:CGRectMake(x, self.view.frame.size.width,im.size.width,im.size.height)];
        f.backgroundColor=[UIColor colorWithPatternImage:im];
        f.layer.zPosition=0;
        [objectsFlowers insertObject:f atIndex:i];
        [self.view addSubview:f];
        UIImage *im2 = [UIImage imageNamed:[imagesCandy objectAtIndex:arc4random()%(imagesCandy.count)]];
        Candy *c=[[Candy alloc] initWithFrame:CGRectMake(x+20, f.frame.origin.y+17, im2.size.height, im2.size.width)];
        c.layer.zPosition=1;
        c.BonusLevelKind=1;
        c.delegate=self;
        [objectsCandies insertObject:c atIndex:i];
        [self.view addSubview:c];
        x+=deltaX;
        [c Move:true];
    }
}

-(void)SunMove:(UIView *)sunView
{
    animation = [CAKeyframeAnimation animation];
    aPath = CGPathCreateMutable();
    float x = CGRectGetMidX(sunView.frame);
    float y = CGRectGetMidY(sunView.frame);
    CGPathAddArc(aPath, NULL, x, y, 0.1f, 0.f, (360* M_PI)/180, NO);
    animation.rotationMode = @"auto";
    animation.path = aPath;
    animation.duration = 2.8;
    animation.removedOnCompletion = YES;
    animation.repeatCount = 100.0f;
    [sunView.layer addAnimation:animation forKey:@"position" ];
}

-(void)ThirdBonusLevelLoad
{
    objectsCandies2=[[NSMutableArray alloc]init];
    UIImage *im=[UIImage imageNamed:@"tree_img"];
    CGRect rec=CGRectMake(self.view.frame.size.height/2-im.size.height/4, self.view.frame.size.width/2-im.size.width/2-50, im.size.width, im.size.height);
    UIImageView *imView=[[UIImageView alloc]initWithFrame:rec];
    MainRec=CGRectMake( rec.origin.x+40, rec.origin.y+34,  80, 68);
    imView.image=im;
    int x=imView.frame.origin.x;
    int y=imView.frame.origin.y;
    int pointsX[6]={x+11,x+56,x+107,x+18,x+62,x+102};
    int pointsY[6]={y+30,y+5,y+30,y+80,y+57,y+80};
    [self.view addSubview:imView];
    _candiesCount=6;
    objectsCandies=[[NSMutableArray alloc] init];
    for (int i=0; i<6; i++) {
     
        UIImage *im = [UIImage imageNamed:[imagesCandy objectAtIndex:arc4random()%(imagesCandy.count)]];
        Candy *c=[[Candy alloc] initWithFrame:CGRectMake(pointsX[i], pointsY[i], im.size.height*0.9, im.size.width*0.9)];
        c.layer.zPosition=1;
        CGSize size=CGSizeMake(im.size.height*0.9, im.size.width*0.9);
        UIImage *im2=[self imageWithImage:im scaledToSize:size];
        c.backgroundColor=[UIColor colorWithPatternImage:im2];
        c.BonusLevelKind=2;
        c.delegate=self;
        [objectsCandies insertObject:c atIndex:i];
        [self.view addSubview:c];
        [c Move:true];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    if (Numb==3){
    for (int i=0; i<objectsCandies.count; i++) {
        Candy *c=objectsCandies[i];
        if ([[c.layer presentationLayer]hitTest:touchLocation])
        {
            CGRect position = [[c.layer presentationLayer] frame];
            c.frame=position;
            CATransform3D transform = [[c layer] transform];
            [UIView animateWithDuration:0.4 animations:^{
                  c.frame = c.centrBascket;
                  [c.layer setTransform:transform];
            } completion:^(BOOL finished){
               c.backgroundColor=[UIColor clearColor];
               [c cleanObject];
               [[FPGameManager sharedInstance] pickUpCandies:1];
               c.click=true;
                [self PickUpCandy];
            }];
            
            break;
            
        }
    }
    }
}

-(void)ForthBonusLevelLoad
{
    UIImage *im=[UIImage imageNamed:@"crew_cut_all_img"];
    UIImageView *imView=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.height/2-im.size.width/2, self.view.frame.size.width-im.size.height, im.size.width ,im.size.height )];
    imView.image=im;
    imView.layer.zPosition=0;
    [self.view addSubview:imView];
    MainRec=CGRectMake( -80, -70, 80, 68);
    int x=0;
    float deltaX=0;
    _candiesCount=20;
    objectsCandies=[[NSMutableArray alloc] init];
    for (int i=0; i<20; i++) {
        Candy *c=[Candy new];
        c.userInteractionEnabled=true;
        c.layer.zPosition=0;
        c.Animation=true;
        c.BonusLevelKind=3;
        UIImage *im;
        CGSize size;
        CGRect r;
        int s=arc4random()%2;
        if (s==0) {
            im = [UIImage imageNamed:[imagesCandySmall objectAtIndex:arc4random()%(imagesCandySmall.count)]];
            r=CGRectMake(-150, 20+arc4random()%100, im.size.height, im.size.width);
            size=CGSizeMake(im.size.height*0.8, im.size.width*0.8);
            c.Size=0;
            c.centrBascket=CGRectMake(imView.center.x-imView.frame.size.width/2+c.frame.size.width, imView.center.y-c.frame.size.height, im.size.height, im.size.width);
        }
        else
        {
            im = [UIImage imageNamed:[imagesCandy objectAtIndex:arc4random()%(imagesCandy.count)]];
            r=CGRectMake(-150, 20+arc4random()%100, im.size.height, im.size.width);
            size=CGSizeMake(im.size.height, im.size.width);
            c.centrBascket=CGRectMake(imView.center.x+imView.frame.size.width/2-im.size.width, imView.center.y-im.size.height/2, im.size.height, im.size.width);
            c.Size=1;
        }
        c.backgroundColor=[UIColor colorWithPatternImage:im];
        c.frame = r;
        c.BonusLevelKind=3;
        
        for (id r in c.gestureRecognizers) {
            [c removeGestureRecognizer:r];
        }
        
        [self.view addSubview:c];
        float y = c.frame.origin.y;
        float wx = CGRectGetHeight([[UIScreen mainScreen] bounds]);
        float time=(wx-deltaX)/wx*10;
        [objectsCandies insertObject:c atIndex:i];
        
        animation = [CAKeyframeAnimation animation];
        aPath = CGPathCreateMutable();
        CGPathMoveToPoint(aPath, nil,0-CGRectGetWidth(c.frame)-x,y);
        CGPathAddLineToPoint(aPath, nil, wx+CGRectGetWidth(c.frame),y);
        animation.path = aPath;
        animation.duration = time;
        animation.autoreverses = NO;
        animation.removedOnCompletion = NO;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [c.layer addAnimation:animation forKey:@"position"];
        c.delegate=self;
        x+=55;
        deltaX-=55;

      }
}
int tick=0;
-(void)handleTimer
{
    tick++;
    if (tick==1) {
        _accelerometer = [AccelerometerManager new];
        _accelerometer.delegate=self;
        [_accelerometer setShakeRangeWithMinValue:0.70 MaxValue:0.80];
        [_accelerometer startShakeDetect];
    }
    if(tick==3)
    {
      [timer invalidate];
        timer=nil;
    }
}
-(void)playMediaFinished:(NSNotification*)theNotification
{
    moviePlayerController=[theNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayerController];
    [moviePlayerController.view removeFromSuperview];
}
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma  mark - ShakeHappendDelegate
- (void) iPhoneDidShaked{
    if (Numb==0) {
        [self FirstBonusLevelDidShaked];
            }
    if (Numb==1) {
        [self SecondBonusLevelDidShaked];
            }
    
    if (Numb==2) {
        [self ThirdBonusLevelDidShaked];
           }
}

-(void)FirstBonusLevelDidShaked
{
    int m;
    if (objectsCandies.count!=0) {
        m=arc4random()%objectsCandies.count;
    }
    else
    {
        if (objectsCandies.count==0) {
            m=-1;
            [_accelerometer stopShakeDetect];
        }
    }
    if (m!=-1) {
        if (objectsCandies[m]!=nil){
            Candy *c=[Candy new];
            c=objectsCandies[m];
            [c Move:false];
            UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
            UIGravityBehavior *gravityBeahvior=[[UIGravityBehavior alloc] initWithItems:@[c]];
            UICollisionBehavior *collisionBehavior=[[UICollisionBehavior alloc] initWithItems:@[c]];
            collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
            c.CandiesPropertiesBehavior= [[UIDynamicItemBehavior alloc] initWithItems:@[c]];
            c.CandiesPropertiesBehavior.elasticity = 0.4;
            c.CandiesPropertiesBehavior.friction=0;
            c.CandiesPropertiesBehavior.resistance=0.0;
            c.CandiesPropertiesBehavior.allowsRotation=FALSE;
            [animator addBehavior:c.CandiesPropertiesBehavior];
            [animator addBehavior:gravityBeahvior];
            [animator addBehavior:collisionBehavior];
            c.animator = animator;
            c.Animation=true;
            [objectsCandies removeObjectAtIndex:m];
            CGRect rec=CGRectMake(c.frame.origin.x, self.view.frame.size.width-c.frame.size.height, c.frame.size.height, c.frame.size.width );
            c.frame=rec;
            
        }
    }

}

-(void)SecondBonusLevelDidShaked
{
    int m;
    if (objectsCandies.count!=0) {
        m=arc4random()%objectsCandies.count;
    }
    else
    {
        if (objectsCandies.count==0) {
            m=-1;
        }
    }
    if (m!=-1) {
        if (objectsCandies[m]!=nil)
        {
            FPFlover *f=[FPFlover new];
            f=objectsFlowers[m];
            CGRect rec1=CGRectMake(f.frame.origin.x, 190, f.frame.size.width, f.frame.size.height);
            Candy *c=[Candy new];
            c=objectsCandies[m];
            c.Animation=true;
            [objectsCandies removeObjectAtIndex:m];
            [objectsFlowers removeObjectAtIndex:m];
            UIImage *im = [UIImage imageNamed:[imagesCandy objectAtIndex:arc4random()%(imagesCandy.count)]];
            c.backgroundColor=[UIColor colorWithPatternImage:im];
            [UIView animateWithDuration:2.0 animations:^{
                 f.frame=rec1;
                 CGRect rec=CGRectMake(f.frame.origin.x+20, f.frame.origin.y+17, im.size.height, im.size.width);
                 c.frame=rec;
             } completion:^(BOOL finished){
                 [c Move:true];
             } ];
        }
    }

}

-(void)ThirdBonusLevelDidShaked
{
    int m;
    
    if (objectsCandies.count!=0) {
        m=arc4random()%objectsCandies.count;
    }
    else{
        if (objectsCandies.count==0) {
            m=-1;
        }
    }
    if (m!=-1)
    {
        if (objectsCandies[m]!=nil){
            Candy *c=[Candy new];
            c=objectsCandies[m];
            [objectsCandies removeObjectAtIndex:m];
            [objectsCandies2 insertObject:c atIndex:ii];
            ii++;
            [c Move:false];
            UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
            UIGravityBehavior *gravityBeahvior=[[UIGravityBehavior alloc] initWithItems:objectsCandies2];
            UICollisionBehavior *collisionBehavior=[[UICollisionBehavior alloc] initWithItems:objectsCandies2];
            collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
            c.CandiesPropertiesBehavior= [[UIDynamicItemBehavior alloc] initWithItems:objectsCandies2];
            c.CandiesPropertiesBehavior.elasticity = 0.5;
            [animator addBehavior:c.CandiesPropertiesBehavior];
            [animator addBehavior:gravityBeahvior];
            [animator addBehavior:collisionBehavior];
            c.animator = animator;
            c.Animation=true;
            lichulnuk++;
        }
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    for (int i=0; i<objectsCandies2.count; i++) {
        Candy *candy=[objectsCandies2 objectAtIndex:i];
        for(UIGestureRecognizer *recognizer in candy.gestureRecognizers){
            [candy removeGestureRecognizer:recognizer];
        }
        [candy cleanObject];
    }
    for (int i=0; i<objectsCandies.count; i++) {
        Candy *candy=[objectsCandies objectAtIndex:i];
        for(UIGestureRecognizer *recognizer in candy.gestureRecognizers){
            [candy removeGestureRecognizer:recognizer];
        }
        [candy cleanObject];
        [candy removeFromSuperview];
    }
    _accelerometer=nil;
    _animator=nil;
    _BTPropertiesBehavior=nil;
    moviePlayerController=nil;
    timer=nil;
    animation=nil;
    aPath=nil;
   // [UIView commitAnimations];
}

-(void)BonusLevelFinished
{
    
    FPGamePlayController *parent=(FPGamePlayController *)[self presentingViewController];
    [self bounceElements:@[_next] isInSuperView:self.view];
    
   // [parent bounceElements:@[parent.next] isInSuperView:self.view];
    NSLog(@"BonusLevel Finished");
}


- (IBAction)DeleteViewController:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)dealloc
{
    NSLog(@"vsdv");
}

-(void)PickUpCandy
{
    _candiesCount--;
    if (_candiesCount==0) {
        [self BonusLevelFinished];
    }
}

- (void)bounceElements:(NSArray *)elements isInSuperView:(BOOL)inSuperview
{
    for (UIView *element in elements) {
        CATransform3D transform = [[element layer] transform];
        if ([[[self view] subviews ] containsObject:element]) {
            [[element layer] setTransform:CATransform3DMakeScale(0, 0, 0)];
            element.alpha = 1;
        } else {
            [[element layer] setTransform:CATransform3DMakeScale(0, 0, 0)];
            [self.view addSubview:element];
        }
        [UIView animateWithDuration:kAnimationDuration*0.6 delay:[elements indexOfObject:element]*0.09 options:UIViewAnimationOptionCurveLinear animations:^{
            [[element layer] setTransform:CATransform3DMakeScale(1.2, 1.2, 1.2)];
            element.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:kAnimationDuration*0.6 animations:^{
                [[element layer] setTransform:transform];
                [element layoutIfNeeded];
            }];
        }];
    }
}


- (IBAction)next:(id)sender {
    FPGamePlayController *parent=(FPGamePlayController *)[self presentingViewController];
    FPLevelPresentationViewController *presentationController = (FPLevelPresentationViewController *)[parent presentingViewController];
    int levelNumber =[parent levelNumber];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:levelNumber+1 inSection:0];
    [presentationController updateColleCellAtIndexPath:indexPath];
   
   // [self dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
