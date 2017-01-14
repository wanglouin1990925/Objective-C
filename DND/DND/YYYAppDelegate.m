//
//  YYYAppDelegate.m
//  DND
//
//  Created by Wang MeiHua on 10/6/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYAppDelegate.h"
#import "AOTutorialController.h"
#import "YYYContainViewController.h"
#import "YYYCommunication.h"
#import "JCNotificationCenter.h"
#import "JCNotificationBannerPresenterIOS7Style.h"

@implementation YYYAppDelegate


+(YYYAppDelegate*)sharedDelegate
{
	return (YYYAppDelegate*)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Override point for customization after application launch.
	
	[Parse setApplicationId:PP_APPID clientKey:PP_CLIENTKEY];
	[PFFacebookUtils initializeFacebook];
	
	[PFFacebookUtils setVersion:1.0];
	[FBAppCall setVersion:1.0];
	
	AOTutorialController *vc = [[AOTutorialController alloc] initWithBackgroundImages:[[NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Config.plist"]] valueForKeyPath:@"Tutorial.Images"]
                                                                      andInformations:[[NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Config.plist"]] valueForKeyPath:@"Tutorial.Labels"]];
	[vc setButtons:AOTutorialButtonSignup | AOTutorialButtonLogin];
	[self.window setRootViewController:vc];
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	
	locationmanager = [[CLLocationManager alloc] init];
    locationmanager.delegate = self;
    locationmanager.distanceFilter = kCLDistanceFilterNone;
    locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationmanager startUpdatingLocation];
	
	if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended)
	{
		if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"])
		{
			[YYYCommunication sharedManager].me = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"]];
			[YYYCommunication sharedManager].lstNotification = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"notifications"]];
			
			//Go to Main Page
			if ([[[YYYCommunication sharedManager].me objectForKey:@"user_gender"] isEqualToString:@"female"])
			{
				[[YYYAppDelegate sharedDelegate] setTheme:1];
			}
			else
			{
				[[YYYAppDelegate sharedDelegate] setTheme:0];
			}
			
			UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
			YYYContainViewController *viewcontroller = [storyboard instantiateViewControllerWithIdentifier:@"YYYContainViewController"];
			UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewcontroller];
			[YYYAppDelegate sharedDelegate].window.rootViewController = navController;
		}
	}
	
	if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
	{
		//ios 8
		[[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
		[[UIApplication sharedApplication] registerForRemoteNotifications];
	}
	else
	{
		[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound)];
	}
	
    return YES;
}

- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations
{
	//Get Location Information
	self.fLat = [[locations lastObject] coordinate].latitude;
	self.fLng = [[locations lastObject] coordinate].longitude;
	
	// rest code will be same
}

-(void)sendPushNotification:(NSString*)userid :(NSString*)message
{
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey: @"owner" equalTo: userid];
    
    [PFPush sendPushMessageToQueryInBackground:pushQuery withMessage:message];
}

-(void)setTheme:(int)index
{
	if (index == 0)
	{
		UINavigationBar* navAppearance = [UINavigationBar appearance];
		UIImage *imgForBack = [ self imageWithColor:COLOR_GUY];
		[navAppearance setBackgroundImage:imgForBack forBarMetrics:UIBarMetricsDefault];
		NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Dosis-Book" size:20.0], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
		[navAppearance setTitleTextAttributes:attributes];
	}
	else
	{
		UINavigationBar* navAppearance = [UINavigationBar appearance];
		UIImage *imgForBack = [ self imageWithColor:COLOR_GIRL];
		[navAppearance setBackgroundImage:imgForBack forBarMetrics:UIBarMetricsDefault];
		NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Dosis-Book" size:20.0], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
		[navAppearance setTitleTextAttributes:attributes];
	}
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

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	[[PFFacebookUtils session] close];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //    // Store the deviceToken in the current Installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

-(void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%@",[error description]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshNotification" object:nil];
	
	[JCNotificationCenter sharedCenter].presenter = [JCNotificationBannerPresenterIOS7Style new];
	
	[JCNotificationCenter
	 enqueueNotificationWithTitle:@""
	 message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
	 tapHandler:^{
		 
	 }];
}

@end
