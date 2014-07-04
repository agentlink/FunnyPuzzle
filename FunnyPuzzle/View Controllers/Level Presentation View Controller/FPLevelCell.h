//
//  FPLevelCell.h
//  FunnyPuzzle
//
//  Created by Misha on 29.05.14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PDFImage/PDFImage.h>

@interface FPLevelCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet PDFImageView *imageView;
@property (nonatomic) BOOL isFinished;
@property (nonatomic) BOOL isLocked;
@property (nonatomic) IBOutlet UILabel *name;

- (void)changeFrameWithAnimationToRect:(CGRect)rect;
@end
