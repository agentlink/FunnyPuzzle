//
//  JMIBlurView.h
//  blurView
//
//  Created by Ibanez, Jose on 6/25/13.
//  Copyright (c) 2013 Ibanez, Jose. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlurStyle.h"

@class BlurLayer;

@interface BlurView : UIView

@property (nonatomic, readonly) BlurLayer *blurLayer;

- (id)initWithFrame:(CGRect)frame blurStyle:(BlurStyle)style;

@end
