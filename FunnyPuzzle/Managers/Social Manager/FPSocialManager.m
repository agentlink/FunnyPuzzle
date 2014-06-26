//
//  FPSocialManager.m
//  FunnyPuzzle
//
//  Created by Stas Volskyi on 24.06.14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import "FPSocialManager.h"
#import <Social/Social.h>

@implementation FPSocialManager

static FPSocialManager *instance = nil;

+ (FPSocialManager*) sharedInstance{
    @synchronized(self){
        if (!instance) {
            instance = [FPSocialManager new];
        }
    }
    return instance;
}

-(void) shareWithTwitter:(UIViewController*)target{
    SLComposeViewController *tweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    tweet = [self configurePost:tweet];
    [target presentViewController:tweet animated:YES completion:nil];
}

-(void) shareWithFacebook:(UIViewController*)target{
    SLComposeViewController *facebook = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    facebook = [self configurePost:facebook];
    [target presentViewController:facebook animated:YES completion:nil];
}

- (SLComposeViewController*) configurePost:(SLComposeViewController*)composeViewController{
    [composeViewController setInitialText:NSLocalizedString(@"Puzly Game", nil)];
    [composeViewController addURL:[NSURL URLWithString:ITUNES_LINK]];
    [composeViewController addImage:[UIImage imageNamed:@"Icon_puzzly_1024"]];
    return composeViewController;
}

@end
