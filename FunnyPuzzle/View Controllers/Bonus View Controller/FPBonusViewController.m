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
    int kilk,kilk1;
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
            kilk=9;
            kilk1=9;
            UIImage *im=[UIImage imageNamed:@"basket_icon"];
            CGRect rec=CGRectMake(h/2-im.size.height/2, w/2-im.size.width/2, im.size.width, im.size.height);
            UIImageView *imView=[[UIImageView alloc]initWithFrame:rec];
            imView.image=im;
            imView.layer.zPosition=1;
            [self.view addSubview:imView];
            int x=20;
            int y=20;
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
                x+=50;
                [c Move:true];
            }
            break;
        }
            case 1:
        {
            UIImage *IM=[UIImage imageNamed:@"bonus_game_bg"];
            self.view.backgroundColor=[UIColor colorWithPatternImage:IM];
            kilk=4;
            kilk1=4;
            UIImage *im2=[UIImage imageNamed:@"sun_img"];
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
            for (int i=0; i<4; i++)
            {
                FPFlovers *f=[FPFlovers new];
                UIImage *im=[UIImage imageNamed:@"flower_img"];
                CGRect rec1=CGRectMake(x, self.view.frame.size.width,im.size.width,im.size.height);
                f.backgroundColor=[UIColor colorWithPatternImage:im];
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
                x+=100;
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
            kilk=6;
            kilk1=6;
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
            MainRec=CGRectMake( -80, -70, 80, 68);
            int x=0;
            float deltaX=0;
            objectsCD=[[NSMutableArray alloc] init];
            for (int i=0; i<20; i++) {
                Candies *c=[Candies new];
                c.layer.zPosition=2;
                UIImage *im = [UIImage imageNamed:[imagesCandy objectAtIndex:arc4random()%(imagesCandy.count)]];
                c.backgroundColor=[UIColor colorWithPatternImage:im];
                CGRect r=CGRectMake(0, 20+arc4random()%120, 55, 55);
                c.frame = r;
                c.BonusLevelKind=0;
                [self.view addSubview:c];
                animation = [CAKeyframeAnimation animation];
                aPath = CGPathCreateMutable();
                float y = c.frame.origin.y;
                float wx = CGRectGetHeight([[UIScreen mainScreen] bounds]);
                CGPathMoveToPoint(aPath, nil,0-CGRectGetWidth(c.frame)-x,y);
                CGPathAddLineToPoint(aPath, nil, wx+CGRectGetWidth(c.frame),y);
                float time=(wx-deltaX)/wx*5;
                animation.path = aPath;
                animation.duration = time;
                animation.autoreverses = NO;
                animation.removedOnCompletion = NO;
              //  animation.repeatCount = INFINITY;
                animation.timingFunction = [CAMediaTimingFunction
                                            functionWithName:kCAMediaTimingFunctionLinear];
                
                [c.layer addAnimation:animation forKey:@"position"];
                //[animation setDelegate:self];
                x+=55;
                deltaX-=55;
            }
            break;
            
        }
        default:
            break;
    }
//    NSString *filepath   =   [[NSBundle mainBundle] pathForResource:@"Comp4_1" ofType:@"mp4"];
//    NSURL    *fileURL    =   [NSURL fileURLWithPath:filepath];
//    moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
//    [moviePlayerController.view setFrame:MainRec];
//    moviePlayerController.controlStyle=MPMovieControlStyleNone;
//    moviePlayerController.scalingMode =MPMovieScalingModeAspectFit;
//    [moviePlayerController prepareToPlay];
//    moviePlayerController.view.backgroundColor=[UIColor clearColor];
//    moviePlayerController.view.layer.zPosition=5;
//    [self.view addSubview:moviePlayerController.view];
//    [moviePlayerController play];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(playMediaFinished:)
//                                                 name:MPMoviePlayerPlaybackDidFinishNotification
//                                               object:moviePlayerController];
//    tick=0;
//    timer = [NSTimer scheduledTimerWithTimeInterval: 1.0
//                                             target: self
//                                           selector: @selector(handleTimer)
//                                           userInfo: nil
//                                            repeats: YES];
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
        if (kilk!=0) {
            m=arc4random()%kilk;
        }
        else
        {
            if (kilk==0) {
                m=-1;
                 [_accelerometer stopShakeDetect];
            }
        }
        if (m!=-1) {
            if (objectsCD[m]!=nil)
            {
                Candies *c=[Candies new];
                c=objectsCD[m];
               // [c.layer removeAnimationForKey:@"position"];
                [c Move:false];
                UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
                UIGravityBehavior *gravityBeahvior=[[UIGravityBehavior alloc] initWithItems:@[c]];
                UICollisionBehavior *collisionBehavior=[[UICollisionBehavior alloc] initWithItems:@[c]];
                collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
                c.CandiesPropertiesBehavior= [[UIDynamicItemBehavior alloc] initWithItems:@[c]];
                c.CandiesPropertiesBehavior.elasticity = 1.0;
                c.CandiesPropertiesBehavior.friction=0;
                c.CandiesPropertiesBehavior.resistance=0.0;
                c.CandiesPropertiesBehavior.allowsRotation=FALSE;
                [animator addBehavior:c.CandiesPropertiesBehavior];
                [animator addBehavior:gravityBeahvior];
                [animator addBehavior:collisionBehavior];
                c.animator = animator;
                c.Animation=true;
                [objectsCD removeObjectAtIndex:m];
                kilk--;
                NSLog(@"Shake");
                CGRect rec=CGRectMake(c.frame.origin.x, self.view.frame.size.width-c.frame.size.height, c.frame.size.height, c.frame.size.width );
                c.frame=rec;
            }
        }
    }
    if (Numb==1) {
        int m;
        if (kilk!=0) {
            m=arc4random()%kilk;
        }
        else
        {
            if (kilk==0) {
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
                kilk--;
                int l=arc4random()%4;
                UIImage *im=[UIImage imageNamed:imagesCandy[l]];
                c.backgroundColor=[UIColor colorWithPatternImage:im];
                [UIView animateWithDuration:2.0 animations:^
                 {
                     f.frame=rec1;
                     CGRect rec=CGRectMake(f.frame.origin.x+20, f.frame.origin.y+17, im.size.height, im.size.width);
                     c.frame=rec;
                 
//                 } completion:^(BOOL finished)
//                 {
//                     CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animation];
//                     CGMutablePathRef aPath1 = CGPathCreateMutable();
//                     int x = CGRectGetMidX(c.frame);
//                     int y = CGRectGetMidY(c.frame);
//                     CGPathMoveToPoint(aPath1,nil,x,y);        //Origin Point
//                     CGPathAddCurveToPoint(aPath1,nil, x,y,   //Control Point 1
//                                           x,y+1,  //Control Point 2
//                                           x+1,y-1); // End Point
//                     animation1.rotationMode = @"auto";
//                     animation1.path = aPath1;
//                     animation1.duration = 0.8+arc4random()%4;
//                     animation1.autoreverses = YES;
//                     animation1.removedOnCompletion = YES;
//                     animation1.repeatCount = 100.0f;
//                     [c.layer addAnimation:animation1 forKey:@"position" ];
//                     
                 } ];
            }
        }
    }
    
    if (Numb==2) {
        int m;
        
        if (kilk!=0) {
            m=arc4random()%kilk;
        }
        else
        {
            if (kilk==0) {
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
                kilk--;
                [c.layer removeAnimationForKey:@"position"];
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


- (IBAction)DeleteViewController:(id)sender {
    
     [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    
}

@end
