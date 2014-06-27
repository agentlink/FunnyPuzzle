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
#import "GameModel.h"
#import "FPGamePlayController.h"
#import "UIImage+ImageEffects.h"
#import "JMIBlur.h"

@interface FPLevelPresentationViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) IBOutlet UIButton *back;
@property (nonatomic, weak) IBOutlet UICollectionView *collection;
@property (nonatomic, strong) NSArray *levels;
@property (nonatomic, weak) IBOutlet FPGamePlayController *controller;
@property (nonatomic) NSString *compleetKey;
@property (nonatomic) NSString *notCompleet;
@property (assign, nonatomic) int leftToBonus;

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
    switch (gameType) {
        case FPGameTypeFirst:
            _compleetKey = @"color";
            _notCompleet = [[NSUserDefaults standardUserDefaults] boolForKey:DISPLAY_INNER_BORDERS]?@"gray_lined":@"gray";
            break;
        case FPGameTypeSecond:
            _compleetKey = @"full";
            _notCompleet = @"notFull";
            break;
        default:
            break;
    }
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
    self.view.backgroundColor = [UIColor clearColor];
    
}
- (void) viewDidAppear:(BOOL)animated
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    _levels = nil;
}
#pragma mark - Navigation
//int binary_decimal(int binary) /* Function to convert binary to decimal.*/
//
//{
//    int decimal=0, i=0, rem;
//    while (binary!=0)
//    {
//        rem = binary%10;
//        binary/=10;
//        decimal += rem*pow(2,i);
//        ++i;
//    }
//    return decimal;
//}
//- (FPGameplayNavigationType)gameNavigationType:(NSDictionary *)level level:(int)levelNumber
//{
//    FPGameplayNavigationType navigationType;
//    int nextButton, prewButton;
//
//    prewButton = levelNumber==0 ? 0 : level[@"compleet"]? 10 : 0;
//    nextButton = levelNumber==self.levels.count-1 ? 0 : level[@"compleet"]? 1 : 0;
//    navigationType = binary_decimal(prewButton+nextButton);
//
//    return navigationType;
//}


#pragma mark - CollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return _levels.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *level = [_levels objectAtIndex:indexPath.row];
    FPLevelCell *cell = (FPLevelCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.isLocked = NO;
    BOOL prewLevelDone = true;
    if (indexPath.row!=0) {
        prewLevelDone = [[[_levels objectAtIndex:indexPath.row-1] valueForKey:@"compleet"] boolValue];
    }
    PDFImage *image;
    if ([[level valueForKey:@"compleet"] boolValue]) {
        image = [PDFImage imageNamed:[level valueForKey:_compleetKey]];
        cell.name.text = [FPLevelManager gameLocalizedStringForKey:[level valueForKey:@"name"]];//NSLocalizedString([level valueForKey:@"name"], nil);
        cell.isFinished = YES;
        cell.imageVeiw.image = image;
    } else if (prewLevelDone) {
        image = [PDFImage imageNamed:[level valueForKey:_notCompleet]];
        cell.isFinished = NO;
        cell.imageVeiw.image = image;
    } else {
        cell.isLocked = YES;
    }
    return cell;
}
#pragma mark - CollectionView Delegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FPLevelCell *cell = (FPLevelCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.isLocked)
        return NO;
    FPGamePlayController *controller = (FPGamePlayController *)[[UIStoryboard storyboardWithName:@"GameField" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"gameplay"];

    [controller loadLevel:(int)[indexPath row] type:_gameType];
    controller.indexPath = indexPath;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;



    UIView *present = [[UIView alloc] initWithFrame:[[self view] convertRect:cell.frame fromView:collectionView]];
    present.frame = [[self view] convertRect:cell.frame fromView:collectionView];
    present.backgroundColor = cell.backgroundColor;
    PDFImageView *imView = [[PDFImageView alloc] initWithFrame:cell.imageVeiw.frame];
    [imView setContentMode:UIViewContentModeScaleAspectFit];
    imView.image = cell.imageVeiw.image;
    [[present layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[present layer] setBorderWidth:3];
    [present addSubview:imView];

    [[self view] addSubview:present];

    [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:@"LastLevel"];

    [self presentViewController:controller animated:YES completion:^{
        controller.view.alpha = 0;
        controller.view.hidden = YES;
        controller.levelsCount = (unsigned)self.levels.count;
        [UIView animateWithDuration:kAnimationDuration*0.6 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [[present layer] setBorderWidth:0];
            imView.frame = controller.fieldFrame;
            present.frame = CGRectMake(0, 0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame));
            controller.view.alpha = 1;

        } completion:^(BOOL finished) {
            controller.view.hidden = NO;
            [controller bounceField];
            [present removeFromSuperview];

        }];
    }];
    
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    FPLevelCell *fpCell = (FPLevelCell *)cell;
    fpCell.isFinished = NO;
}

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
        [self dismissViewControllerAnimated:NO completion:nil];
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

-(void)viewWillAppear:(BOOL)animated
{
}

#pragma mark - Levels Navigation
- (void)nextLevel
{
    
    FPGamePlayController *currentGamePlay = (FPGamePlayController *)[self presentedViewController];
    FPGamePlayController *nextController = [[UIStoryboard storyboardWithName:@"GameField" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"gameplay"];


    int currentLevelNumber = currentGamePlay.levelNumber;

    if (currentLevelNumber+1<self.levels.count) {
        currentLevelNumber+=1;
        [nextController loadLevel:currentLevelNumber type:[self gameType]];
        UIImage *screenshot = [currentGamePlay screenshot];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:screenshot];
        [self.view addSubview:imageView];
        [self dismissViewControllerAnimated:NO completion:nil];
        [self presentViewController:nextController animated:NO completion:^{
            [[nextController view] setFrame:CGRectMake(0, nextController.view.frame.size.height+10, nextController.view.frame.size.width, nextController.view.frame.size.height)];
//            nextController.view.layer.shadowColor = [[UIColor grayColor] CGColor];
//            nextController.view.layer.shadowOffset = CGSizeMake(0, 0);
//            nextController.view.layer.shadowOpacity = 1;
//            nextController.view.layer.shadowRadius = 10;
            nextController.levelsCount = (unsigned)self.levels.count;
            CGAffineTransform transform = CGAffineTransformIdentity;
            transform = CGAffineTransformTranslate(transform, -imageView.bounds.size.width*0.8, 0);
            [UIView animateWithDuration:kAnimationDuration animations:^{
                [imageView setTransform:transform];
                [[nextController view] setFrame:CGRectMake(0, 0, nextController.view.frame.size.width, nextController.view.frame.size.height)];
            } completion:^(BOOL finished) {
                [nextController bounceField];
                [imageView removeFromSuperview];
                nextController.view.layer.shadowOpacity = 0;
                nextController.view.layer.shadowRadius = 0;
            }];
        }];
    }
    [self.collection reloadItemsAtIndexPaths:[self.collection indexPathsForVisibleItems]];
}
- (void)previousLevel
{
    FPGamePlayController *currentGamePlay = (FPGamePlayController *)[self presentedViewController];
    FPGamePlayController *nextController = [[UIStoryboard storyboardWithName:@"GameField" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"gameplay"];
    int currentLevelNumber = currentGamePlay.levelNumber;


    if (currentLevelNumber-1>=0) {
        currentLevelNumber-=1;
        [nextController loadLevel:currentLevelNumber type:[self gameType]];
        UIImage *screenshot = [currentGamePlay screenshot];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:screenshot];
        [self.view addSubview:imageView];
        [self dismissViewControllerAnimated:NO completion:nil];
        [self presentViewController:nextController animated:NO completion:^{
            [[nextController view] setFrame:CGRectMake(0, -nextController.view.frame.size.height-10, nextController.view.frame.size.width, nextController.view.frame.size.height)];
//            nextController.view.layer.shadowColor = [[UIColor grayColor] CGColor];
//            nextController.view.layer.shadowOffset = CGSizeMake(0, 0);
//            nextController.view.layer.shadowOpacity = 1;
//            nextController.view.layer.shadowRadius = 10;
            nextController.levelsCount = (unsigned)self.levels.count;
            CGAffineTransform transform = CGAffineTransformIdentity;
            
            transform = CGAffineTransformTranslate(transform, imageView.bounds.size.height, 0);
            [UIView animateWithDuration:kAnimationDuration animations:^{
                [imageView setTransform:transform];
                [[nextController view] setFrame:CGRectMake(0, 0, nextController.view.frame.size.width, nextController.view.frame.size.height)];
            } completion:^(BOOL finished) {
                [imageView removeFromSuperview];
                [nextController bounceField];
                nextController.view.layer.shadowOpacity = 0;
                nextController.view.layer.shadowRadius = 0;
            }];
        }];
    }
    [self.collection reloadItemsAtIndexPaths:[self.collection indexPathsForVisibleItems]];
}
- (void)closeGameplay
{

    FPGamePlayController *currentGamePlay = (FPGamePlayController *)[self presentedViewController];

    FPLevelCell *cell = (FPLevelCell *)[self.collection cellForItemAtIndexPath:currentGamePlay.indexPath];

    UIView *present = [[UIView alloc] initWithFrame:self.view.bounds];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[currentGamePlay screenshot]];
    PDFImageView *field = currentGamePlay.field;
    [present addSubview:field];
    [present addSubview:imageView];
    present.backgroundColor = currentGamePlay.view.backgroundColor;
    currentGamePlay.view.alpha = 0;
    [self.view addSubview:present];
    [UIView animateWithDuration:kAnimationDuration animations:^{
        present.frame = [[self view] convertRect:cell.frame fromView:self.collection];
        field.frame = cell.imageVeiw.frame;
        imageView.frame = CGRectMake(0, 0, CGRectGetWidth(present.frame), CGRectGetHeight(present.frame));
        imageView.alpha = 0;
    } completion:^(BOOL finished) {
        [present removeFromSuperview];
        [self dismissViewControllerAnimated:NO completion:nil];
    }];


}
- (void)scrollCollectionToIndexPath:(NSIndexPath *)indexPath animate:(BOOL)animate
{
    UICollectionViewScrollPosition scrollPosition = UICollectionViewScrollPositionRight;
    int itemNumber =(int)indexPath.row;
    if (!(itemNumber%2)) {
        if (!((itemNumber/2)%2)) {
            scrollPosition = UICollectionViewScrollPositionLeft;
        }
    } else if (!((itemNumber/2)%2)) {
        scrollPosition = UICollectionViewScrollPositionLeft;
    }

    [self.collection scrollToItemAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animate];
}
#pragma mark - Publick
- (void)updateColleCellAtIndexPath:(NSIndexPath *)indexPath
{

    [self scrollCollectionToIndexPath:indexPath animate:NO];
    NSArray *indexPaths;
    _levels = [FPLevelManager allLevels:_gameType];
    if (indexPath.row < _levels.count-1) {
        indexPaths = @[indexPath, [NSIndexPath indexPathForItem:indexPath.row+1 inSection:0]];
    } else {
        indexPaths = @[indexPath];
    }
    [self.collection reloadItemsAtIndexPaths:indexPaths];
}
@end
