//
//  FPGamePlayController.m
//  FunnyPuzzle
//
//  Created by Misha on 30.05.14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import "FPGamePlayController.h"
#import "FPLevelManager.h"
#import "GameModel.h"
#import "FPGameManager.h"
#import "FPLevelPresentationViewController.h"

@interface FPElement:PDFImageView
@property (nonatomic) CGPoint winPlace;
@property (nonatomic) BOOL inPlace;

@end
@implementation FPElement

@end

@interface FPGamePlayController ()
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

@property (nonatomic) UIDynamicAnimator *animator;
@property (nonatomic) UIAttachmentBehavior *attachmentBehavior;
@property (nonatomic) UICollisionBehavior *collision;

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
    [self configureGameplayWithAnimationType:![[NSUserDefaults standardUserDefaults] boolForKey:_levelManager.levelName ]];
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
    _levelsCount=40;
    _levelNumber=level;
}

- (void)configureGameplayWithAnimationType:(FPGameplayAnimationMode)animationMode
{
    switch (animationMode) {
        case FPGameplayAnimationModeNewLevel:
            [self startAnimationForNewLevel];
            break;
        case FPGameplayAnimationModeLevelCompleet:
            [self startAnimationForCompleetLevel];
            break;
            
        default:
            break;
    }
}

#pragma mark - Animations

- (void)startAnimationForNewLevel
{
    [_field setBackgroundColor:[UIColor clearColor]];
    NSString *path;
    path = [[_levelManager mcLevel] objectForKey:_notCompleetKey];
    PDFImage *image = [PDFImage imageNamed:path];
    _field.image = image;
    [_field layoutIfNeeded];
    [self configElements];
}
- (void)startAnimationForCompleetLevel
{
    [self centerField:YES animate:NO];
    [_field setBackgroundColor:[UIColor clearColor]];
    PDFImage *image = [PDFImage imageNamed:[[_levelManager mcLevel] objectForKey:_compleetKey]];
    _field.image = image;
    _levelName.text = [_levelManager levelName];
    CGRect nameFrame = _levelName.frame;
    nameFrame.origin.x = nameFrame.origin.x*2;
    _levelName.frame = nameFrame;
    _levelName.alpha = 1;
}
- (void)centerField:(BOOL)center animate:(BOOL)animate
{
    CGRect fieldFrameToEdit = _field.frame;
    if (center) {
        fieldFrameToEdit.size.height = fieldFrameToEdit.size.height*0.9;
        fieldFrameToEdit.size.width = fieldFrameToEdit.size.height;
        fieldFrameToEdit.origin.x = (CGRectGetWidth([[self view] bounds])*0.5)-(CGRectGetWidth([_field frame])*0.5);
    } else {
        fieldFrameToEdit.origin.x = (CGRectGetWidth([[self view] bounds]))-(CGRectGetWidth([_field frame])*0.5);
    }
    if (animate) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            [[self view] layoutIfNeeded];
            _field.frame = fieldFrameToEdit;
        }];
    } else {
        [[self view] layoutIfNeeded];
        _field.frame = fieldFrameToEdit;
    }
}
- (void)bounceField
{
    CATransform3D transform = [[_field layer] transform];
    [UIView animateWithDuration:kAnimationDuration*0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_field layoutIfNeeded];
        [_field.layer setTransform:CATransform3DMakeScale(1.2, 1.2, 1.2)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kAnimationDuration*0.6 animations:^{
            [_field layoutIfNeeded];
            [_field.layer setTransform:transform];
            if (_elements) {
                NSMutableArray *array = [NSMutableArray arrayWithArray:_elements];
                [array addObjectsFromArray:@[_back, _next, _prew]];
                [self bounceElements:array isInSuperView:YES];
            } else {
                if (_levelNumber==_levelsCount-1) {
                    [self bounceElements:@[_back, _prew] isInSuperView:YES];
                }
                else
                {
                    if (_levelNumber==0) {
                        [self bounceElements:@[_back, _next] isInSuperView:YES];
                    }
                    else
                    {
                      [self bounceElements:@[_back, _next, _prew] isInSuperView:YES];
                    }
                }
            }
        }];
    }];
}
- (void)bounceElements:(NSArray *)elements isInSuperView:(BOOL)inSuperview
{
    for (UIView *element in elements) {
        CATransform3D transform = [[element layer] transform];
//        if (element.constraints.count > 0) {
//            [element layoutIfNeeded];
//        }
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

    NSString *path = [[_levelManager mcLevel] objectForKey:_compleetKey];
    PDFImageView *oldImage = [[PDFImageView alloc] initWithFrame:_field.frame];
    oldImage.image = _field.image;
    oldImage.contentMode = UIViewContentModeScaleAspectFit;
    [[self view] addSubview:oldImage];
    
    PDFImage *image = [PDFImage imageNamed:path];
    PDFImageView *newImage = [[PDFImageView alloc] initWithFrame:_field.frame];
    newImage.image = [PDFImage imageNamed:path];
    newImage.contentMode = UIViewContentModeScaleAspectFit;
    [[self view] addSubview:newImage];

    CGAffineTransform transform = newImage.transform;
    //_field.alpha = 0;
    newImage.layer.zPosition = MAXFLOAT;
    newImage.layer.transform = CATransform3DMakeScale(2, 2, 2);
    newImage.alpha = 0;
    _field.alpha = 0;
    [UIView animateWithDuration:kAnimationDuration*0.6 animations:^{
        oldImage.transform = CGAffineTransformMakeScale(0.8, 0.8);
        //oldImage.alpha = 0.5;
        newImage.alpha = 1;
        newImage.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kAnimationDuration*0.4 animations:^{
            oldImage.transform = CGAffineTransformMakeScale(0, 0);
            newImage.transform = transform;
            newImage.alpha = 1;
            oldImage.alpha = 0;
        } completion:^(BOOL finished) {
            _field.alpha = 1;
            [oldImage removeFromSuperview];
            [newImage removeFromSuperview];
        }];
    }];
    _field.image = image;
    for (int i = 0; i<[[_levelManager mcElements] count]; i++)
    {
        [_elements[i] removeFromSuperview];
    }
    CGRect rect=CGRectMake(-100, 50, 100, 100);
    UILabel *LevelName=[[UILabel alloc] initWithFrame:rect];
    LevelName.text=@"nrbfjbnsdlkb";
    [self.view addSubview:LevelName];
    
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
    _elementsLeft = [[_levelManager mcElements] count];
    for (int i = 0; i<[[_levelManager mcElements] count]; i++) {
        NSString *path = [[[_levelManager mcElements] objectAtIndex:i] valueForKey:@"path"];
        PDFImage *image = [PDFImage imageNamed:path];
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
    FPLevelPresentationViewController *presentationController = (FPLevelPresentationViewController *)[self presentingViewController];
    [presentationController nextLevel];
}
- (IBAction)prew:(id)sender
{
    FPLevelPresentationViewController *presentationController = (FPLevelPresentationViewController *)[self presentingViewController];
    [presentationController previousLevel];
}
- (IBAction)back:(id)sender
{
    if ([self navigationController]) {
        [[self navigationController] popViewControllerAnimated:YES];
    } else if ([self presentingViewController])
    {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
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
        if (CGRectContainsPoint(element.frame, touchLocation) && ![self pointIsTransparent:[touch1 locationInView:element] inView:element]) {
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
#warning Тут викликатиметься метод для виграшу
            [self compleetAnimation];
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
@end
