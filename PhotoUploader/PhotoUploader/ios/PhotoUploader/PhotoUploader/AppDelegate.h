//
//  AppDelegate.h
//  PhotoUploader
//
//  Created by rahul nagpal on 22/06/13.
//  Copyright (c) 2013 rahul nagpal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) ViewController *viewController;

@property (assign, nonatomic) ReachabilityNew * internetReach;


+ (AppDelegate *) sharedInstance;
- (void) CheckInternetConnection;


@end
