//
//  AppDelegate.m
//  PhotoUploader
//
//  Created by rahul nagpal on 22/06/13.
//  Copyright (c) 2013 rahul nagpal. All rights reserved.
//

#import "AppDelegate.h"
#include <sys/xattr.h>

#import "ViewController.h"

int internetWorking;

@implementation AppDelegate

@synthesize navigationController;
@synthesize internetReach;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString * pathString = [documentDir  stringByAppendingPathComponent:@"PhotoUploader"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:pathString]) {
        //******* Creating folder in document directory********//
        [[NSFileManager defaultManager] createDirectoryAtPath:pathString withIntermediateDirectories:NO attributes:nil error:nil];
        //********Function which disable the icloud backup of document folder********//
        [self addSkipBackupAttributeToPath:pathString];

        pathString = [pathString  stringByAppendingPathComponent:@"log.txt"];
        
        // Create an empty text file.
        [[NSFileManager defaultManager] createFileAtPath:pathString contents:nil attributes:nil];

    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)addSkipBackupAttributeToPath:(NSString*)path {
    u_int8_t b = 1;
    setxattr([path fileSystemRepresentation], "com.apple.MobileBackup", &b, 1, 0, 0);
}

+ (AppDelegate *) sharedInstance {
    
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark
#pragma markChecking Internet Connection Availibility

- (void) updateInterfaceWithReachability: (ReachabilityNew*) curReach{
	if(curReach == internetReach)	{
		NetworkStatus netStatus = [curReach currentReachabilityStatus];
		switch (netStatus){
			case NotReachable:{
				internetWorking = 0;
				break;
			}
			case ReachableViaWiFi:{
				internetWorking = 1;
				break;
			}
			case ReachableViaWWAN:{
				internetWorking = 1;
				break;
			}
		}
	}
}

-(void)CheckInternetConnection{
	internetReach = [ReachabilityNew reachabilityForInternetConnection];
	[internetReach startNotifer];
	[self updateInterfaceWithReachability:internetReach];
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
