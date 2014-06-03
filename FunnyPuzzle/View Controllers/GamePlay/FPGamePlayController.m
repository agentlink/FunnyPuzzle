//
//  FPGamePlayController.m
//  FunnyPuzzle
//
//  Created by Misha on 30.05.14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import "FPGamePlayController.h"
#import "FPLevelManager.h"
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
    [self configureGameplayWithAnimationType:![[NSUserDefaults standardUserDefaults] boolForKey:_levelManager.levelName ]];
    //[self.view setBackgroundColor:[UIColor clearColor]];
    _levelName.alpha = 0;
    _back.alpha = 0;
    _next.alpha = 0;
    _prew.alpha = 0;
    //_animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
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
        case FPGameTypeFirs:
            _compleetKey = @"color";
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
   // UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:_levelName snapToPoint:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(_field.frame))];
    //[_animator addBehavior:snap];
    
}
- (void)centerField:(BOOL)center animate:(BOOL)animate
{
    //[[self view] layoutIfNeeded];
    CGRect fieldFrameToEdit = _field.frame;
    if (center) {
        //_fieldRightConstraint.constant = (CGRectGetWidth([[self view] bounds])*0.5)-(CGRectGetWidth([_field frame])*0.5);
        fieldFrameToEdit.size.height = fieldFrameToEdit.size.height*0.9;
        fieldFrameToEdit.size.width = fieldFrameToEdit.size.height;
        fieldFrameToEdit.origin.x = (CGRectGetWidth([[self view] bounds])*0.5)-(CGRectGetWidth([_field frame])*0.5);
    } else {
        //_fieldRightConstraint.constant = 20;
        fieldFrameToEdit.origin.x = (CGRectGetWidth([[self view] bounds]))-(CGRectGetWidth([_field frame])*0.5);
    }
    if (animate) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            [[self view] layoutIfNeeded];
            _field.frame = fieldFrameToEdit;
            //_field.layer.position = fieldFrameToEdit.origin;
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
         [_field.layer setTransform:CATransform3DMakeScale(1.2, 1.2, 1.2)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kAnimationDuration*0.6 animations:^{
            [_field.layer setTransform:transform];
            if (_elements) {
                NSMutableArray *array = [NSMutableArray arrayWithArray:_elements];
                [array addObjectsFromArray:@[_back, _next, _prew]];
                [self bounceElements:array isInSuperView:YES];
            } else {
                [self bounceElements:@[_back, _next, _prew] isInSuperView:YES];
            }
        }];
    }];
}
- (void)bounceElements:(NSArray *)elements isInSuperView:(BOOL)inSuperview
{
    for (UIView *element in elements) {
        CATransform3D transform = [[element layer] transform];
        if (inSuperview) {
            [[element layer] setTransform:CATransform3DMakeScale(0, 0, 0)];
            element.alpha = 0;
            if ([element isHidden]) {
                [element setHidden:NO];
            }
        } else {
            [[element layer] setTransform:CATransform3DMakeScale(0, 0, 0)];
            element.alpha = 0;
            [self.view addSubview:element];
        }
        [UIView animateWithDuration:kAnimationDuration*0.6 delay:[elements indexOfObject:element]*0.09 options:UIViewAnimationOptionCurveLinear animations:^{
            [[element layer] setTransform:CATransform3DMakeScale(1.2, 1.2, 1.2)];
            element.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:kAnimationDuration*0.6 animations:^{
                [[element layer] setTransform:transform];
            }];
        }];
    }
}
- (void)bounceElement:(FPElement *)element
{
    [UIView animateWithDuration:kAnimationDuration*0.6 animations:^{
//        element.layer.anchorPoint = CGPointMake(0, 0);
//        element.layer.position = element.winPlace;
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
        [imageView setHidden:YES];
        imageView.winPlace = [self getAdaptedPoint:[[[[_levelManager mcElements] objectAtIndex:i] valueForKey:@"nativePoint"] CGPointValue]];
    }
    _elements = [NSArray arrayWithArray:elements];
    [self bounceElements:_elements isInSuperView:NO];
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
    double x = 40+arc4random_uniform(CGRectGetWidth(self.view.bounds)-size.width)+1;
    double y = 40+arc4random_uniform(CGRectGetWidth(self.view.bounds)-size.height-40)+1;
    return CGRectMake(x, y, size.width*multiplier, size.height*multiplier);
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
- (IBAction)next:(id)sender;
{
    
}
- (IBAction)prew:(id)sender
{
    
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
        [self checkForRightPlace:_dragingElementIndex];
    }
}

- (void)checkForRightPlace:(NSUInteger)index
{
    CGPoint rightPoint = _dragingElement.winPlace;
    CGPoint currentPoint = _dragingElement.frame.origin;
    BOOL xPosition = 20>=abs(rightPoint.x-currentPoint.x);
    BOOL yPosition = 20>=abs(rightPoint.y-currentPoint.y);
    
    if (xPosition&&yPosition) {
        _dragingElement.inPlace = YES;
        [self bounceElement:_dragingElement];
        NSLog(@"%li", _elementsLeft);
        _elementsLeft--;
        NSLog(@"%li", _elementsLeft);
        if (_elementsLeft<=0) {
#warning Тут викликатиметься метод для виграшу
            [self centerField:YES animate:YES];
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
