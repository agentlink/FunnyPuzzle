//
//  FPGamePlayController.h
//  FunnyPuzzle
//
//  Created by Misha on 30.05.14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PDFImage/PDFImage.h>


@interface FPGamePlayController : UIViewController
@property (weak, nonatomic) IBOutlet PDFImageView *field;
@property (weak, nonatomic) IBOutlet UIButton *next;
@property (weak, nonatomic) IBOutlet UIButton *prew;
@property (weak, nonatomic) IBOutlet UIButton *back;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (assign, nonatomic) int levelNumber;
@property (assign, nonatomic) int levelsCount;
@property (assign, nonatomic) CGRect fieldFrame;
@property (assign, nonatomic) FPGameType levelType;

- (void)loadLevel:(int)level type:(FPGameType)type;
- (void)configureGameplayWithAnimationType:(FPGameplayAnimationMode)animationMode;
- (void)bounceField;
- (void)start;
- (UIImage *)screenshot;

@end
