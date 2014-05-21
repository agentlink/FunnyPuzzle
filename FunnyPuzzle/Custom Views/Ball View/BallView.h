//
//  BallView.h
//  KG
//
//  Created by Misha on 19.05.14.
//  Copyright (c) 2014 KG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SVGKFastImageView.h>
#import <SVGKImage.h>
@interface BallView : UIView
@property (nonatomic, strong) SVGKImage *image;
@property (nonatomic) BOOL isVisible;
@end
