//
//  YYYAppDelegate.h
//  DND
//
//  Created by Wang MeiHua on 10/6/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <FacebookSDK/FacebookSDK.h>

#define PP_APPID        @"L5ffbFXwkXzIktNcPU8QZyB12Szb1m1MZGEB6J2v"
#define PP_CLIENTKEY    @"YfOTdno5WvRkrw31I3fF9gSu0gCahLfRw08gxkzk"

#define COLOR_GUY		[UIColor colorWithRed:0/255 green:126.0/255 blue:255.0/255 alpha:1.0f]
#define COLOR_GIRL		[UIColor colorWithRed:163.0/255 green:39.0/255 blue:45.0/255 alpha:1.0f]

@interface YYYAppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>
{
	CLLocation *location;
    CLLocationManager *locationmanager;
}

@property (strong, nonatomic) UIWindow *window;
@property float fLat;
@property float fLng;

+(YYYAppDelegate*)sharedDelegate;
-(void)setTheme:(int)index;
-(void)sendPushNotification:(NSString*)userid :(NSString*)message;

@end
