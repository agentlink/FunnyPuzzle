//
//  FPBonusViewController.m
//  FunnyPuzzle
//
//  Created by Mac on 5/21/14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import "FPBonusViewController.h"
#import "Candies.h"

@interface FPBonusViewController ()

{
    int pointsX[10];
    int pointsY[10];
    NSMutableArray *candies;
}

@property (weak, nonatomic) IBOutlet Candies *Candie;
@property (weak, nonatomic) IBOutlet UIImageView *BasketImage;



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
    
    int x=20;
    int y=20;
   
    self.BasketImage.layer.zPosition=1;
    for(int i=1; i<10; i++)
    {
    Candies *c=[Candies new];
    c.centrBascket=self.BasketImage.frame;
    c.layer.zPosition=0;
    UIImage *im=[UIImage imageNamed:@"candy_icon.png"];
    c.backgroundColor=[UIColor colorWithPatternImage:im];
    CGRect r=CGRectMake(x, y, 55, 55);
    c.frame = r;
    [self.view addSubview:c];
    x+=50;
        
     //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hello World" message:@"This is my first app!" delegate:nil cancelButtonTitle:@"Awesome" otherButtonTitles:nil];
        
}
 
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
        self.view.backgroundColor=[UIColor blackColor];
        int m;
        m=arc4random()%10;
        if ((pointsX[m]!=-1)&&(pointsY[m]!=-1))
        {
            Candies *c=[Candies new];
            c.frame=CGRectMake(pointsX[m], pointsY[m], 55, 55);
            
            c.layer.zPosition=0;
            [UIView animateWithDuration:2.0 animations:^{
                c.frame=CGRectMake(pointsX[m], 200, 55, 55);
            }];
        }
    }
}









@end
