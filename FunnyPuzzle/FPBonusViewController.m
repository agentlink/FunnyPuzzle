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
    for(int i=1; i<10; i++)
    {
     Candies *c=[Candies new];
     c.centrBascket=self.BasketImage.frame;
     UIImage *im=[UIImage imageNamed:@"candy_icon.png"];
     c.backgroundColor=[UIColor colorWithPatternImage:im];
     CGRect r=CGRectMake(x, y, 55, 55);
     c.frame = r;
     [self.view addSubview:c];
     x+=50;
    }
 
  
//    int x=self.BasketImage.layer.position.x;
  //  int y=self.BasketImage.layer.position.y;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
