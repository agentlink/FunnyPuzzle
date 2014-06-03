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
@property (nonatomic, weak) IBOutlet PDFImageView *imageVeiw;
@property (nonatomic) BOOL isFinished;

- (void)changeFrameWithAnimationToRect:(CGRect)rect;
@end
