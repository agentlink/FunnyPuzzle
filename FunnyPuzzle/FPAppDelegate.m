//
//  FPAppDelegate.m
//  FunnyPuzzle
//
//  Created by Misha on 21.05.14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import "FPAppDelegate.h"
#import "FPGameManager.h"
#import <GooglePlus/GooglePlus.h>
#import "FPReminderViewController.h"

@implementation FPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[FPGameManager sharedInstance] setSettings];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"alreadyRated"] == NO)
        self.rateAppTimer = [NSTimer scheduledTimerWithTimeInterval:300.0 target:self selector:@selector(onTick) userInfo:nil repeats:NO];
    self.internetTimer = [NSTimer scheduledTimerWithTimeInterval:290.0 target:self selector:@selector(IsInternetConnection) userInfo:nil repeats:NO];
    return YES;
    
}

- (BOOL)application: (UIApplication *)application openURL: (NSURL *)url  sourceApplication: (NSString *)sourceApplication annotation: (id)annotation {
    return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
}

#pragma mark - Custom Methods

- (void) onTick
{
    if (([[NSUserDefaults standardUserDefaults] boolForKey:@"DontRateApp"] == NO) && (self.isInternet)){
        UIViewController *visibleViewController = [self getVisibleViewController];
        visibleViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        FPReminderViewController *reminder = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"reminder"];
        if (visibleViewController)
            [visibleViewController presentViewController:reminder animated:NO completion:nil];
    }
}

- (UIViewController*)getVisibleViewController
{
    UIViewController *viewController = self.window.rootViewController;
    while (viewController.presentedViewController) {
        viewController = viewController.presentedViewController;
    }
    return viewController;
}

- (void) IsInternetConnection
{
    __block FPAppDelegate *appDelegate = self;
    self.internet = [MyReachability reachabilityWithHostname:@"www.google.com"];
    self.internet.reachableBlock = ^(MyReachability*reach)
    {
        appDelegate.isInternet = YES;
    };
    self.internet.unreachableBlock = ^(MyReachability*reach)
    {
        appDelegate.isInternet = NO;
    };
    [self.internet startNotifier];
}

@end
