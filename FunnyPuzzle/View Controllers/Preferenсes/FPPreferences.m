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

@interface FPPreferences () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *musicBTN;
@property (weak, nonatomic) IBOutlet UIButton *soundBTN;
@property (weak, nonatomic) IBOutlet UIButton *bordersBTN;
@property (weak, nonatomic) IBOutlet UIButton *vibrateBTN;
@property (weak, nonatomic) IBOutlet UIButton *backBTN;
@property (weak, nonatomic) IBOutlet UILabel *settingsLBL;
@property (weak, nonatomic) IBOutlet UILabel *languageLBL;

@property (weak, nonatomic) IBOutlet UILabel *musicLabel;
@property (weak, nonatomic) IBOutlet UILabel *soundLabel;
@property (weak, nonatomic) IBOutlet UILabel *bordersLabel;
@property (weak, nonatomic) IBOutlet UILabel *vibrateLabel;
- (IBAction)changeLanguage:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewForPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) NSArray *dataSource;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerHeight;
@property (weak, nonatomic) IBOutlet UIButton *languageButton;
- (IBAction)done:(id)sender;

- (IBAction)back:(id)sender;
- (IBAction)playMusic:(id)sender;
- (IBAction)playSound:(id)sender;
- (IBAction)displayInnerBoarders:(id)sender;
- (IBAction)vibrate:(id)sender;


@end

@implementation FPPreferences

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setControlsState];
    self.dataSource = [[FPGameManager sharedInstance] getLanguages];
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

- (IBAction)vibrate:(id)sender{
    [FPGameManager sharedInstance].vibrate=![FPGameManager sharedInstance].vibrate;
    [[FPGameManager sharedInstance] changeSettings:[FPGameManager sharedInstance].vibrate forKey:VIBRATE];
    [self setControlsState];
    
}

- (IBAction)done:(id)sender{
    [self showPickerView:NO];
}

- (IBAction)changeLanguage:(id)sender {
    [self showPickerView:YES];
}

#pragma mark - Other methods

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
    if ([FPGameManager sharedInstance].vibrate==YES) {
        [self.vibrateBTN setImage:[UIImage imageNamed:@"Check4"] forState:UIControlStateNormal];
    }
    else{
        [self.vibrateBTN setImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
    }
    [self.languageButton setTitle:[self getCurrentLanguage] forState:UIControlStateNormal];
}

- (void) setLabelsText{
    
    self.musicLabel.text=NSLocalizedString(@"playMusic", nil);
    self.soundLabel.text=NSLocalizedString(@"playSound", nil);
    self.vibrateLabel.text=NSLocalizedString(@"vibrate", nil);
    self.bordersLabel.text=NSLocalizedString(@"borders", nil);
    self.settingsLBL.text=NSLocalizedString(@"settings", nil);
    self.languageLBL.text=NSLocalizedString(@"language", nil);
    [self.backBTN setTitle:NSLocalizedString(@"back", nil) forState:UIControlStateNormal];
}

- (void) setlanguage{
    NSString *language;
    if ([self.languageButton.titleLabel.text isEqualToString:@"English"]) {
        language=@"en";
    }
    else if ([self.languageButton.titleLabel.text isEqualToString:@"Русский"]) {
        language=@"ru";
    }
    else if ([self.languageButton.titleLabel.text isEqualToString:@"Français"]) {
        language=@"fr";
    }
    else if ([self.languageButton.titleLabel.text isEqualToString:@"Deutschland"]) {
        language=@"de";
    }
    else if ([self.languageButton.titleLabel.text isEqualToString:@"Español"]) {
        language=@"es";
    }
    [FPGameManager sharedInstance].language=language;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:language forKey:LANGUAGE];
    [defaults synchronize];
}

- (NSString*) getCurrentLanguage{
    
    NSString *language;
    if ([[FPGameManager sharedInstance].language isEqualToString:@"en"]) {
        language=@"English";
    }
    if ([[FPGameManager sharedInstance].language isEqualToString:@"ru"]) {
        language=@"Русский";
    }
    else if ([[FPGameManager sharedInstance].language isEqualToString:@"fr"]) {
        language=@"Français";
    }
    else if ([[FPGameManager sharedInstance].language isEqualToString:@"de"]) {
        language=@"Deutschland";
    }
    else if ([[FPGameManager sharedInstance].language isEqualToString:@"es"]) {
        language=@"Español";
    }
    else {
        language=@"English";
    }
    return language;
}

- (int) getRow{
    int row=0;
    if ([[FPGameManager sharedInstance].language isEqualToString:@"en"]) {
        row=0;
    }
    else if ([[FPGameManager sharedInstance].language isEqualToString:@"ru"]) {
        row=1;
    }
    else if ([[FPGameManager sharedInstance].language isEqualToString:@"fr"]) {
        row=2;
    }    else if ([[FPGameManager sharedInstance].language isEqualToString:@"de"]) {
        row=3;
    }
    else if ([[FPGameManager sharedInstance].language isEqualToString:@"es"]) {
        row=4;
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

@end
