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
    Numb=1;
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
                NSLog(@"%f",self.view.frame.size.height);
                [UIView animateWithDuration:1.0 animations:^{
                    c.frame=CGRectMake(c.frame.origin.x, self.view.frame.size.height-c.frame.size.height, 55, 55);
                    c.Animation=true;
                }];
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
