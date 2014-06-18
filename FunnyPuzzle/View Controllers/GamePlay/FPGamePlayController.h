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
@property (nonatomic, weak) IBOutlet PDFImageView *field;
@property (nonatomic, weak) IBOutlet UIButton *next;
@property (nonatomic, weak) IBOutlet UIButton *prew;
@property (nonatomic, weak) IBOutlet UIButton *back;
@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic) int levelNumber;
@property (nonatomic) CGRect fieldFrame;


- (void)loadLevel:(int)level type:(FPGameType)type;
- (void)configureGameplayWithAnimationType:(FPGameplayAnimationMode)animationMode;
- (void)bounceField;
- (UIImage *)screenshot;

@end
