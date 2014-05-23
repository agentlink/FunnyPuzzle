//
//  BallView.h
//  KG
//
//  Created by Misha on 19.05.14.
//  Copyright (c) 2014 KG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PDFImage/PDFImage.h>
typedef void (^tap)();
@interface BallView : UIView
@property (nonatomic, weak) PDFImage *image;
@property (nonatomic, copy) void (^tap)(void);
@end
