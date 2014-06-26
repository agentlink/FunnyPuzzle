//
//  Preferencces.m
//  FunnyPuzzle
//
//  Created by Misha on 21.05.14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import "FPPreferences.h"
#import "FPGameManager.h"
#import "FPSoundManager.h"
#import "FPSocialManager.h"
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

@interface FPPreferences () <UIPickerViewDataSource, UIPickerViewDelegate, GPPSignInDelegate>

@property (weak, nonatomic) IBOutlet UIButton *musicBTN;
@property (weak, nonatomic) IBOutlet UIButton *soundBTN;
@property (weak, nonatomic) IBOutlet UIButton *bordersBTN;
@property (weak, nonatomic) IBOutlet UIButton *backBTN;
@property (weak, nonatomic) IBOutlet UILabel *settingsLBL;
@property (weak, nonatomic) IBOutlet UILabel *languageLBL;

@property (weak, nonatomic) IBOutlet UILabel *musicLabel;
@property (weak, nonatomic) IBOutlet UILabel *soundLabel;
@property (weak, nonatomic) IBOutlet UILabel *bordersLabel;

@property (weak, nonatomic) NSArray *languageCodes;
@property (weak, nonatomic) NSDictionary *languages;

@property (weak, nonatomic) IBOutlet UIView *viewForPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerHeight;
@property (weak, nonatomic) IBOutlet UIButton *languageButton;
@property (weak, nonatomic) IBOutlet UILabel *languageLabel;
@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UIView *gradientView;
@property (weak, nonatomic) IBOutlet UIView *bottomBar;

- (IBAction)done:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)playMusic:(id)sender;
- (IBAction)playSound:(id)sender;
- (IBAction)displayInnerBoarders:(id)sender;
- (IBAction)changeLanguage:(id)sender;
- (IBAction)tweet:(id)sender;
- (IBAction)fbShare:(id)sender;
- (IBAction)googleShare:(id)sender;


@end

@implementation FPPreferences

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataSource = [NSMutableArray new];
    _languageCodes = [[FPGameManager sharedInstance] getLanguagesCodes];
    _languages = [[FPGameManager sharedInstance] getLanguages];
    for(NSString* code in _languageCodes) {
        [_dataSource addObject:[_languages valueForKey:code]];
    }
    [self setControlsState];
    [self configureUI];
}

- (void) dealloc{
    _dataSource = nil;
    _pickerView = nil;
}

#pragma mark - UIActions

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)playMusic:(id)sender{
    [FPGameManager sharedInstance].music=![FPGameManager sharedInstance].music;
    [[FPGameManager sharedInstance] changeSettings:[FPGameManager sharedInstance].music forKey:MUSIC];
    [self setControlsState];
    switch ([FPGameManager sharedInstance].music) {
        case YES:
            [[FPSoundManager sharedInstance] playBackgroundMusic];
        break;
        case NO:
            [[FPSoundManager sharedInstance] stopBackgroundMusic];
        break;
    }
    
}

- (IBAction)playSound:(id)sender{
    [FPGameManager sharedInstance].playSoundWhenImageAppear=![FPGameManager sharedInstance].playSoundWhenImageAppear;
    [[FPGameManager sharedInstance] changeSettings:[FPGameManager sharedInstance].playSoundWhenImageAppear forKey:PLAY_SOUND_WHEN_IMAGE_APPEAR];
    [self setControlsState];
}

- (IBAction)displayInnerBoarders:(id)sender{
    [FPGameManager sharedInstance].displayInnerBorders=![FPGameManager sharedInstance].displayInnerBorders;
    [[FPGameManager sharedInstance] changeSettings:[FPGameManager sharedInstance].displayInnerBorders forKey:DISPLAY_INNER_BORDERS];
    [self setControlsState];
    
}

- (IBAction)done:(id)sender{
    [self showPickerView:NO];
}

- (IBAction)changeLanguage:(id)sender {
    [self showPickerView:YES];
}

- (IBAction)tweet:(id)sender {
    [[FPSocialManager sharedInstance] shareWithTwitter:self];
}

- (IBAction)fbShare:(id)sender {
    [[FPSocialManager sharedInstance] shareWithFacebook:self];
}

- (IBAction)googleShare:(id)sender {
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.clientID = CLIENT_ID;
    signIn.scopes = [NSArray arrayWithObjects:
                     kGTLAuthScopePlusLogin,
                     nil];
    signIn.delegate = self;
    if (![signIn trySilentAuthentication]){
        [signIn authenticate];
    }
}

#pragma mark - Other methods

- (void) configureUI{
    _topBar.backgroundColor = [UIColor colorWithRed:(52.0/255.0) green:(73.0/255.0) blue:(94.0/255.0) alpha:1];
    _bottomBar.backgroundColor = [UIColor colorWithRed:(52.0/255.0) green:(73.0/255.0) blue:(94.0/255.0) alpha:1];
    _musicLabel.textColor = [UIColor colorWithRed:(44.0/255.0) green:(87.0/255.0) blue:(112.0/255.0) alpha:1];
    _soundLabel.textColor = [UIColor colorWithRed:(44.0/255.0) green:(87.0/255.0) blue:(112.0/255.0) alpha:1];
    _bordersLabel.textColor = [UIColor colorWithRed:(44.0/255.0) green:(87.0/255.0) blue:(112.0/255.0) alpha:1];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    [gradient setStartPoint:CGPointMake(0.0, 0.5)];
    [gradient setEndPoint:CGPointMake(1.0, 0.5)];
    CGRect frame = _gradientView.bounds;
    frame.size.width = self.view.frame.size.height;
    gradient.frame = frame;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:(30.0/255.0) green:(139.0/255.0) blue:(195.0/255.0) alpha:1] CGColor], (id)[[UIColor colorWithRed:(113.0/255.0) green:(188/255.0) blue:(241.0/255.0) alpha:1] CGColor], nil];
    [_gradientView.layer insertSublayer:gradient atIndex:0];
}

- (void) changeLanguage {
    [self showPickerView:YES];
}

- (void) setControlsState{
    if ([FPGameManager sharedInstance].music==YES) {
        [self.musicBTN setImage:[UIImage imageNamed:@"Check1"] forState:UIControlStateNormal];
    }
    else{
        [self.musicBTN setImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
    }
    if ([FPGameManager sharedInstance].playSoundWhenImageAppear==YES) {
        [self.soundBTN setImage:[UIImage imageNamed:@"Check2"] forState:UIControlStateNormal];
    }
    else{
        [self.soundBTN setImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
    }
    if ([FPGameManager sharedInstance].displayInnerBorders==YES) {
       [self.bordersBTN setImage:[UIImage imageNamed:@"Check3"] forState:UIControlStateNormal];
    }
    else{
        [self.bordersBTN setImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
    }
    [self.languageButton setTitle:[self getCurrentLanguage] forState:UIControlStateNormal];
}

- (void) setLabelsText{
    self.musicLabel.text=NSLocalizedString(@"playMusic", nil);
    self.soundLabel.text=NSLocalizedString(@"playSound", nil);
    self.bordersLabel.text=NSLocalizedString(@"borders", nil);
    self.settingsLBL.text=NSLocalizedString(@"settings", nil);
    self.languageLBL.text=NSLocalizedString(@"language", nil);
    [self.backBTN setTitle:NSLocalizedString(@"back", nil) forState:UIControlStateNormal];
}

- (void) setlanguage{
    NSString *language = [_languageCodes objectAtIndex:[_pickerView selectedRowInComponent:0]];
    [FPGameManager sharedInstance].language=language;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:language forKey:LANGUAGE];
    [defaults synchronize];
}

- (NSString*) getCurrentLanguage{
    return [_languages valueForKey:[FPGameManager sharedInstance].language];
}

- (int) getRow{
    int row=0;
    for (int i=0; i<_languageCodes.count; i++) {
        if ([[FPGameManager sharedInstance].language isEqualToString:[_languageCodes objectAtIndex:i]])
            row=i;
    }
    return row;
}

- (void) showPickerView:(BOOL)show{
    if (show==YES){
        self.pickerHeight.constant=80;
        [self.pickerView selectRow:[self getRow] inComponent:0 animated:YES];
    }
    else {
        self.pickerHeight.constant=0;
    }
    [self.viewForPicker setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - PickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return _dataSource.count;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
    label.textColor = [UIColor colorWithRed:(34.0/255.0) green:(77.0/255.0) blue:(102.0/255.0) alpha:1];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    label.text = [_dataSource objectAtIndex:row];
    label.textAlignment=NSTextAlignmentCenter;
    return label;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.languageButton setTitle:[_dataSource objectAtIndex:row] forState:UIControlStateNormal];
    [self setlanguage];
}

#pragma mark - GPPSignIn delegate

- (void) finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error{
    if (!error) {
        id<GPPShareBuilder> shareBuilder = [[GPPShare sharedInstance]
                                            nativeShareDialog];
        [shareBuilder setURLToShare:[NSURL URLWithString:ITUNES_LINK]];
        [shareBuilder setPrefillText:NSLocalizedString(@"Puzly Game", nil)];
        [shareBuilder open];
    }
}

@end
