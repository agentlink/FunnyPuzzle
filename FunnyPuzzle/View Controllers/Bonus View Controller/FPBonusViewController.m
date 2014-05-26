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
    int kilk;
    NSMutableArray *objectsf,*objectsc,*objectsCD;
    int Numb;
    int xx;
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
    
    xx=20;
    UIImage *IM=[UIImage imageNamed:@"bonus_game_bg"];
    self.view.backgroundColor=[UIColor colorWithPatternImage:IM];
   
    Numb=1;
    switch (Numb) {
        case 0:
        {
            kilk=9;
            UIImage *im=[UIImage imageNamed:@"basket_icon"];
            int h=self.view.frame.size.height;
            int w=self.view.frame.size.width;
            CGRect rec=CGRectMake(h/2-im.size.height/2, w/2-im.size.width/2, im.size.width, im.size.height);
            UIImageView *imView=[[UIImageView alloc]initWithFrame:rec];
            imView.image=im;
            
            
            
            [self.view addSubview:imView];
            int x=20;
            int y=20;
            objectsc=[[NSMutableArray alloc]init];
            objectsCD=[[NSMutableArray alloc] init];
            imView.layer.zPosition=1;
        
            for(int i=1; i<10; i++)
            {
                points[i-1]=x;
                Candies *c=[Candies new];
                c.centrBascket=CGRectMake(imView.frame.origin.x, imView.frame.origin.y, 55, 55);
                c.layer.zPosition=0;
                UIImage *im=[UIImage imageNamed:@"candy_icon"];
                c.backgroundColor=[UIColor colorWithPatternImage:im];
                CGRect r=CGRectMake(x, y, 55, 55);
                c.frame = r;
                c.BonusLevelKind=0;
                
                [self.view addSubview:c];
                [objectsc insertObject:c atIndex:i-1];
                [objectsCD insertObject:c atIndex:i-1];
                x+=50;
                
                CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
                CGMutablePathRef aPath = CGPathCreateMutable();
                float x = CGRectGetMidX(c.frame);
                float y = CGRectGetMidY(c.frame);
                
                CGPathMoveToPoint(aPath,nil,x,y);        //Origin Point
                CGPathAddCurveToPoint(aPath,nil, x,y,   //Control Point 1
                                      x+0.2,y,  //Control Point 2
                                      x+0.1,y-0.1); // End Point
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
            

            UIImage *im2=[UIImage imageNamed:@"basket_icon"];
            
            
            int h=self.view.frame.size.height;
            int w=self.view.frame.size.width;
            CGRect rec=CGRectMake(h/2-im2.size.height/2, w/2-im2.size.width/2-self.view.frame.size.width/4, im2.size.width, im2.size.height);

            UIImageView *imView=[[UIImageView alloc] initWithFrame:rec];
            imView.image=im2;
            [self.view addSubview:imView];
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            CGMutablePathRef aPath = CGPathCreateMutable();
            float x = CGRectGetMidX(imView.frame);
            float y = CGRectGetMidY(imView.frame);
            
           // CGPathMoveToPoint(aPath,nil,x+0.1,y);        //Origin Point
          //  CGPathAddCurveToPoint(aPath,nil, x,y,   //Control Point 1
           //                       x+0.1,y+0.1,  //Control Point 2
           //                       x+0.2,y+0.2); // End Point
            
            CGPathAddArc(aPath, NULL, x, y, 360, -M_PI_2, M_PI_2, YES);
            
            animation.rotationMode = @"auto";
            animation.path = aPath;
            animation.duration = 0.8+arc4random()%4;
        //    animation.autoreverses = YES;
            animation.removedOnCompletion = YES;
            animation.repeatCount = 100.0f;
            
            [imView.layer addAnimation:animation forKey:@"position" ];
            
            
            
            objectsf=[[NSMutableArray alloc]init];
            objectsc=[[NSMutableArray alloc]init];
            x=50;
            for (int i=0; i<4; i++)
            {
                points[i]=x;
                FPFlovers *f=[FPFlovers new];
                CGRect rec1=CGRectMake(x, 400,90,125);
                f.frame=rec1;
                f.layer.zPosition=0;
                [objectsf insertObject:f atIndex:i];
                
                 [self.view addSubview:f];
             
                Candies *c=[Candies new];
                CGRect rec=CGRectMake(x+20, f.frame.origin.y+17, 55, 55);
                c.frame=rec;
                c.layer.zPosition=1;
                UIImage *im=[UIImage imageNamed:@"candy_icon"];
                c.backgroundColor=[UIColor colorWithPatternImage:im];
                c.BonusLevelKind=1;
                [objectsc insertObject:c atIndex:i];
                  [self.view addSubview:c];
                
                
                CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
                CGMutablePathRef aPath = CGPathCreateMutable();
                float x1 = CGRectGetMidX(c.frame);
                float y1 = CGRectGetMidY(c.frame);
                
                CGPathMoveToPoint(aPath,nil,x1,y1);        //Origin Point
                CGPathAddCurveToPoint(aPath,nil, x1,y1,   //Control Point 1
                                      x1,y1+1,  //Control Point 2
                                      x1+1,y1-1); // End Point
                
                animation.rotationMode = @"auto";
                animation.path = aPath;
                animation.duration = 0.8+arc4random()%4;
                animation.autoreverses = YES;
                animation.removedOnCompletion = YES;
                animation.repeatCount = 100.0f;
                
                
                
                [c.layer addAnimation:animation forKey:@"position" ];
                   x+=100;
                
            }

            break;
        }
            case 2:
        {
            kilk=6;
            UIImage *im=[UIImage imageNamed:@"tree_img"];
            int h=self.view.frame.size.height;
            int w=self.view.frame.size.width;
            CGRect rec=CGRectMake(h/2-im.size.height/4, w/2-im.size.width/2-50, im.size.width, im.size.height);
            UIImageView *imView=[[UIImageView alloc]initWithFrame:rec];
            imView.image=im;

            int x=imView.frame.origin.x;
            int y=imView.frame.origin.y;
            
            int pointsX[6];
            int pointsY[6];
            rec=CGRectMake(x+35, y+50, 45, 45);
            pointsX[0]=rec.origin.x;
            pointsY[0]=rec.origin.y;
            rec=CGRectMake(x+80, y+25, 45, 45);
            pointsX[1]=rec.origin.x;
            pointsY[1]=rec.origin.y;
            rec=CGRectMake(x+125, y+50, 45, 45);
            pointsX[2]=rec.origin.x;
            pointsY[2]=rec.origin.y;
            rec=CGRectMake(x+35, y+100, 45, 45);
            pointsX[3]=rec.origin.x;
            pointsY[3]=rec.origin.y;
            rec=CGRectMake(x+80, y+77, 45, 45);
            pointsX[4]=rec.origin.x;
            pointsY[4]=rec.origin.y;
            rec=CGRectMake(x+130, y+100, 45, 45);
            pointsX[5]=rec.origin.x;
            pointsY[5]=rec.origin.y;
            
            [self.view addSubview:imView];
            
            objectsc=[[NSMutableArray alloc]init];
            objectsCD=[[NSMutableArray alloc] init];
            
            for (int i=0; i<6; i++) {
                Candies *c=[Candies new];
                
                rec=CGRectMake(pointsX[i], pointsY[i], 45, 45);
                int mx=pointsX[i];
                int my=pointsY[i];
                c.frame=rec;
                c.layer.zPosition=1;
                
                UIImage *im=[UIImage imageNamed:@"candy_icon"];
                
                CGSize size=CGSizeMake(45, 45);
                UIImage *im2=[self imageWithImage:im scaledToSize:size];
                
                c.backgroundColor=[UIColor colorWithPatternImage:im2];
                c.BonusLevelKind=2;
                [objectsc insertObject:c atIndex:i];
                [objectsCD insertObject:c atIndex:i];
                [self.view addSubview:c];
                
                CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
                CGMutablePathRef aPath = CGPathCreateMutable();

                
                CGPathMoveToPoint(aPath,nil,mx,my);        //Origin Point
                CGPathAddCurveToPoint(aPath,nil, mx,my,   //Control Point 1
                                      mx,my+1,  //Control Point 2
                                      mx+1,my-1); // End Point
                
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
        default:
            break;
    }
    
     //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hello World" message:@"This is my first app!" delegate:nil cancelButtonTitle:@"Awesome" otherButtonTitles:nil];
        

 
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
                
                Candies *c=[Candies new];
                c=objectsCD[m];
                
               CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
                
               CGMutablePathRef aPath = CGPathCreateMutable();
                
                float x = CGRectGetMidX(c.frame);
                float y = CGRectGetMidY(c.frame);
                
              
                CGPathMoveToPoint(aPath, nil, c.layer.position.x, c.layer.position.y);
               
                CGPathAddCurveToPoint(aPath, nil, x, y, c.layer.position.x, self.view.frame.size.height-c.frame.size.height/2, c.layer.position.x, self.view.frame.size.height-c.frame.size.height/2);
                
                
                animation.rotationMode = @"auto";
                animation.path = aPath;
                animation.duration = 1.0;
                animation.autoreverses = NO;
                animation.removedOnCompletion = YES;

                [c.layer addAnimation:animation forKey:@"position" ];
                CGRect rec=CGRectMake(c.frame.origin.x, self.view.frame.size.height-c.frame.size.height , 55, 55);
        
                c.frame=rec;
                c.Animation=true;
                [objectsCD removeObjectAtIndex:m];
                kilk--;
                
                CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animation];
                CGMutablePathRef aPath1 = CGPathCreateMutable();
                x = CGRectGetMidX(c.frame);
                y = CGRectGetMidY(c.frame);
                
                CGPathMoveToPoint(aPath1,nil,x,y);        //Origin Point
                CGPathAddCurveToPoint(aPath1,nil, x,y,   //Control Point 1
                                      x,y+1,  //Control Point 2
                                      x+1,y-1); // End Point
                
                animation1.rotationMode = @"auto";
                animation1.path = aPath1;
                animation1.duration = 0.8+arc4random()%4;
                animation1.autoreverses = YES;
                animation1.removedOnCompletion = YES;
                animation1.repeatCount = 100.0f;
                
                [c.layer addAnimation:animation1 forKey:@"position" ];

            }
        }
        }
        if (Numb==1) {
            int m;
            m=arc4random()%4;
            if (points[m]!=-1)
            {
                FPFlovers *f=[FPFlovers new];
                f=objectsf[m];
                CGRect rec1=CGRectMake(f.frame.origin.x, 190, 90, 125);
                Candies *c=[Candies new];
                c=objectsc[m];
                c.Animation=true;
                CGRect rec=CGRectMake(c.frame.origin.x, 190+17, 55, 55);
                [UIView animateWithDuration:2.0 animations:^{
                    f.frame=rec1;
                    c.frame=rec;
                }completion:^(BOOL finished)
                {
                    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
                    CGMutablePathRef aPath = CGPathCreateMutable();
                    float x1 = CGRectGetMidX(c.frame);
                    float y1 = CGRectGetMidY(c.frame);
                    CGPathMoveToPoint(aPath,nil,x1,y1);        //Origin Point
                    CGPathAddCurveToPoint(aPath,nil, x1,y1,   //Control Point 1
                                          x1,y1+1,  //Control Point 2
                                          x1+1,y1-1); // End Point
                    animation.rotationMode = @"auto";
                    animation.path = aPath;
                    animation.duration = 0.8+arc4random()%4;
                    animation.autoreverses = YES;
                    animation.removedOnCompletion = YES;
                    animation.repeatCount = 100.0f;
                    [c.layer addAnimation:animation forKey:@"position" ];

                }];
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
                   
                    CGRect rec=CGRectMake(xx, self.view.frame.size.width-self.view.frame.size.width/2, 55, 55);
                    [UIView animateWithDuration:2.0 animations:^{
                        c.frame=rec;
                    }completion:^(BOOL finished)
                     {
                         UIImage *im=[UIImage imageNamed:@"candy_icon"];
                         c.backgroundColor=[UIColor colorWithPatternImage:im];
                         CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
                         CGMutablePathRef aPath = CGPathCreateMutable();
                         float x1 = CGRectGetMidX(c.frame);
                         float y1 = CGRectGetMidY(c.frame);
                         CGPathMoveToPoint(aPath,nil,x1,y1);        //Origin Point
                         CGPathAddCurveToPoint(aPath,nil, x1,y1,   //Control Point 1
                                               x1,y1+1,  //Control Point 2
                                               x1+1,y1-1); // End Point
                         animation.rotationMode = @"auto";
                         animation.path = aPath;
                         animation.duration = 0.8+arc4random()%4;
                         animation.autoreverses = YES;
                         animation.removedOnCompletion = YES;
                         animation.repeatCount = 100.0f;
                         [c.layer addAnimation:animation forKey:@"position" ];
                         
                     }];
                    xx+=80;

                }
            }

        }
        
    }
}









@end
