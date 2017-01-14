//
//  YYYAppDelegate.m
//  MoMo
//
//  Created by Wang MeiHua on 10/30/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYAppDelegate.h"
#import "YYYCommunication.h"
#import "NSData+Base64.h"

@implementation YYYAppDelegate

@synthesize bLogedIn;

+(YYYAppDelegate*)sharedDelegate
{
	return (YYYAppDelegate*)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
	[Parse setApplicationId:PP_APPID clientKey:PP_CLIENTKEY];
	[PFFacebookUtils initializeFacebook];
    
	UINavigationBar* navAppearance = [UINavigationBar appearance];
	UIImage *imgForBack = [ self imageWithColor:[UIColor colorWithRed:30.0f/255 green:30.0f/255 blue:30.0f/255 alpha:1.0f]];
	[navAppearance setBackgroundImage:imgForBack forBarMetrics:UIBarMetricsDefault];
	NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue" size:22.0], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
	[navAppearance setTitleTextAttributes:attributes];
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	[self startLocationManager];
	
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
    
    bLogedIn = NO;
    
    [self incomeMessage];
	
    return YES;
}

-(NSString*)encryptPassword:(NSString*)string
{
    NSData *plainData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    return base64String;
}

-(NSString*)decryptString:(NSString*)string
{
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:string options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    return decodedString;
}

-(void)sendPushNotification:(NSString*)userid :(NSString*)message
{
	PFQuery *pushQuery = [PFInstallation query];
	[pushQuery whereKey: @"owner" equalTo: userid];
	
	[PFPush sendPushMessageToQueryInBackground:pushQuery withMessage:message];
}

-(void)startTimer
{
//	timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(incomeMessage) userInfo:nil repeats:YES];
    bLogedIn = YES;
}

-(void)stopTimer
{
//	[timer invalidate];
//	timer = nil;
    bLogedIn = NO;
}

-(void)incomeMessage
{
    NSString *userId = @"-1";
    if([YYYCommunication sharedManager].dictInfo)
        userId = [[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"];
    
        
	void ( ^successed )( id _responseObject ) = ^( id _responseObject )
	{
		if ([[_responseObject objectForKey:@"success"] isEqualToString:@"1"])
		{
			[[NSNotificationCenter defaultCenter] postNotificationName:@"INCOMEMESSAGE" object:nil userInfo:_responseObject];
            [self incomeMessage];
		}
		else
		{
			[self incomeMessage];
		}
	} ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
	{
		[self incomeMessage];
    } ;
    
	[[YYYCommunication sharedManager] IncomeMessage:userId
										  successed:successed
											failure:failure];
}

-(void)startLocationManager
{
	locationmanager = [[CLLocationManager alloc] init];
    locationmanager.delegate = self;
    locationmanager.distanceFilter = kCLDistanceFilterNone;
    locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
	
	if ([locationmanager respondsToSelector:@selector(requestWhenInUseAuthorization)])
	{
		[locationmanager requestWhenInUseAuthorization];
	}
	
    [locationmanager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations
{
	//Get Location Information
	self.fLat = [[locations lastObject] coordinate].latitude;
	self.fLng = [[locations lastObject] coordinate].longitude;
}

- (UIImage *)imageWithColor:(UIColor *)color
{
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

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
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
	
}

@end
