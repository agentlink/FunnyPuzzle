//
//  FPGamePlayController.m
//  FunnyPuzzle
//
//  Created by Misha on 30.05.14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import "FPGamePlayController.h"
#import "FPLevelManager.h"
#import "FPLevelPresentationViewController.h"
#import "FPSoundManager.h"
#import "AccelerometerManager.h"
#import "FPGameManager.h"
#import "FPBonusViewController.h"
#import "Animations.h"
@interface FPElement:PDFImageView
@property (nonatomic) CGPoint winPlace;
@property (nonatomic) BOOL inPlace;

@end
@implementation FPElement

@end

@interface FPGamePlayController () <ShakeHappendDelegate>
@property (strong, nonatomic) FPLevelManager *levelManager;
@property (strong, nonatomic) NSArray *elements;
@property (weak, nonatomic) IBOutlet UILabel *levelName;

@property (strong, nonatomic) FPElement *dragingElement;
@property (assign, nonatomic) NSUInteger dragingElementIndex;
@property (assign, nonatomic) CGPoint dragingPoint;
@property (assign, nonatomic) NSUInteger elementsLeft;

@property (strong, nonatomic) NSString *compleetKey;
@property (strong, nonatomic) NSString *notCompleetKey;
@property (nonatomic) BOOL levelDone;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIAttachmentBehavior *attachmentBehavior;
@property (strong, nonatomic) UICollisionBehavior *collision;

@property (assign, nonatomic) BOOL replay;

@property (assign, nonatomic) int leftToBonus;


@property (strong, nonatomic) UISnapBehavior *basketSnap;
@property (strong, nonatomic) UISnapBehavior *levelNameSnap;
@property (strong, nonatomic) UIView *basketView;
@property (strong, nonatomic) NSMutableArray *imagesChache;

@property (strong, nonatomic) AccelerometerManager *ACManager;
@property (assign, nonatomic) float resetImage;
@property (strong, nonatomic) PDFImageView *tempImage;

@property (assign, nonatomic) BOOL loadet;
- (IBAction)next:(id)sender;
- (IBAction)prew:(id)sender;
- (IBAction)back:(id)sender;

@end

@implementation FPGamePlayController
@synthesize leftToBonus = _leftToBonus;
#pragma mark - Lifecicle
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
    [self configure];
    NSLog(@"DidLoad: %@", NSStringFromCGRect(self.field.frame));
    self.ACManager = [AccelerometerManager new];
    [self.ACManager setShakeRangeWithMinValue:0.3f MaxValue:0.9f];
    self.ACManager.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    self.levelDone = self.levelManager.levelDone;
    NSLog(@"viewDidAppear: %@", NSStringFromCGRect(self.field.frame));
}
- (void)start
{
    [self configureGameplayWithAnimationType:!self.levelDone];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.ACManager.delegate = nil;
    [self.ACManager stopShakeDetect];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)configure
{
    self.leftToBonus = (unsigned)[[NSUserDefaults standardUserDefaults] integerForKey:@"leftToBonus"];
    self.levelName.alpha = 0;
    self.next.alpha = 0;
    self.prew.alpha = 0;
    self.prew.backgroundColor = [UIColor clearColor];
    self.next.backgroundColor = [UIColor clearColor];
    self.field.layer.zPosition = -2;
    self.field.translatesAutoresizingMaskIntoConstraints = YES;
    self.back.backgroundColor = [UIColor clearColor];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.collision = [[UICollisionBehavior alloc] init];
    self.collision.translatesReferenceBoundsIntoBoundary = YES;
    [self.animator addBehavior:self.collision];
    UILongPressGestureRecognizer *nextPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(next:)];
    nextPress.minimumPressDuration = 0.2;
    UILongPressGestureRecognizer *prewPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(prew:)];
    prewPress.minimumPressDuration = 0.2;
    
}
- (void)loadLevel:(int)level type:(FPGameType)type
{
    self.levelType = type;
    switch (type) {
        case FPGameTypeFirst:
            self.compleetKey = @"colorPath";
            self.notCompleetKey = [[NSUserDefaults standardUserDefaults] boolForKey:DISPLAY_INNER_BORDERS]?@"gray_linedPath":@"grayPath";
            break;
        case FPGameTypeSecond:
            self.compleetKey = @"full";
            self.notCompleetKey = @"notFull";
            break;
        default:
            break;
    }
    self.levelManager = [FPLevelManager loadLevel:level type:type];
    self.levelNumber=level;
}

- (void)configureGameplayWithAnimationType:(FPGameplayAnimationMode)animationMode
{
    switch (animationMode) {
        case FPGameplayAnimationModeNewLevel:
            [self startAnimationForNewLevel];
            break;
        case FPGameplayAnimationModeLevelCompleet:
            [self startAnimationForCompleetLevel];
            [self.ACManager startShakeDetect];
            break;
        default:
            break;
    }
}
- (void)dealloc
{

    self.field.image = nil;
    self.elements = nil;
    [self.animator removeAllBehaviors];
    self.animator = nil;
    [self.back removeGestureRecognizer:self.back.gestureRecognizers.firstObject];
    [self.next removeGestureRecognizer:self.next.gestureRecognizers.firstObject];
    

}
#pragma mark - Custom Accsesors
- (void)setLevelNumber:(int)levelNumber
{
    _levelNumber = levelNumber;
    self.indexPath = [NSIndexPath indexPathForRow:levelNumber inSection:0];
}
- (void)setLeftToBonus:(int)leftToBonus
{
    _leftToBonus = leftToBonus;
    [[NSUserDefaults standardUserDefaults] setInteger:leftToBonus forKey:@"leftToBonus"];
}
- (int)leftToBonus
{
    _leftToBonus = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"leftToBonus"];
    return _leftToBonus;
}
- (void)setFieldFrame:(CGRect)fieldFrame
{
    self.field.frame = fieldFrame;
}
- (CGRect)fieldFrame
{
    return self.field.frame;
}
#pragma mark - Animations

- (void)startAnimationForNewLevel
{

    [self.field setBackgroundColor:[UIColor clearColor]];
    NSString *path = [[self.levelManager mcLevel] objectForKey:self.notCompleetKey];
    PDFImage *image;
    if (!self.field.image) {
         image = [FPLevelManager imageNamed:path];
    }
    image = self.field.image;

    self.fieldFrame = [self fieldFrameForPlay];
    self.field.layer.zPosition = -2;
    [self configElements];
}
- (void)startAnimationForCompleetLevel
{

    NSString *path = [[self.levelManager mcLevel] objectForKey:self.compleetKey];
    PDFImage *image;
    if (!self.field.image) {
        image = [FPLevelManager imageNamed:path];
        self.field.image = image;
    }
    self.field.frame = [self fieldFrameWin];
    self.field.backgroundColor = [UIColor clearColor];
    self.fieldFrame = [self fieldFrameWin];
    [self showLevelName:nil];
    [self showRays];
    [self loadTempImage];
}

- (void)bounceField
{
    self.tempImage.alpha = 0;
    [Animations bounceIn:self.field duration:kAnimationDuration completion:^{
        if (!self.levelDone) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.elements];
            [self bounceElements:array];
        }
        [self navigationAnimation];
        self.tempImage.alpha = 0;

    }];
}
- (void)bounceElements:(NSArray *)elements
{
    [elements enumerateObjectsUsingBlock:^(FPElement *element, NSUInteger idx, BOOL *stop) {
        if ([self.view.subviews containsObject:element]) {
            element.alpha = 1;
        } else {
            [self.view addSubview:element];
        }
        [Animations scaleIn:element duration:kAnimationDuration
                      delay:([elements indexOfObject:element]*0.09)
                      start:^{[[FPSoundManager sharedInstance] performSelector:@selector(playBlob) withObject:nil afterDelay:kAnimationDuration*0.3];}
                 completion:nil];
    }];

}
- (void)bounceElement:(FPElement *)element
{
    [UIView animateWithDuration:kAnimationDuration*0.6 animations:^{
        element.frame = CGRectMake(element.winPlace.x, element.winPlace.y, element.frame.size.width, element.frame.size.height);
        element.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kAnimationDuration*0.3 animations:^{
            element.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }];
}
- (void)animateAssinc:(NSArray *)array
{

}
- (CGRect)fieldFrameForPlay
{
    CGRect rRect = self.field.frame;
    rRect.size.height = self.view.frame.size.width-40;
    rRect.size.width = rRect.size.height;

    rRect.origin.x = CGRectGetMaxX(self.view.bounds)-(self.field.frame.size.width+40);
    rRect.origin.y = (CGRectGetMaxY(self.view.bounds)-(rRect.size.height))/2;
    return rRect;
}
- (CGRect)fieldFrameWin
{
    CGRect centerRect = self.field.frame;

    centerRect.size.height = self.fieldFrame.size.height - self.levelName.frame.size.height;
    centerRect.size.width = centerRect.size.height;
    centerRect.origin.x = CGRectGetMidX(self.view.bounds)-(centerRect.size.width/2);
    centerRect.origin.y = CGRectGetMidY(self.view.bounds)-(centerRect.size.height/2)-self.levelName.frame.size.height;
    return centerRect;
}
int binaryTodecimal(int binary) /* Function to convert binary to decimal.*/

{
    int decimal=0, i=0, rem;
    while (binary!=0)
    {
        rem = binary%10;
        binary/=10;
        decimal += rem*pow(2,i);
        ++i;
    }
    return decimal;
}
- (void)navigationAnimation //  =)
{
    NSLog(@"navigationAnimation");
    NSMutableArray *navigation = [[NSMutableArray alloc] init];
    int nextButton, prewButton;

    prewButton = self.levelNumber == 0 ? 0 : 10;
    nextButton = self.levelNumber==self.levelsCount-1 ? 0 : 1;
    FPGameplayNavigationType navigationType = binaryTodecimal(prewButton+nextButton);

    switch (navigationType) {
        case FPGameplayNavigationTypeNext:
            [navigation addObject:self.next];
            break;
        case FPGameplayNavigationTypeNextPrew:
            [navigation addObjectsFromArray:@[self.prew, self.next]];
        case FPGameplayNavigationTypePrew:
            [navigation addObject:self.prew];
        default:
            break;
    }
    if (self.replay) {
        if (self.levelDone) {
            [self bounceNavigation:navigation];
        } else {
            [self popElements:navigation remove:NO];
        }
    } else if (!self.replay && self.levelDone) {
         [self bounceNavigation:navigation];
    } else {
        [self popElements:@[self.prew, self.next] remove:NO];
    }
}
- (void)bounceNavigation:(NSArray *)navigation
{
    for (UIView *element in navigation) {
        [Animations scaleIn:element duration:kAnimationDuration completion:nil];
    }
}
- (void)popElements:(NSArray *)elements remove:(BOOL)remove
{
    for (UIView *element in elements) {
        [Animations scaleOut:element duration:kAnimationDuration completion:^{
            if (remove) {
                [element removeFromSuperview];
            }
        }];
    }
}
- (void)compleetAnimation
{
    for (int i = 0; i<[[self.levelManager mcElements] count]; i++)
    {
        [self.elements[i] removeFromSuperview];
    }

    NSString *path = [[self.levelManager mcLevel] objectForKey:self.compleetKey];
    PDFImageView *oldImage = [[PDFImageView alloc] initWithFrame:self.field.frame];
    oldImage.image = self.field.image;
    oldImage.contentMode = UIViewContentModeScaleAspectFit;
    oldImage.tag = FPTagDefaultField;
    [[self view] addSubview:oldImage];
    
    PDFImage *image = [FPLevelManager imageNamed:path];
    PDFImageView *newImage = [[PDFImageView alloc] initWithFrame:self.field.frame];
    newImage.image = [FPLevelManager imageNamed:path];
    newImage.contentMode = UIViewContentModeScaleAspectFit;
    newImage.tag = FPTagWinImageFiled;
    [[self view] addSubview:newImage];

    CGAffineTransform transform = newImage.transform;
    newImage.layer.zPosition = MAXFLOAT;
    newImage.alpha = 0;
    self.field.alpha = 0;
    [UIView animateWithDuration:kAnimationDuration*0.6 animations:^{
        oldImage.transform = CGAffineTransformMakeScale(1.2, 1.2);
        newImage.alpha = 1;
        oldImage.alpha = 0;
        newImage.transform = CGAffineTransformMakeScale(1.2, 1.2);
        [self showRays];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            [oldImage removeFromSuperview];
            newImage.transform = CGAffineTransformMakeScale(0.9, 0.9);
            newImage.alpha = 1;
            newImage.transform = transform;
        } completion:^(BOOL finished) {
            self.field.alpha = 1;
            [self.field removeFromSuperview];
            self.field = newImage;
            [oldImage removeFromSuperview];
            [self showBasket:nil];
            [self navigationAnimation];
        }];
    }];
    self.field.image = image;
}

- (void)showLevelName:(void (^)())completion
{
    [[FPSoundManager sharedInstance] playSound:self.levelManager.soundURL];
    [self.levelName setText:[FPLevelManager gameLocalizedStringForKey:self.levelManager.levelName]];
    [self.levelName sizeToFit];
    CGPoint snapPoint = CGPointMake(CGRectGetMidX([self.view bounds]), CGRectGetMaxY([self.view bounds])-self.levelName.bounds.size.height);
    if (self.levelNameSnap) {
        [self.animator removeBehavior:self.levelNameSnap];
    }
    self.levelNameSnap = [[UISnapBehavior alloc] initWithItem:[self levelName] snapToPoint:snapPoint];
    [self.levelName setAlpha:1];
    [self.animator addBehavior:self.levelNameSnap];
}
- (void)showRays
{
    PDFImage *star = [PDFImage imageNamed:@"Levels/star"];
    CGRect frame = CGRectMake((-star.size.width/2)+CGRectGetMidX(self.field.frame), (-star.size.height/2)+CGRectGetMidY(self.field.frame), star.size.width, star.size.height);
    PDFImageView *imageView = [[PDFImageView alloc] initWithFrame:frame];
    imageView.tag = FPTagRay;
    imageView.image = star;
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.fromValue = @0;
    rotate.toValue = [NSNumber numberWithFloat:M_PI*2];
    rotate.duration = 10;
    rotate.repeatCount = INFINITY;
    [imageView.layer addAnimation:rotate forKey:@"rotation"];
    CGAffineTransform transform = imageView.transform;
    imageView.transform = CGAffineTransformMakeScale(0, 0);
    imageView.layer.zPosition = -5;
    [self.view insertSubview:imageView atIndex:0];
    [UIView animateWithDuration:kAnimationDuration animations:^{
        imageView.transform = transform;
    } completion:^(BOOL finished) {

    }];
}

- (void) showBasket:(void (^)())completion
{
    if (self.replay) {
        [self moveFieldToCenter:nil];
        return;
    }
    float xShift = 0.5;
    self.basketView = [[UIView alloc] initWithFrame:CGRectMake(-CGRectGetMidX(self.view.bounds)*0.4, CGRectGetMidX(self.view.bounds)*0.3, 120, 120)];
    UIImageView *imageVeiw = [[UIImageView alloc] initWithFrame:self.basketView.bounds];
    [imageVeiw setImage:[UIImage imageNamed:@"basketself.fullself.img"]];
    [self.basketView addSubview:imageVeiw];
    self.basketView.tag=99;
    [self.view addSubview:self.basketView];
    UIImageView *candyView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"candyself.orange"]];
    candyView.tag=98;
    candyView.frame = CGRectMake(CGRectGetMidX(self.view.bounds), (CGRectGetMidX(self.view.bounds)*0.3)-70, 35, 35);
    [self.view addSubview:candyView];
    self.basketSnap = [[UISnapBehavior alloc] initWithItem:self.basketView snapToPoint:CGPointMake(CGRectGetMidX(self.view.bounds)*xShift, CGRectGetMidY(self.view.bounds))];
    self.basketSnap.damping = 0.3;
    [self.animator addBehavior:self.basketSnap];
    UISnapBehavior *candySnap = [[UISnapBehavior alloc] initWithItem:candyView snapToPoint:CGPointMake(CGRectGetMidX(self.view.bounds)*xShift, CGRectGetMidY(self.basketView.frame)-70)];
    candySnap.damping = 0.4;

    [self.animator addBehavior:candySnap];
    [UIView animateWithDuration:kAnimationDuration*2 animations:^{
        candyView.transform = CGAffineTransformMakeRotation(M_PI);
    } completion:^(BOOL finished) {
        self.basketView.layer.zPosition=2;
        candyView.layer.zPosition=0;
        [self.animator removeBehavior:candySnap];

        [UIView animateWithDuration:kAnimationDuration*1.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGAffineTransform transform = candyView.transform;
            transform = CGAffineTransformRotate(transform, M_PI);
            transform = CGAffineTransformTranslate(transform, 0, -95);
            candyView.transform = transform;
        } completion:^(BOOL compleat){
            //[[FPSoundManager sharedInstance] playPrise];
            candyView.frame = [self.view convertRect:candyView.frame toView:self.basketView];
            [self.basketView insertSubview:candyView atIndex:0];
            [self.animator removeBehavior:self.basketSnap];
            [self.animator removeBehavior:candySnap];
            [self performSelector:@selector(moveFieldToCenter:) withObject:nil afterDelay:kAnimationDuration];
            if (completion) {
                completion();
            }
        }];
    }];
}

- (void)moveFieldToCenter:(void(^)())completion
{
    PDFImageView *imageView = [[PDFImageView alloc] initWithFrame:self.field.frame];
    imageView.image = self.field.image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    //[self.view addSubview:imageView];
    //self.field.alpha = 0;
    CGRect centerRect = [self fieldFrameWin];

    PDFImageView *star = (PDFImageView *)[self.view viewWithTag:FPTagRay];
    CGRect frame = CGRectMake((-star.image.size.width/2)+CGRectGetMidX(centerRect), (-star.image.size.height/2)+CGRectGetMidY(centerRect), star.image.size.width, star.image.size.height);
    [self showLevelName:nil];
    [UIView animateWithDuration:kAnimationDuration*2 animations:^{
        self.field.frame = centerRect;
        star.frame = frame;
        self.basketView.transform = CGAffineTransformMakeTranslation(-(self.basketView.frame.origin.x+self.basketView.frame.size.width), 0);
    } completion:^(BOOL finished) {
        [self.basketView removeFromSuperview];
        [self loadTempImage];
    }];
}

#pragma mark - Publick
- (UIImage *)screenshot
{
    if ([self presentedViewController])
    {
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, self.view.window.screen.scale);
        [self.presentedViewController.view drawViewHierarchyInRect:self.presentedViewController.view.bounds afterScreenUpdates:NO];
        UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return snapshotImage;
    }
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, self.view.window.screen.scale);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:NO];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}
#pragma mark - Private
- (void)configElements
{
    NSMutableArray *elements = [NSMutableArray new];
    self.elementsLeft =  self.levelType==FPGameTypeFirst? [[self.levelManager mcElements] count] : 1;
    for (int i = 0; i<[[self.levelManager mcElements] count]; i++) {
        NSString *path = [[[self.levelManager mcElements] objectAtIndex:i] valueForKey:@"path"];
        PDFImage *image = [FPLevelManager imageNamed:path];
        FPElement *imageView = [[FPElement alloc] initWithFrame:[self adaptRectSize:image.size]];
        imageView.layer.zPosition = i;
        imageView.tag = i;
        imageView.image = image;
        [elements addObject:imageView];
        [imageView setAlpha:0];
        imageView.winPlace = [self getAdaptedPoint:[[[[self.levelManager mcElements] objectAtIndex:i] valueForKey:@"nativePoint"] CGPointValue]];
        imageView = [self newFrame:imageView];
        imageView.clipsToBounds = NO;

    }
    self.elements = [NSArray arrayWithArray:elements];
    //[self bounceElements:self.elements isInSuperView:NO];
}
- (CGRect)adaptRectFromRect:(CGRect)rect
{
    double multiplayer = self.fieldFrame.size.width/self.field.image.size.width;
    return CGRectMake(rect.origin.x*multiplayer, rect.origin.y*multiplayer, rect.size.width*multiplayer, rect.size.height*multiplayer);
}
- (FPElement *)newFrame:(FPElement *)element
{
    CGSize elementSize = element.frame.size;
    CGPoint winPlace = element.winPlace;
    if (elementSize.width<elementSize.height && elementSize.width<50) {
        int delta = 50 - elementSize.width;
        elementSize.width += delta;
        winPlace.x = element.winPlace.x-(delta/2);
    } else if (elementSize.height<elementSize.width && elementSize.height<50) {
        int delta = 50 - elementSize.height;
        elementSize.height += delta;
       winPlace.y = element.winPlace.y-(delta/2);
    } else {
        return element;
    }
    element.frame = CGRectMake(element.frame.origin.x, element.frame.origin.y, elementSize.width, elementSize.height);
    element.winPlace = winPlace;
    return element;
}
- (void)checkElement:(UIView*)view
{
    CGRect frame = view.frame;
    CGRect newFrame = frame;
    CGRect viewFrame = self.view.frame;
    if (CGRectGetMaxX(frame)>CGRectGetHeight(viewFrame))
    {
        newFrame.origin.x = CGRectGetHeight(viewFrame)-CGRectGetWidth(frame);
    } else if (CGRectGetMinX(frame)<0) {
        newFrame.origin.x = 0;
    }
    if (CGRectGetMaxY(frame)>CGRectGetWidth(viewFrame)) {
        newFrame.origin.y = CGRectGetWidth(viewFrame)- CGRectGetHeight(frame);
    } else if (CGRectGetMinY(frame)<0) {
        newFrame.origin.y = 0;
    }
    if (!CGRectEqualToRect(newFrame, frame)) {
        [Animations move:view to:newFrame.origin duration:kAnimationDuration completion:nil];
    }
}
- (CGRect)adaptRectSize:(CGSize)size
{
    float multiplier = 1;
    if (self.field.image.size.height>self.field.image.size.width)
    {
        multiplier = self.fieldFrame.size.height/self.field.image.size.height;
    } else {
        multiplier = self.fieldFrame.size.width/self.field.image.size.width;
    }
    size.width = size.width*multiplier;
    size.height = size.height*multiplier;
    double maxX, maxY;
    maxX = CGRectGetMinX(self.fieldFrame)-size.width;
    maxY = CGRectGetHeight(self.view.bounds)-size.height-self.back.frame.size.height;//-40;
    double x = maxX>0 ? arc4random_uniform(maxX) : 0;
    double y = arc4random_uniform(maxY)+self.back.frame.size.height;
    return CGRectMake(x, y, size.width, size.height);
}
- (CGPoint)getAdaptedPoint:(CGPoint)point
{
    float multiplier = 1;
    float heightShift = 0;
    float widthShift = 0;
    if (self.field.image.size.height>self.field.image.size.width)
    {
        multiplier = self.fieldFrame.size.height/self.field.image.size.height;
        widthShift = (self.fieldFrame.size.width-self.field.image.size.width*multiplier)/2;
    } else {
        multiplier = self.fieldFrame.size.width/self.field.image.size.width;
        heightShift = (self.fieldFrame.size.height-self.field.image.size.height*multiplier)/2;
    }
    return CGPointMake((point.x*multiplier)+self.field.frame.origin.x+widthShift, (point.y*multiplier)+self.field.frame.origin.y+heightShift);
}
- (void)levelCompleet
{
    if (!self.replay) {
        [FPLevelManager saveLevel:self.levelNumber gameType:self.levelType];
        [FPGameManager sharedInstance].candiesCount++;
        [[NSUserDefaults standardUserDefaults] setInteger:self.levelNumber forKey:@"lastLevel"];
        self.leftToBonus++;
        //self.levelDone = YES;
    }
    self.levelDone = YES;
    [self compleetAnimation];
    [self.ACManager startShakeDetect];
}
- (void)restartLevel
{

    [[self.view viewWithTag:FPTagRay] removeFromSuperview];
    [self loadLevel:self.levelNumber type:self.levelType];
    self.replay = YES;
    self.levelDone = NO;
    self.field.alpha = 0;
    self.field.image = self.tempImage.image;
    self.fieldFrame = [self fieldFrameForPlay];
    [self configElements];
    [UIView animateWithDuration:kAnimationDuration*0.5 animations:^{
        self.tempImage.frame = self.fieldFrame;
    } completion:^(BOOL finished) {
        [self.tempImage removeFromSuperview];
        self.field.alpha = 1;
        [self bounceField];
        //NSMutableArray *array = [NSMutableArray arrayWithArray:self.elements];
        //[self bounceElements:array];
        self.field.layer.zPosition = -2;
    }];

    CGRect levelNameFrame = self.levelName.frame;
    [self.animator removeBehavior:self.levelNameSnap];
    self.levelNameSnap = [[UISnapBehavior alloc] initWithItem:self.levelName snapToPoint:CGPointMake(CGRectGetMidX(levelNameFrame), CGRectGetMaxY(levelNameFrame)*2)];
    [self.animator addBehavior:self.levelNameSnap];
}
- (void)loadTempImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PDFImage *image = [FPLevelManager imageNamed:[[self.levelManager mcLevel] objectForKey:self.notCompleetKey]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self.tempImage) {
                self.tempImage = [[PDFImageView alloc] initWithFrame:self.fieldFrame];
                self.tempImage.contentMode = UIViewContentModeScaleAspectFit;

            }
            self.tempImage.image = image;
            self.tempImage.layer.zPosition = -2;
            self.tempImage.frame = self.fieldFrame;
            self.tempImage.alpha = 1;
            if (![self.view.subviews containsObject:self.tempImage]) {
                [self.view insertSubview:self.tempImage atIndex:0];
            }
        });
    });
}
#pragma mark - IBAction

- (IBAction)next:(id)sender
{
    self.next.userInteractionEnabled = NO;
    if (self.leftToBonus >=3) {
        FPBonusViewController *bonusViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BonusLevel"];
        bonusViewController.completion = ^{
            [self next:self];
        };
        [self presentViewController:bonusViewController animated:YES completion:^{
            self.leftToBonus = 0;
        }];
    } else {
        [[self updateCollectionView] nextLevel];
    }
}

- (IBAction)prew:(id)sender
{
    self.next.userInteractionEnabled = NO;
    [[self updateCollectionView] previousLevel];

}
- (IBAction)back:(id)sender
{
    self.next.userInteractionEnabled = NO;
    if ([self navigationController]) {
        [[self navigationController] popViewControllerAnimated:YES];
    } else if ([self presentingViewController])
    {
        [[self updateCollectionView] closeGameplay];
    }
}
//
- (FPLevelPresentationViewController *)updateCollectionView
{
    FPLevelPresentationViewController *presentationController = (FPLevelPresentationViewController *)[self presentingViewController];
    [presentationController updateColleCellAtIndexPath:self.indexPath];
    return presentationController;
}

#pragma mark - Gameplay Methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch1 = [touches anyObject];
    CGPoint touchLocation = [touch1 locationInView:self.view];
    self.dragingElement = nil;
    self.dragingPoint = CGPointZero;
    NSMutableArray *tapElements = [[NSMutableArray alloc] init];
    for (FPElement *element in self.elements) {
        if (CGRectContainsPoint(element.frame, touchLocation) && ![self zoneIsTransparent:[touch1 locationInView:element] inView:element] && !element.inPlace) {
            [tapElements addObject:element];
        }
    }
    
    [tapElements sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSNumber *z1 = [NSNumber numberWithFloat:[[(UIView*)obj1 layer] zPosition]];
        NSNumber *z2 = [NSNumber numberWithFloat:[[(UIView*)obj2 layer] zPosition]];
        return [z2 compare:z1];
        
    }];
    if (tapElements.count>1) {
        
        if ([[[tapElements firstObject] layer] zPosition]>=[tapElements count]-1) {
            FPElement *element = [tapElements firstObject];
            self.dragingElement = element;
            self.dragingPoint = CGPointMake([touch1 locationInView:element].x/element.frame.size.width, [touch1 locationInView:element].y/element.frame.size.height);
        }
    } else if (tapElements.count == 1) {
        FPElement *element = [tapElements firstObject];
        element.layer.zPosition = [self.elements count]-1;
        NSMutableArray *array = [NSMutableArray arrayWithArray:[self.elements sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSNumber *z1 = [NSNumber numberWithFloat:[[(UIView *)obj1 layer] zPosition]];
            NSNumber *z2 = [NSNumber numberWithFloat:[[(UIView *)obj2 layer] zPosition]];
            return [z1 compare:z2] ;
            
        }]];
        [array removeObject:element];
        for (int i = 0; i<[array count]; i++) {
            if (!element.inPlace)
            [[[array objectAtIndex:i] layer] setZPosition:i];
        }
        self.dragingElement = element;
        self.dragingPoint = CGPointMake([touch1 locationInView:element].x/element.frame.size.width,
                                    [touch1 locationInView:element].y/element.frame.size.height);
    }
    if (!self.elementsLeft && CGRectContainsPoint(self.field.frame, touchLocation) && ![self pointIsTransparent:[touch1 locationInView:[touch1 view]] inView:[touch1 view]]) {
        [[FPSoundManager sharedInstance] playSound:self.levelManager.soundURL];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch1 = [touches anyObject];
    CGPoint touchLocation = [touch1 locationInView:self.view];
    if (self.dragingElement.inPlace) {
        
    } else {
        self.dragingElement.layer.anchorPoint = self.dragingPoint;
        self.dragingElement.layer.position = touchLocation;
        [self checkForRightPlace:self.dragingElementIndex];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.dragingElement) {
        [self checkElement:self.dragingElement];
    }
}
- (void)checkForRightPlace:(NSUInteger)index
{
    CGPoint rightPoint = self.dragingElement.winPlace;
    CGPoint currentPoint = self.dragingElement.frame.origin;
    BOOL xPosition = 20>=abs(rightPoint.x-currentPoint.x);
    BOOL yPosition = 20>=abs(rightPoint.y-currentPoint.y);
    
    if (xPosition&&yPosition&&self.dragingElement) {
        self.dragingElement.inPlace = YES;
        self.dragingElement.layer.zPosition = -1;
        [self bounceElement:self.dragingElement];
        self.elementsLeft--;
        if (self.elementsLeft<=0) {
            [self levelCompleet];
        }
    }
}


- (BOOL) pointIsTransparent:(CGPoint)point inView:(UIView *)view
{
    unsigned char pixel[4] = {0};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [view.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    return CGColorGetAlpha([color CGColor])==0;
}
- (BOOL) zoneIsTransparent:(CGPoint)point inView:(UIView *)view
{
    if (![self pointIsTransparent:point inView:view])
    {
        return NO;
    }
    int pixels = 40;
    //pixel count: pixels*pixels*4
    unsigned char pixel[6400] = {0};

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    CGContextRef context = CGBitmapContextCreate(pixel, pixels, pixels, 8, pixels*4, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);


    [view.layer renderInContext:context];

    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);

    for (int i = 3; i<1600; i+=4) {
        if ((pixel[i]/255)>=1) {
            return NO;
        }
    }
    return YES;
}

- (void) resetImageProgress
{
    [self restartLevel];
}

#pragma mark - Accelerometer Delegate

- (void) iPhoneDidShaked
{
    self.resetImage = self.resetImage > 0 ? self.resetImage-0.1 : self.field.alpha;
    NSLog(@"%f",self.resetImage);
    if (self.resetImage < 0) {
        [self.ACManager stopShakeDetect];
        [self resetImageProgress];
        self.resetImage = 1;
    } else {
        self.field.alpha = self.resetImage;
        self.tempImage.alpha = 1-self.resetImage;
        [self performSelector:@selector(checkTransperty:) withObject:@(self.resetImage) afterDelay:0.3];
    }
}
- (void)checkTransperty:(NSNumber *)transperty
{
    if (([transperty floatValue] == self.resetImage) && self.resetImage <= 1) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animation.fromValue = @(self.field.layer.opacity);
        animation.toValue = @(self.field.layer.opacity+0.1);
        animation.duration = 0.3;

        CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacity.fromValue = @(self.tempImage.layer.opacity);
        opacity.toValue = @(1-self.field.layer.opacity);
        opacity.duration = 0.3;

        [self.tempImage.layer addAnimation:opacity forKey:@"opacity'"];
        [self.field.layer addAnimation:animation forKey:@"animation"];
        //self.field.layer.opacity = self.field.layer.opacity+0.1;
        self.tempImage.layer.opacity = (1-self.field.layer.opacity);
        self.field.alpha +=0.1;
        self.resetImage +=0.1;
        [self performSelector:@selector(checkTransperty:) withObject:@(self.resetImage) afterDelay:0.3];
    }
}
@end
