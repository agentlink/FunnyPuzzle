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

@interface FPElement:PDFImageView
@property (nonatomic) CGPoint winPlace;
@property (nonatomic) BOOL inPlace;

@end
@implementation FPElement

@end

@interface FPGamePlayController () <ShakeHappendDelegate>
@property (nonatomic) FPLevelManager *levelManager;
@property (nonatomic) NSArray *elements;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *fieldRightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *fieldHeightConstraint;
@property (nonatomic, weak) IBOutlet UILabel *levelName;
@property (nonatomic) FPElement *dragingElement;
@property (nonatomic) NSUInteger dragingElementIndex;
@property (nonatomic) CGPoint dragingPoint;
@property (nonatomic) CGPoint dragingWinPoint;
@property (nonatomic) int levelsCount;
@property (nonatomic) NSUInteger elementsLeft;
@property (nonatomic) FPGameType levelType;
@property (nonatomic) NSString *compleetKey;
@property (nonatomic) NSString *notCompleetKey;
@property (nonatomic) BOOL levelDone;

@property (nonatomic) UIDynamicAnimator *animator;
@property (nonatomic) UIAttachmentBehavior *attachmentBehavior;
@property (nonatomic) UICollisionBehavior *collision;


@property (nonatomic) UISnapBehavior *basketSnap;
@property (nonatomic) UIView *basketView;

@property (nonatomic) AccelerometerManager *ACManager;
@property (nonatomic) int resetImage;


- (IBAction)next:(id)sender;
- (IBAction)prew:(id)sender;
- (IBAction)back:(id)sender;
@end

@implementation FPGamePlayController
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
    // Do any additional setup after loading the view
    //[self.view setBackgroundColor:[UIColor clearColor]];
    _levelName.alpha = 0;
    _back.alpha = 0;
    _next.alpha = 0;
    _prew.alpha = 0;
    _field.layer.zPosition = -2;
    _next.backgroundColor = [UIColor clearColor];
    _prew.backgroundColor = [UIColor clearColor];
    _back.backgroundColor = [UIColor clearColor];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.collision = [[UICollisionBehavior alloc] init];
    self.collision.translatesReferenceBoundsIntoBoundary = YES;
    [self.animator addBehavior:self.collision];
}

- (void)viewDidAppear:(BOOL)animated
{
    _levelDone = [[NSUserDefaults standardUserDefaults] boolForKey:[FPLevelManager gameLocalizedStringForKey:_levelManager.levelName]];
    [self configureGameplayWithAnimationType:!_levelDone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadLevel:(int)level type:(FPGameType)type
{
    _levelType = type;
    switch (type) {
        case FPGameTypeFirst:
            _compleetKey = @"colorPath";
            _notCompleetKey = [[NSUserDefaults standardUserDefaults] boolForKey:DISPLAY_INNER_BORDERS]?@"gray_linedPath":@"grayPath";
            break;
        case FPGameTypeSecond:
            _compleetKey = @"full";
            _notCompleetKey = @"notFull";
            break;
        default:
            break;
    }
    _levelManager = [FPLevelManager loadLevel:level type:type];
    self.levelsCount=40;
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
//            self.ACManager = [AccelerometerManager new];
//            [self.ACManager setShakeRangeWithMinValue:.75 MaxValue:.8];
//            self.ACManager.delegate = self;
//            [self.ACManager startShakeDetect];
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
}
#pragma mark - Custom Accsesors

- (void)setLevelNumber:(int)levelNumber
{
    _levelNumber = levelNumber;
    _indexPath = [NSIndexPath indexPathForRow:levelNumber inSection:0];
}
#pragma mark - Animations

- (void)startAnimationForNewLevel
{
    [_field setBackgroundColor:[UIColor clearColor]];
    NSString *path = [[_levelManager mcLevel] objectForKey:_notCompleetKey];
    PDFImage *image = [FPLevelManager imageNamed:path];


    _field.hidden = YES;
    PDFImageView *imageView = [[PDFImageView alloc] initWithFrame:_field.frame];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;

    CGRect rRect = _field.frame;
    rRect.size.height = _field.frame.size.width;
    rRect.origin.x = CGRectGetMaxX(self.view.bounds)-(_field.frame.size.width+40);
    rRect.origin.y = (CGRectGetMaxY(self.view.bounds)-(rRect.size.height))/2;
    self.fieldFrame = rRect;
    imageView.frame = rRect;

    [self.view addSubview:imageView];
    _field = imageView;
    _field.layer.zPosition = -5;
    [self configElements];
}
- (void)startAnimationForCompleetLevel
{
    NSString *path = [[_levelManager mcLevel] objectForKey:_compleetKey];
    PDFImage *image = [FPLevelManager imageNamed:path];
    _field.hidden = YES;
    PDFImageView *imageView = [[PDFImageView alloc] initWithFrame:_field.frame];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;
    CGRect centerRect = _field.frame;
    centerRect.size.height = _field.frame.size.height - _levelName.frame.size.height;
    centerRect.origin.x = CGRectGetMidX(self.view.bounds)-(_field.frame.size.width/2);
    centerRect.origin.y = CGRectGetMidY(self.view.bounds)-(centerRect.size.height/2)-_levelName.frame.size.height;
    self.fieldFrame = centerRect;
    [self showLevelName:nil];
    imageView.frame = centerRect;
    [self.view addSubview:imageView];
    _field = imageView;
    [self showRays];
}

- (void)bounceField
{
    CATransform3D transform = [[_field layer] transform];
    [UIView animateWithDuration:kAnimationDuration*0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_field.layer setTransform:CATransform3DMakeScale(1.2, 1.2, 1.2)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kAnimationDuration*0.6 animations:^{
            [_field.layer setTransform:transform];
            if (!_levelDone) {
                NSMutableArray *array = [NSMutableArray arrayWithArray:_elements];
                [array addObjectsFromArray:@[_back, _prew]];
                [self bounceElements:array isInSuperView:YES];
            } else {
                NSMutableArray *array = [NSMutableArray arrayWithArray:_elements];
                [array addObjectsFromArray:@[_back, _next, _prew]];
                [self bounceElements:array isInSuperView:YES];
            }
        }];
    }];
}
- (void)bounceElements:(NSArray *)elements isInSuperView:(BOOL)inSuperview
{
    for (UIView *element in elements) {
        CATransform3D transform = [[element layer] transform];
        if ([[[self view] subviews ] containsObject:element]) {
            [[element layer] setTransform:CATransform3DMakeScale(0, 0, 0)];
            element.alpha = 1;
        } else {
            [[element layer] setTransform:CATransform3DMakeScale(0, 0, 0)];
            [self.view addSubview:element];
        }
        [UIView animateWithDuration:kAnimationDuration*0.6 delay:[elements indexOfObject:element]*0.09 options:UIViewAnimationOptionCurveLinear animations:^{
            [element layoutIfNeeded];
            [[element layer] setTransform:CATransform3DMakeScale(1.2, 1.2, 1.2)];
            element.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:kAnimationDuration*0.6 animations:^{
                [[element layer] setTransform:transform];
                [element layoutIfNeeded];
            }];
        }];
    }
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
- (void)compleetAnimation
{
    for (int i = 0; i<[[_levelManager mcElements] count]; i++)
    {
        [_elements[i] removeFromSuperview];
    }

    NSString *path = [[_levelManager mcLevel] objectForKey:_compleetKey];
    PDFImageView *oldImage = [[PDFImageView alloc] initWithFrame:_field.frame];
    oldImage.image = _field.image;
    oldImage.contentMode = UIViewContentModeScaleAspectFit;
    [[self view] addSubview:oldImage];
    
    PDFImage *image = [FPLevelManager imageNamed:path];
    PDFImageView *newImage = [[PDFImageView alloc] initWithFrame:_field.frame];
    newImage.image = [FPLevelManager imageNamed:path];
    newImage.contentMode = UIViewContentModeScaleAspectFit;
    [[self view] addSubview:newImage];

    CGAffineTransform transform = newImage.transform;
    newImage.layer.zPosition = MAXFLOAT;
    newImage.alpha = 0;
    _field.alpha = 0;
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
            _field.alpha = 1;
            [oldImage removeFromSuperview];
            [newImage removeFromSuperview];
            [self showBasket:nil];
            [self bounceElements:@[_next] isInSuperView:YES];

        }];
    }];
    _field.image = image;
}

- (void)showLevelName:(void (^)())completion
{
    [[FPSoundManager sharedInstance] playSound:self.levelManager.soundURL];
    [_levelName setText:[FPLevelManager gameLocalizedStringForKey:_levelManager.levelName]];
    [_levelName sizeToFit];
    CGPoint snapPoint = CGPointMake(CGRectGetMidX([[self view] bounds]), CGRectGetMaxY([[self view] bounds])-[self levelName].bounds.size.height);
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:[self levelName] snapToPoint:snapPoint];
    [[self levelName] setAlpha:1];
    [[self animator] addBehavior:snap];
}
- (void)showRays
{
    PDFImage *star = [FPLevelManager imageNamed:@"Levels/star"];
    CGRect frame = CGRectMake((-star.size.width/2)+CGRectGetMidX(_field.frame), (-star.size.height/2)+CGRectGetMidY(_field.frame), star.size.width, star.size.height);
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
    //[[FPSoundManager sharedInstance] playPrise];
    float xShift = 0.5;
    _basketView = [[UIView alloc] initWithFrame:CGRectMake(-CGRectGetMidX(self.view.bounds)*0.4, CGRectGetMidX(self.view.bounds)*0.3, 120, 120)];
    UIImageView *imageVeiw = [[UIImageView alloc] initWithFrame:_basketView.bounds];
    [imageVeiw setImage:[UIImage imageNamed:@"basket_full_img"]];
    [_basketView addSubview:imageVeiw];
    _basketView.tag=99;
    [self.view addSubview:_basketView];
    UIImageView *candyView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"candy_orange"]];
    candyView.tag=98;
    candyView.frame = CGRectMake(CGRectGetMidX(self.view.bounds), (CGRectGetMidX(self.view.bounds)*0.3)-70, 35, 35);
    [self.view addSubview:candyView];
    _basketSnap = [[UISnapBehavior alloc] initWithItem:_basketView snapToPoint:CGPointMake(CGRectGetMidX(self.view.bounds)*xShift, CGRectGetMidY(self.view.bounds))];
    _basketSnap.damping = 0.3;
    [_animator addBehavior:_basketSnap];
    UISnapBehavior *candySnap = [[UISnapBehavior alloc] initWithItem:candyView snapToPoint:CGPointMake(CGRectGetMidX(self.view.bounds)*xShift, CGRectGetMidY(_basketView.frame)-70)];
    candySnap.damping = 0.4;

    [_animator addBehavior:candySnap];
    [UIView animateWithDuration:kAnimationDuration*2 animations:^{
        candyView.transform = CGAffineTransformMakeRotation(M_PI);
    } completion:^(BOOL finished) {
        _basketView.layer.zPosition=2;
        candyView.layer.zPosition=0;
        [_animator removeBehavior:candySnap];

        [UIView animateWithDuration:kAnimationDuration*1.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGAffineTransform transform = candyView.transform;
            transform = CGAffineTransformRotate(transform, M_PI);
            transform = CGAffineTransformTranslate(transform, 0, -95);
            candyView.transform = transform;
        } completion:^(BOOL compleat){
            //[[FPSoundManager sharedInstance] playPrise];
            candyView.frame = [self.view convertRect:candyView.frame toView:_basketView];
            [_basketView insertSubview:candyView atIndex:0];
            [_animator removeBehavior:_basketSnap];
            [_animator removeBehavior:candySnap];
            [self performSelector:@selector(moveFieldToCenter:) withObject:nil afterDelay:kAnimationDuration];
            if (completion) {
                completion();
            }
        }];
    }];
}

- (void)moveFieldToCenter:(void(^)())completion
{
    PDFImageView *imageView = [[PDFImageView alloc] initWithFrame:_field.frame];
    imageView.image = _field.image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    _field.alpha = 0;
    CGRect centerRect = imageView.frame;
    centerRect.size.height = imageView.frame.size.height - _levelName.frame.size.height;
    centerRect.origin.x = CGRectGetMidX(self.view.bounds)-(imageView.frame.size.width/2);
    centerRect.origin.y = CGRectGetMidY(self.view.bounds)-(centerRect.size.height/2)-_levelName.frame.size.height;

    PDFImageView *star = (PDFImageView *)[self.view viewWithTag:FPTagRay];
    CGRect frame = CGRectMake((-star.image.size.width/2)+CGRectGetMidX(centerRect), (-star.image.size.height/2)+CGRectGetMidY(centerRect), star.image.size.width, star.image.size.height);
    [self showLevelName:nil];
    CGAffineTransform imageTransform = imageView.transform;
    imageTransform = CGAffineTransformTranslate(imageTransform, -(_field.frame.origin.x-centerRect.origin.x),  -(_field.frame.origin.y-centerRect.origin.y));
    imageTransform = CGAffineTransformScale(imageTransform, centerRect.size.height/_field.frame.size.height, centerRect.size.height/_field.frame.size.height);
    [UIView animateWithDuration:kAnimationDuration*2 animations:^{
        //imageView.frame = centerRect;
        imageView.transform = imageTransform;
        star.frame = frame;
        _basketView.transform = CGAffineTransformMakeTranslation(-(_basketView.frame.origin.x+_basketView.frame.size.width), 0);
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - Publick
- (UIImage *)screenshot
{
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
    _elementsLeft =  self.levelType==FPGameTypeFirst? [[_levelManager mcElements] count] : 1;
    for (int i = 0; i<[[_levelManager mcElements] count]; i++) {
        NSString *path = [[[_levelManager mcElements] objectAtIndex:i] valueForKey:@"path"];
        PDFImage *image = [FPLevelManager imageNamed:path];
        FPElement *imageView = [[FPElement alloc] initWithFrame:[self adaptRectSize:image.size]];
        imageView.layer.zPosition = i;
        imageView.tag = i;
        imageView.image = image;
        [elements addObject:imageView];
        [imageView setAlpha:0];
        //[imageView setHidden:YES];
        imageView.winPlace = [self getAdaptedPoint:[[[[_levelManager mcElements] objectAtIndex:i] valueForKey:@"nativePoint"] CGPointValue]];
    }
    _elements = [NSArray arrayWithArray:elements];
    //[self bounceElements:_elements isInSuperView:NO];
}
- (CGRect)adaptRectFromRect:(CGRect)rect
{
    double multiplayer = _field.frame.size.width/_field.image.size.width;
    return CGRectMake(rect.origin.x*multiplayer, rect.origin.y*multiplayer, rect.size.width*multiplayer, rect.size.height*multiplayer);
}
- (CGRect)adaptRectSize:(CGSize)size
{
    float multiplier = 1;
    if (_field.image.size.height>_field.image.size.width)
    {
        multiplier = _field.frame.size.height/_field.image.size.height;
    } else {
        multiplier = _field.frame.size.width/_field.image.size.width;
    }
    size.width = size.width*multiplier;
    size.height = size.height*multiplier;
    double maxX, maxY;
    maxX = CGRectGetHeight(self.view.bounds)-size.width;
    maxY = CGRectGetHeight(self.view.bounds)-size.height-40;
    double x = arc4random_uniform(maxX - 39) + 40;
    double y = arc4random_uniform(maxY - 40) + 40;
    return CGRectMake(x, y, size.width, size.height);
}
- (CGPoint)getAdaptedPoint:(CGPoint)point
{
    float multiplier = 1;
    float heightShift = 0;
    float widthShift = 0;
    if (_field.image.size.height>_field.image.size.width)
    {
        multiplier = _field.frame.size.height/_field.image.size.height;
        widthShift = (_field.frame.size.width-_field.image.size.width*multiplier)/2;
    } else {
        multiplier = _field.frame.size.width/_field.image.size.width;
        heightShift = (_field.frame.size.height-_field.image.size.height*multiplier)/2;
    }
    return CGPointMake((point.x*multiplier)+_field.frame.origin.x+widthShift, (point.y*multiplier)+_field.frame.origin.y+heightShift);
}
- (void)levelCompleet
{
    BOOL level = [[NSUserDefaults standardUserDefaults] boolForKey:[FPLevelManager gameLocalizedStringForKey:self.levelManager.levelName]];
    if (!level) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[FPLevelManager gameLocalizedStringForKey:self.levelManager.levelName]];
        [[NSUserDefaults standardUserDefaults] setInteger:_levelNumber forKey:@"lastLevel"];
    }
    //[self updateCollectionView];
    [self compleetAnimation];
}
- (void)restartLevel
{
    [self startAnimationForNewLevel];
}
#pragma mark - IBAction
+ (UIImage *)renderImageFromView:(UIView *)view withRect:(CGRect)frame {
    
    UIGraphicsBeginImageContextWithOptions(frame.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    
    UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return renderedImage;
}


- (IBAction)next:(id)sender;
{
    [[self updateCollectionView] nextLevel];
}
- (IBAction)prew:(id)sender
{
    [[self updateCollectionView] previousLevel];

}
- (IBAction)back:(id)sender
{
    if ([self navigationController]) {
        [[self navigationController] popViewControllerAnimated:YES];
    } else if ([self presentingViewController])
    {

        [[self updateCollectionView] closeGameplay];
    }

}

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
    _dragingElement = nil;
    _dragingPoint = CGPointZero;
    NSMutableArray *tapElements = [[NSMutableArray alloc] init];
    for (FPElement *element in _elements) {
        if (CGRectContainsPoint(element.frame, touchLocation) && ![self pointIsTransparent:[touch1 locationInView:element] inView:element] && !element.inPlace) {
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
            _dragingElement = element;
            _dragingPoint = CGPointMake([touch1 locationInView:element].x/element.frame.size.width, [touch1 locationInView:element].y/element.frame.size.height);
            _dragingWinPoint = [[[[_levelManager mcElements] objectAtIndex:[_elements indexOfObject:element]] valueForKey:@"nativePoint"] CGPointValue];
        }
    } else if (tapElements.count == 1) {
        FPElement *element = [tapElements firstObject];
        element.layer.zPosition = [_elements count]-1;
        NSMutableArray *array = [NSMutableArray arrayWithArray:[_elements sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSNumber *z1 = [NSNumber numberWithFloat:[[(UIView *)obj1 layer] zPosition]];
            NSNumber *z2 = [NSNumber numberWithFloat:[[(UIView *)obj2 layer] zPosition]];
            return [z1 compare:z2] ;
            
        }]];
        [array removeObject:element];
        for (int i = 0; i<[array count]; i++) {
            if (!element.inPlace)
            [[[array objectAtIndex:i] layer] setZPosition:i];
        }
        _dragingElement = element;
        _dragingPoint = CGPointMake([touch1 locationInView:element].x/element.frame.size.width,
                                    [touch1 locationInView:element].y/element.frame.size.height);
        _dragingWinPoint = [self getAdaptedPoint:[[[[_levelManager mcElements] objectAtIndex:[_elements indexOfObject:element]] valueForKey:@"nativePoint"] CGPointValue]];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch1 = [touches anyObject];
    CGPoint touchLocation = [touch1 locationInView:self.view];
    if (_dragingElement.inPlace) {
        
    } else {
        _dragingElement.layer.anchorPoint = _dragingPoint;
        _dragingElement.layer.position = touchLocation;
//        [self.attachmentBehavior setAnchorPoint:touchLocation];
        [self checkForRightPlace:_dragingElementIndex];
//        [self.collision addItem:_dragingElement];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.collision removeItem:_dragingElement];
}
- (void)checkForRightPlace:(NSUInteger)index
{
    CGPoint rightPoint = _dragingElement.winPlace;
    CGPoint currentPoint = _dragingElement.frame.origin;
    BOOL xPosition = 20>=abs(rightPoint.x-currentPoint.x);
    BOOL yPosition = 20>=abs(rightPoint.y-currentPoint.y);
    
    if (xPosition&&yPosition&&_dragingElement) {
        _dragingElement.inPlace = YES;
        _dragingElement.layer.zPosition = -1;
        [self bounceElement:_dragingElement];
        _elementsLeft--;
        if (_elementsLeft<=0) {
            [self levelCompleet];
        }
        //_dragingElement.layer.anchorPoint = CGPointZero;
        //_dragingElement.layer.position = rightPoint;
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

- (void) resetImageProgress
{
    NSLog(@"reset");
}

#pragma mark - Accelerometer Delegate

- (void) iPhoneDidShaked
{
    _resetImage++;
    _field.alpha-=0.1;
    NSLog(@"%i",_resetImage);
    switch (_resetImage) {
        case 10:
//            [self restartLevel];
//            [self loadLevel:self.levelNumber type:self.levelType];
//            [self.ACManager stopShakeDetect];
        break;
            
        default:
            break;
    }
    if (_resetImage == 10) {
        [_ACManager stopShakeDetect];
        [self resetImageProgress];
    }
}

@end
