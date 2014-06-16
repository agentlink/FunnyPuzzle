//
//  JMIBlurLayer.h
//  blurView
//
//  Created by Jose Ibanez on 7/6/13.
//  Copyright (c) 2013 Ibanez, Jose. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BlurStyle.h"

@interface BlurLayer : CALayer

@property (nonatomic) CGFloat blurRadius;
@property (nonatomic) CGFloat saturation;
@property (nonatomic) CGFloat contrast;
@property (nonatomic) CGFloat brightness;

- (id)initWithBlurStyle:(BlurStyle)style;
- (void)setBlurStyle:(BlurStyle)style;

@end
