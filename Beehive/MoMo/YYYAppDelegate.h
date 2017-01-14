//
//  YYYAppDelegate.h
//  MoMo
//
//  Created by Wang MeiHua on 10/30/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <FacebookSDK/FacebookSDK.h>

#define PP_APPID        @"Xt3EJvyR2Q5fw5xz6C4uRzR1j28PxiKFq4IiVoSj"
#define PP_CLIENTKEY    @"jIcH3kPTJBYAhu5rIdl0Zs8DiQ4qn7PAlzEGdNyr"

@interface YYYAppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>
{
	CLLocation *location;
    CLLocationManager *locationmanager;
	
	NSTimer *timer;
}

+(YYYAppDelegate*)sharedDelegate;
-(NSString*)encryptPassword :(NSString*)string;
-(NSString*)decryptString   :(NSString*)string;

@property (strong, nonatomic) UIWindow *window;

@property float fLat;
@property float fLng;
@property BOOL  bLogedIn;

-(void)startTimer;
-(void)stopTimer;
-(void)sendPushNotification:(NSString*)userid :(NSString*)message;

@end
