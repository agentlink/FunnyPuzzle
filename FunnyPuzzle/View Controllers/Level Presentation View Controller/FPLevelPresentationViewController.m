//
//  FPLevelPresentationViewController.m
//  FunnyPuzzle
//
//  Created by Misha on 29.05.14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import "FPLevelPresentationViewController.h"
#import "FPLevelManager.h"
#import "FPLevelCell.h"
#import "JMIBlur.h"
#import "GamePlayViewController.h"
#import "GameModel.h"
#import "FPGamePlayController.h"
#import "UIImage+ImageEffects.h"

@interface FPLevelPresentationViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) IBOutlet UIButton *back;
@property (nonatomic, weak) IBOutlet UICollectionView *collection;
@property (nonatomic, strong) NSArray *levels;
@property (nonatomic, weak) IBOutlet FPGamePlayController *controller;
- (IBAction)menu:(id)sender;
@end

@implementation FPLevelPresentationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)setGameType:(FPGameType)gameType
{
    _gameType = gameType;
    [self setLevels:[FPLevelManager allLevels:gameType]];
}
- (void)setLevels:(NSArray *)levels
{
    _levels = levels;
    [_collection reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor clearColor]];
   // [self.view setBackgroundColor:]
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[self capture:self.view]]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    
}
#pragma mark - Navigation



#pragma mark - CollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return _levels.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *level = [_levels objectAtIndex:indexPath.row];
    FPLevelCell *cell = (FPLevelCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    PDFImage *image;
    if ([[NSUserDefaults standardUserDefaults] valueForKey:[level valueForKey:@"name"]]) {
        image = [PDFImage imageNamed:[level valueForKey:@"color"]];
        cell.isFinished = YES;
    } else {
        image = [PDFImage imageNamed:[[NSUserDefaults standardUserDefaults] boolForKey:DISPLAY_INNER_BORDERS]?[level valueForKey:@"gray_lined"]:[level valueForKey:@"gray"]];
        cell.isFinished = NO;
    }
    cell.imageVeiw.image = image;
    return cell;
}
#pragma mark - CollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FPGamePlayController *controller = (FPGamePlayController *)[[UIStoryboard storyboardWithName:@"GameField" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"gameplay"];
    [controller loadLevel:(int)[indexPath row] type:FPGameTypeFirs];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    
      FPLevelCell *cell = (FPLevelCell *)[collectionView cellForItemAtIndexPath:indexPath];
      UIView *present = [[UIView alloc] initWithFrame:[[self view] convertRect:cell.frame fromView:collectionView]];
      //present.imageVeiw.image = cell.imageVeiw.image;
      //present.isFinished = cell.isFinished;
    present.frame = [[self view] convertRect:cell.frame fromView:collectionView];
    present.backgroundColor = cell.backgroundColor;
    PDFImageView *imView = [[PDFImageView alloc] initWithFrame:cell.imageVeiw.frame];
    [imView setContentMode:UIViewContentModeScaleAspectFit];
    imView.image = cell.imageVeiw.image;
    [[present layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[present layer] setBorderWidth:3];
    [present addSubview:imView];
    [[self view] addSubview:present];
#warning Переписати на збереження останього рівня
    [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:@"LastLevel"];
    [self presentViewController:controller animated:YES completion:^{
        controller.view.alpha = 0;
        controller.view.hidden = YES;
        [UIView animateWithDuration:kAnimationDuration*0.6 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [[present layer] setBorderWidth:0];
            imView.frame = controller.field.frame;
            present.frame = CGRectMake(0, 0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame));
            controller.view.alpha = 1;

        } completion:^(BOOL finished) {
            controller.view.hidden = NO;
            [controller bounceField];
            [present removeFromSuperview];

        }];
    }];
    
    
    
    
    return false;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    FPLevelCell *fpCell = (FPLevelCell *)cell;
    fpCell.isFinished = NO;
}

//- (void)colle
#pragma mark - IBAction`s
- (IBAction)menu:(id)sender
{
    CGPoint startPosition = [[[self view] layer] position];
    [_back setAlpha:0];
    [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    [[[self view] layer] setPosition:CGPointMake(startPosition.x, startPosition.y+200)];
    [[self view] setAlpha:0];
        [_parrent returnFromLevelSelection];
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}


- (void)startEnterAnimation
{
    if ([[self view] isHidden]) {
        [[self view] setAlpha:0];
        [[self view] setHidden:NO];
    }
    [_back setAlpha:0];
    CGPoint startPosition = [[[self view] layer] position];
    
     [[[self view] layer] setPosition:CGPointMake(startPosition.x, startPosition.y+200)];
    [UIView animateWithDuration:kAnimationDuration*0.6 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [[[self view] layer] setPosition:CGPointMake(startPosition.x, startPosition.y-20)];
        [[self view] setAlpha:1];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kAnimationDuration*0.6 animations:^{
            [[[self view] layer] setPosition:startPosition];
            [_back setAlpha:1];
        }];
    }];
   
}
@end
