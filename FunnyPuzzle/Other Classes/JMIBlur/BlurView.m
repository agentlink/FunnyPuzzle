//
//  JMIBlurView.m
//  blurView
//
//  Created by Ibanez, Jose on 6/25/13.
//  Copyright (c) 2013 Ibanez, Jose. All rights reserved.
//

#import "BlurView.h"
#import "BlurLayer.h"

@interface BlurView()

@end

@implementation BlurView

- (id)initWithFrame:(CGRect)frame blurStyle:(BlurStyle)style {
    self = [super initWithFrame:frame];
    if (self) {
        if (style != blurStyleCustom) {
            [(BlurLayer *)self.layer setBlurStyle:style];
        } else {
            [(BlurLayer *)self.layer setBlurStyle:style];
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame blurStyle:blurStyleCustom];
}

+ (Class)layerClass {
    return [BlurLayer class];
}


#pragma mark - public properties

- (BlurLayer *)blurLayer {
    return (BlurLayer *)self.layer;
}

@end
