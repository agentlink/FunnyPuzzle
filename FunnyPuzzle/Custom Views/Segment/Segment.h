//
//  Segment.h
//  KG
//
//  Created by Misha on 20.05.14.
//  Copyright (c) 2014 KG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SVGKit/SVGKFastImageView.h>
@interface Segment : UIView

@property (nonatomic) CGRect rect;
@property (nonatomic, strong) SVGKImage *image;

@end
