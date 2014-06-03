//
//  GamePlayViewController.h
//  KG
//
//  Created by Misha on 19.05.14.
//  Copyright (c) 2014 KG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PDFImage/PDFImage.h>
@interface GamePlayViewController : UIViewController
@property (nonatomic, weak) IBOutlet PDFImageView *field;
@property (nonatomic, weak) IBOutlet PDFImageView *star;

@property (nonatomic) int BonusLevelCount;

- (void)levelFinish;
@end
