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
#import "GamePlayViewController.h"
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
@property (nonatomic) UIImageView *imageView;
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

    
}
- (void) viewDidAppear:(BOOL)animated
{
    _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:_imageView atIndex:0];
    //[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
    [self.view setBackgroundColor:[UIColor clearColor]];

}
- (void)tick:(NSTimer *)timer
{
    UINavigationController *controller = (UINavigationController *)self.presentingViewController;
    UIImage *backg = [(StartViewController *)controller.topViewController snapshot];
    backg = [backg applyBlurWithRadius:10 tintColor:[UIColor clearColor] saturationDeltaFactor:1 maskImage:nil];
    [_imageView setImage:backg];
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:backg]];
}
- (void)screenDidChange:(NSNotification *)notification
{
    UINavigationController *controller = (UINavigationController *)self.presentingViewController;
    UIImage *backg = [(StartViewController *)controller.topViewController snapshot];
    backg = [backg applyBlurWithRadius:10 tintColor:[UIColor clearColor] saturationDeltaFactor:1 maskImage:nil];
    [_imageView setImage:backg];
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:backg]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIImage *)screenshot
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, self.view.window.screen.scale);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:NO];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    [snapshotImage applyDarkEffect];
    UIGraphicsEndImageContext();
    return snapshotImage;
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
        image = [PDFImage imageNamed:[level valueForKey:_compleetKey]];
        cell.isFinished = YES;
    } else {
        image = [PDFImage imageNamed:[level valueForKey:_notCompleet]];
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
    [controller loadLevel:(int)[indexPath row] type:_gameType];
    controller.indexPath = indexPath;
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
            controller.delegate = self;
            
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

-(void)didClose:(bool)ActivateScreen ImageScreen:(UIImage *)ImageScreenShot
{
    self.ImageScreenShot=ImageScreenShot;
    self.ScreenShotActivate=ActivateScreen;
    
}

-(void)viewWillAppear:(BOOL)animated
{
//    if (self.ScreenShotActivate) {
//        CGRect rect=CGRectMake(0, 0, CGRectGetHeight([[UIScreen mainScreen]bounds]), CGRectGetWidth([[UIScreen mainScreen]bounds]));
//        UIView *viewImage=[[UIView alloc] initWithFrame:rect];
//        viewImage.backgroundColor=[UIColor colorWithPatternImage:self.ImageScreenShot];
//        viewImage.layer.zPosition=50;
//        [self.view addSubview:viewImage];
//        NSLog(@"nvsdnb");
//    }
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
            nextController.view.layer.shadowColor = [[UIColor grayColor] CGColor];
            nextController.view.layer.shadowOffset = CGSizeMake(0, 0);
            nextController.view.layer.shadowOpacity = 1;
            nextController.view.layer.shadowRadius = 10;
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
            nextController.view.layer.shadowColor = [[UIColor grayColor] CGColor];
            nextController.view.layer.shadowOffset = CGSizeMake(0, 0);
            nextController.view.layer.shadowOpacity = 1;
            nextController.view.layer.shadowRadius = 10;
            CGAffineTransform transform = CGAffineTransformIdentity;
            //transform = CGAffineTransformScale(transform, 0.8, 0.8);
            transform = CGAffineTransformTranslate(transform, imageView.bounds.size.height, 0);
            [UIView animateWithDuration:kAnimationDuration animations:^{
                [imageView setTransform:transform];
                [[nextController view] setFrame:CGRectMake(0, 0, nextController.view.frame.size.width+10, nextController.view.frame.size.height)];
            } completion:^(BOOL finished) {
                [nextController bounceField];
                [imageView removeFromSuperview];
                nextController.view.layer.shadowOpacity = 0;
                nextController.view.layer.shadowRadius = 0;
            }];
        }];
    }
}
#pragma mark - Publick
- (void)updateColleCellAtIndexPath:(NSIndexPath *)indexPath
{
     NSLog(@"Index Path %@", indexPath);
    [self.collection reloadItemsAtIndexPaths:@[indexPath]];
}
@end
