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

@interface FPBonusViewController ()

{
    int points[10];
    NSMutableArray *objects;
    int Numb;
}


@property (weak, nonatomic) IBOutlet UIImageView *MainImage;


@end

@implementation FPBonusViewController

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
    Numb=0;
    switch (Numb) {
        case 0:
        {
            int x=20;
            int y=20;
            objects=[[NSMutableArray alloc]init];
            self.MainImage.layer.zPosition=1;
            for(int i=1; i<10; i++)
            {
                points[i-1]=x;
                Candies *c=[Candies new];
                c.centrBascket=self.MainImage.frame;
                c.layer.zPosition=0;
                UIImage *im=[UIImage imageNamed:@"candy_icon"];
                c.backgroundColor=[UIColor colorWithPatternImage:im];
                CGRect r=CGRectMake(x, y, 55, 55);
                c.frame = r;
                c.BonusLevelKind=0;
                
                [self.view addSubview:c];
                [objects insertObject:c atIndex:i-1];
                x+=50;
                
                CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
                CGMutablePathRef aPath = CGPathCreateMutable();
                float x = CGRectGetMidX(c.frame);
                float y = CGRectGetMidY(c.frame);
                
                CGPathMoveToPoint(aPath,nil,x,y);        //Origin Point
                CGPathAddCurveToPoint(aPath,nil, x,y,   //Control Point 1
                                      x,y+1,  //Control Point 2
                                      x+1,y-1); // End Point
                
                animation.rotationMode = @"auto";
                animation.path = aPath;
                animation.duration = 0.8+arc4random()%4;
                animation.autoreverses = YES;
                animation.removedOnCompletion = YES;
                animation.repeatCount = 100.0f;
          
                [c.layer addAnimation:animation forKey:@"position" ];
             
            }
            break;
        }
            case 1:
        {
            UIImage *im=[UIImage imageNamed:@"bonus_game_bg"];
            self.view.backgroundColor=[UIColor colorWithPatternImage:im];
            CGRect rec=CGRectMake(self.MainImage.frame.origin.x, 20, 55, 55);
            [self.MainImage setFrame: rec];
            self.MainImage.image=[UIImage imageNamed:@"sun_img"];
            
            objects=[[NSMutableArray alloc]init];
            int x=50;
            for (int i=0; i<4; i++) {
                points[i]=x;
                FPFlovers *f=[FPFlovers new];
                CGRect rec1=CGRectMake(x, 400,90,125);
                f.frame=rec1;
                [objects insertObject:f atIndex:i];
                 [self.view addSubview:f];
                x+=100;
            }

            break;
        }
        default:
            break;
    }
    
     //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hello World" message:@"This is my first app!" delegate:nil cancelButtonTitle:@"Awesome" otherButtonTitles:nil];
        

 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (BOOL)canBecomeFirstResponder
//{
//    return YES;
//}


- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        if (Numb==0) {
            int m;
            m=arc4random()%9;
            if (points[m]!=-1)
            {
                
                Candies *c=[Candies new];
                c=objects[m];
                
               CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
                
               CGMutablePathRef aPath = CGPathCreateMutable();
                
                float x = CGRectGetMidX(c.frame);
                float y = CGRectGetMidY(c.frame);
                
              
                CGPathMoveToPoint(aPath, nil, c.layer.position.x, c.layer.position.y);
               
                CGPathAddCurveToPoint(aPath, nil, x, y, c.layer.position.x, self.view.frame.size.height-c.frame.size.height/2, c.layer.position.x, self.view.frame.size.height-c.frame.size.height/2);
                
                
             //   animation.rotationMode = @"auto";
                animation.path = aPath;
                animation.duration = 1.0;
                animation.autoreverses = NO;
                animation.removedOnCompletion = YES;
//                animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
                [c.layer addAnimation:animation forKey:@"position" ];
                CGRect rec=CGRectMake(c.frame.origin.x, self.view.frame.size.height-c.frame.size.height , 55, 55);
        
                c.frame=rec;
                points[m]=-1;
            }
        }
        if (Numb==1) {
            int m;
            m=arc4random()%4;
            if (points[m]!=-1)
            {
                FPFlovers *f=[FPFlovers new];
                f=objects[m];
                CGRect rec1=CGRectMake(f.frame.origin.x, 200, 90, 125);
                
                [UIView animateWithDuration:2.0 animations:^{
                    f.frame=rec1;
               }];
            }
            
        }
        
    }
}









@end
