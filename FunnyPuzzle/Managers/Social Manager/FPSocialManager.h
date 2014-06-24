//
//  FPSocialManager.h
//  FunnyPuzzle
//
//  Created by Stas Volskyi on 24.06.14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FPSocialManager : NSObject

+ (FPSocialManager*) sharedInstance;

-(void) shareWithTwitter:(UIViewController*)target;
-(void) shareWithFacebook:(UIViewController*)target;

@end
