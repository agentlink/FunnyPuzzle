//
//  FPBonusViewController.m
//  FunnyPuzzle
//
//  Created by Mac on 5/21/14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import "FPBonusViewController.h"
#import "Candies.h"
#import "FPFlovers.h"
#import "AccelerometerManager.h"
#import <MediaPlayer/MediaPlayer.h>

@interface FPBonusViewController ()<ShakeHappendDelegate>

{
    NSMutableArray *objectsc,*objectsCD,*objectsCF;
    NSArray *imagesCandy;
    int Numb;
    int xx;
    MPMoviePlayerController *moviePlayerController;
    NSTimer *timer;
    CAKeyframeAnimation *animation;
    CGMutablePathRef aPath;
    int ii;
}

@property (weak, nonatomic) IBOutlet UIButton *Bt;
- (IBAction)DeleteViewController:(id)sender;
@property (nonatomic, strong) UIDynamicItemBehavior *BTPropertiesBehavior;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) AccelerometerManager *accelerometer;
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
    CGRect  MainRec=CGRectMake( 0, 0,  80, 68);
    xx=20;
    imagesCandy=[NSArray arrayWithObjects:@"candy_blue",@"candy_green",@"candy_orange",@"candy_yellow_blue", nil];
    int h=self.view.frame.size.height;
    int w=self.view.frame.size.width;
    Numb=0;
    switch (Numb) {
        case 0:
        {
            self.view.backgroundColor=[UIColor colorWithRed:209 green:233 blue:250 alpha:1];
            MainRec=CGRectMake( self.view.frame.size.height/2-40, self.view.frame.size.width/2-34,  80, 68);
            UIImage *im=[UIImage imageNamed:@"basket_icon"];
            CGRect rec=CGRectMake(h/2-im.size.height/2, w/2-im.size.width/2, im.size.width, im.size.height);
            UIImageView *imView=[[UIImageView alloc]initWithFrame:rec];
            imView.image=im;
            imView.layer.zPosition=1;
            [self.view addSubview:imView];
            float x=20;
            float y=20;
            float delta=CGRectGetHeight([[UIScreen mainScreen] bounds])/10;
            objectsc=[[NSMutableArray alloc]init];
            objectsCD=[[NSMutableArray alloc] init];
            imView.layer.zPosition=1;
            for(int i=1; i<10; i++)
            {
                Candies *c=[Candies new];
                c.centrBascket=CGRectMake(imView.frame.origin.x, imView.frame.origin.y, 55, 55);
                c.layer.zPosition=2;
                UIImage *im = [UIImage imageNamed:[imagesCandy objectAtIndex:arc4random()%(imagesCandy.count)]];
                c.backgroundColor=[UIColor colorWithPatternImage:im];
                CGRect r=CGRectMake(x, y, 55, 55);
                c.frame = r;
                c.BonusLevelKind=0;
                [self.view addSubview:c];
                [objectsc insertObject:c atIndex:i-1];
                [objectsCD insertObject:c atIndex:i-1];
                x+=delta;
                [c Move:true];
            }
            break;
        }
            case 1:
        {
            UIImage *IM=[UIImage imageNamed:@"bonus_game_bg"];
            self.view.backgroundColor=[UIColor colorWithPatternImage:IM];
            UIImage *im2=[UIImage imageNamed:@"sun_img"];
            float delta=CGRectGetHeight([[UIScreen mainScreen] bounds])/6;
            CGRect rec=CGRectMake( h/2-im2.size.height/2, w/2-im2.size.width,  im2.size.height, im2.size.width);
            MainRec=CGRectMake( h/2-40, w/2,  80, 68);
            UIImageView *imView=[[UIImageView alloc]initWithFrame:rec];
            imView.image=im2;
            [self.view addSubview:imView];
            animation = [CAKeyframeAnimation animation];
            aPath = CGPathCreateMutable();
            float x = CGRectGetMidX(imView.frame);
            float y = CGRectGetMidY(imView.frame);
            CGPathAddArc(aPath, NULL, x, y, 0.1f, 0.f, (360* M_PI)/180, NO);
            animation.rotationMode = @"auto";
            animation.path = aPath;
            animation.duration = 2.8;
            animation.removedOnCompletion = YES;
            animation.repeatCount = 100.0f;
            [imView.layer addAnimation:animation forKey:@"position" ];
            objectsc=[[NSMutableArray alloc]init];
            objectsCD=[[NSMutableArray alloc] init];
            objectsCF=[[NSMutableArray alloc] init];
            x=50;
            for (int i=0; i<5; i++)
            {
                FPFlovers *f=[FPFlovers new];
                UIImage *im=[UIImage imageNamed:@"flower_img"];
                f.backgroundColor=[UIColor colorWithPatternImage:im];
                CGRect rec1=CGRectMake(x, self.view.frame.size.width,im.size.width,im.size.height);
                f.frame=rec1;
                f.layer.zPosition=0;
                [objectsCF insertObject:f atIndex:i];
                [self.view addSubview:f];
                Candies *c=[Candies new];
                UIImage *im2 = [UIImage imageNamed:[imagesCandy objectAtIndex:arc4random()%(imagesCandy.count)]];
                CGRect rec=CGRectMake(x+20, f.frame.origin.y+17, im2.size.height, im2.size.width);
                c.frame=rec;
                c.layer.zPosition=1;
                c.BonusLevelKind=1;
                [objectsc insertObject:c atIndex:i];
                [objectsCD insertObject:c atIndex:i];
                [self.view addSubview:c];
                x+=delta;
                [c Move:true];
            }
            break;
        }
            case 2:
        {
            ii=0;
            objectsc=[[NSMutableArray alloc]init];
            UIImage *IM=[UIImage imageNamed:@"bonus_game_bg"];
            self.view.backgroundColor=[UIColor colorWithPatternImage:IM];
            UIImage *im=[UIImage imageNamed:@"tree_img"];
            int h=self.view.frame.size.height;
            int w=self.view.frame.size.width;
            CGRect rec=CGRectMake(h/2-im.size.height/4, w/2-im.size.width/2-50, im.size.width, im.size.height);
            UIImageView *imView=[[UIImageView alloc]initWithFrame:rec];
            MainRec=CGRectMake( rec.origin.x+40, rec.origin.y+34,  80, 68);
            imView.image=im;
            int x=imView.frame.origin.x;
            int y=imView.frame.origin.y;
            int pointsX[6]={x+11,x+56,x+107,x+18,x+62,x+102};
            int pointsY[6]={y+30,y+5,y+30,y+80,y+57,y+80};
            [self.view addSubview:imView];
            objectsCD=[[NSMutableArray alloc] init];
            for (int i=0; i<6; i++) {
                Candies *c=[Candies new];
                rec=CGRectMake(pointsX[i], pointsY[i], 45, 45);
                c.frame=rec;
                c.layer.zPosition=1;
                UIImage *im = [UIImage imageNamed:[imagesCandy objectAtIndex:arc4random()%(imagesCandy.count)]];
                CGSize size=CGSizeMake(45, 45);
                UIImage *im2=[self imageWithImage:im scaledToSize:size];
                c.backgroundColor=[UIColor colorWithPatternImage:im2];
                c.BonusLevelKind=2;
                [objectsCD insertObject:c atIndex:i];
                [self.view addSubview:c];
                [c Move:true];
            }
            break;
        }
            case 3:
        {
            UIImage *IM=[UIImage imageNamed:@"bonus_game_bg"];
            self.view.backgroundColor=[UIColor colorWithPatternImage:IM];
            UIImageView *imView=[[UIImageView alloc]init];
            UIImage *im=[UIImage imageNamed:@"crew_cut_all_img"];
            CGRect rect=CGRectMake(self.view.frame.size.height/2-im.size.width/2, self.view.frame.size.width-im.size.height, im.size.width ,im.size.height );
            imView.frame=rect;
            imView.image=im;
            imView.layer.zPosition=0;
            [self.view addSubview:imView];
            MainRec=CGRectMake( -80, -70, 80, 68);
            int x=0;
            float deltaX=0;
            objectsCD=[[NSMutableArray alloc] init];
            for (int i=0; i<5; i++) {
                Candies *c=[Candies new];
                c.layer.zPosition=0;
                c.Animation=true;
                c.BonusLevelKind=3;
                CGRect r;
                int s=arc4random()%2;
                UIImage *im = [UIImage imageNamed:[imagesCandy objectAtIndex:arc4random()%(imagesCandy.count)]];
                CGSize size;
                UIImage *im2;
                
                if (s==0) {
                    r=CGRectMake(0, 20+arc4random()%100, 45, 45);
                    size=CGSizeMake(45, 45);
                    im2=[self imageWithImage:im scaledToSize:size];
                    c.Size=0;
                    c.centrBascket=CGRectMake(imView.frame.origin.y, imView.frame.origin.x+imView.frame.size.height*0.6, 45, 45);
                }
                else
                {
                    r=CGRectMake(0, 20+arc4random()%100, 55, 55);
                    size=CGSizeMake(55, 55);
                    im2=[self imageWithImage:im scaledToSize:size];
                    c.centrBascket=CGRectMake(imView.frame.origin.y+imView.frame.size.width*0.7, imView.frame.origin.x+imView.frame.size.height*0.5, 55, 55);
                    c.Size=1;
                }
                
                c.backgroundColor=[UIColor colorWithPatternImage:im2];
                c.frame = r;
                c.BonusLevelKind=3;
                c.tag=255;
                UITapGestureRecognizer* gestureRecognizer;
                
                gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doSomthing:)];
                gestureRecognizer.numberOfTapsRequired = 1;
                
                [self.view addSubview:c];
                
                [c addGestureRecognizer:gestureRecognizer];

                
                
                float y = c.frame.origin.y;
                float wx = CGRectGetHeight([[UIScreen mainScreen] bounds]);
                float time=(wx-deltaX)/wx*10;
                CGRect rec;
                if (s==0) {
                    rec=CGRectMake(wx+CGRectGetWidth(c.frame), y, 45, 45);
                    CGRect rect=CGRectMake(0-CGRectGetWidth(c.frame)-x, y, 45, 45);
                    c.frame=rect;
                }
                else
                {
                    rec=CGRectMake(wx+CGRectGetWidth(c.frame), y, 55, 55);
                    CGRect rect=CGRectMake(0-CGRectGetWidth(c.frame)-x, y, 55, 55);
                    c.frame=rect;
                }
                CGPoint point=CGPointMake(300, 300);
                [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                    c.layer.position=point;
                    // c.frame = rec;
                } completion:^(BOOL finished){
                    [c cleanObject];
                    [c removeFromSuperview];
                }];

//                animation = [CAKeyframeAnimation animation];
//                aPath = CGPathCreateMutable();
//                //float y = c.frame.origin.y;
//                //float wx = CGRectGetHeight([[UIScreen mainScreen] bounds]);
//                CGPathMoveToPoint(aPath, nil,0-CGRectGetWidth(c.frame)-x,y);
//                CGPathAddLineToPoint(aPath, nil, wx+CGRectGetWidth(c.frame),y);
//                //float time=(wx-deltaX)/wx*7;
//                animation.path = aPath;
//                animation.duration = time;
//                animation.autoreverses = NO;
//                animation.removedOnCompletion = NO;
//                animation.timingFunction = [CAMediaTimingFunction
//                                            functionWithName:kCAMediaTimingFunctionLinear];
//                [c.layer addAnimation:animation forKey:@"position"];
                x+=55;
                deltaX-=55;
            }
            break;
            
        }
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
   // NSLog(@"view number :%@",[[touch view] class]);
    NSLog(@"view %li", (long)[[touch view] tag]);
}

-(void)doSomthing:(id)sender
{
    UIView* temp = [(UITapGestureRecognizer*)sender view];
    NSLog(@"view number :%@",[temp class]);
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
        int m;
        if (objectsCD.count!=0) {
            m=arc4random()%objectsCD.count;
        }
        else
        {
            if (objectsCD.count==0) {
                m=-1;
                 [_accelerometer stopShakeDetect];
            }
        }
        if (m!=-1) {
            if (objectsCD[m]!=nil)
            {
                Candies *c=[Candies new];
                c=objectsCD[m];
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
                [objectsCD removeObjectAtIndex:m];
                CGRect rec=CGRectMake(c.frame.origin.x, self.view.frame.size.width-c.frame.size.height, c.frame.size.height, c.frame.size.width );
                c.frame=rec;
            }
        }
    }
    if (Numb==1) {
        int m;
        if (objectsCD.count!=0) {
            m=arc4random()%objectsCD.count;
        }
        else
        {
            if (objectsCD.count==0) {
                m=-1;
            }
        }
        if (m!=-1) {
            if (objectsCD[m]!=nil)
            {
                FPFlovers *f=[FPFlovers new];
                f=objectsCF[m];
                CGRect rec1=CGRectMake(f.frame.origin.x, 190, 90, 125);
                Candies *c=[Candies new];
                c=objectsCD[m];
                c.Animation=true;
                [objectsCD removeObjectAtIndex:m];
                [objectsCF removeObjectAtIndex:m];
                UIImage *im = [UIImage imageNamed:[imagesCandy objectAtIndex:arc4random()%(imagesCandy.count)]];
                c.backgroundColor=[UIColor colorWithPatternImage:im];
                [UIView animateWithDuration:2.0 animations:^
                 {
                     f.frame=rec1;
                     CGRect rec=CGRectMake(f.frame.origin.x+20, f.frame.origin.y+17, im.size.height, im.size.width);
                     c.frame=rec;
                 } completion:^(BOOL finished)
                 {
                     [c Move:true];
                 } ];
            }
        }
    }
    
    if (Numb==2) {
        int m;
        
        if (objectsCD.count!=0) {
            m=arc4random()%objectsCD.count;
        }
        else
        {
            if (objectsCD.count==0) {
                m=-1;
            }
        }
        if (m!=-1)
        {
            if (objectsCD[m]!=nil)
            {
                Candies *c=[Candies new];
                c=objectsCD[m];
                [objectsCD removeObjectAtIndex:m];
                [objectsc insertObject:c atIndex:ii];
                ii++;
                [c Move:false];
                UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
                UIGravityBehavior *gravityBeahvior=[[UIGravityBehavior alloc] initWithItems:objectsc];
                UICollisionBehavior *collisionBehavior=[[UICollisionBehavior alloc] initWithItems:objectsc];
                collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
                c.CandiesPropertiesBehavior= [[UIDynamicItemBehavior alloc] initWithItems:objectsc];
                c.CandiesPropertiesBehavior.elasticity = 0.5;
                [animator addBehavior:c.CandiesPropertiesBehavior];
                [animator addBehavior:gravityBeahvior];
                [animator addBehavior:collisionBehavior];
                c.animator = animator;
                c.Animation=true;
            }
        }
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    for (int i=0; i<objectsc.count; i++) {
        Candies *candy=[objectsc objectAtIndex:i];
        for(UIGestureRecognizer *recognizer in candy.gestureRecognizers)
        {
            [candy removeGestureRecognizer:recognizer];
        }
        candy.cleanObject;
    }
    for (int i=0; i<objectsCD.count; i++) {
        Candies *candy=[objectsCD objectAtIndex:i];
        for(UIGestureRecognizer *recognizer in candy.gestureRecognizers)
        {
            [candy removeGestureRecognizer:recognizer];
        }
        candy.cleanObject;
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

- (IBAction)DeleteViewController:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)dealloc
{
    NSLog(@"vsdv");
}


@end
