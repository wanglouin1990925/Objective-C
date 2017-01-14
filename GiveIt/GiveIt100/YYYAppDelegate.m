//
//  YYYAppDelegate.m
//  GiveIt100
//
//  Created by Wang MeiHua on 1/10/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYAppDelegate.h"
#import "DEMORootViewController.h"
#import "YYYLoginNavController.h"
#import "YYYCommunication.h"

@implementation YYYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
//    50,79,133
    
    UIColor* mainColor = [UIColor colorWithRed:50.0f/255 green:79.0f/255 blue:133.0f/255 alpha:1.0f];
    
    UIImage *imgForBack = [ self imageWithColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBackgroundImage:imgForBack forBarMetrics:UIBarMetricsDefault];

    //    [[UINavigationBar appearance] setBarTintColor:darkColor];
    
    NSString* boldFontName = @"Avenir-Black";
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:boldFontName size:25.0], NSFontAttributeName,
                                mainColor, NSForegroundColorAttributeName, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:@"userinfo"]) {
        [YYYCommunication sharedManager].me = [userDefault objectForKey:@"userinfo"];
        [self userLoggedIn];
    }
    
    return YES;
}

- (void)userLoggedIn
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[YYYCommunication sharedManager].me forKey:@"userinfo"];
    [userDefault synchronize];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DEMORootViewController *viewcontroller = [storyboard instantiateViewControllerWithIdentifier:@"rootController"];
    self.window.rootViewController = viewcontroller;
}

- (void)userLogedOut
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:nil forKey:@"userinfo"];
    [userDefault synchronize];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    YYYLoginNavController *viewcontroller = [storyboard instantiateViewControllerWithIdentifier:@"YYYLoginNavController"];
    self.window.rootViewController = viewcontroller;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
	
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return image;
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
