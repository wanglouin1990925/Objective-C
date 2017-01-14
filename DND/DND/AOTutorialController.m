//
//  AOTutorialController.m
//  AOTutorial
//
//  Created by Loïc GRIFFIE on 14/10/2013.
//  Copyright (c) 2013 Appsido. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "AOTutorialController.h"
#import "YYYContainViewController.h"
#import "MBProgressHUD.h"
#import "YYYAppDelegate.h"
#import "YYYTabbarController.h"

#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import <AVFoundation/AVFoundation.h>
#import "AFHTTPSessionManager.h"
#import "YYYCommunication.h"

@interface AOTutorialController ()

@end

@implementation AOTutorialController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	lstPhoto = [[NSMutableArray alloc] init];
	dictUser = [[NSMutableDictionary alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - User interface methods

- (IBAction)signup:(id)sender
{
//	[[YYYAppDelegate sharedDelegate] setTheme:1];
//	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//	YYYContainViewController *viewcontroller = [storyboard instantiateViewControllerWithIdentifier:@"YYYContainViewController"];
//	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewcontroller];
//	[YYYAppDelegate sharedDelegate].window.rootViewController = navController;
//	return;	
	
	NSArray *permissions = @[ @"user_about_me", @"user_birthday", @"user_location",@"user_friends",@"user_photos",@"friends_photos",@"friends_birthday"];
	
	[PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error)
	 {
		 [MBProgressHUD hideAllHUDsForView:self.view animated:YES]; // Hide loading indicator
		 
		 if (!user)
		 {
			 NSLog(@"Uh oh. The user cancelled the Facebook login.");
		 }
		 else if (user.isNew)
		 {
			 [self fbLogedIn];
		 }
		 else
		 {
			 [self fbLogedIn];
		 }
	 }];
	
	
	[MBProgressHUD showHUDAddedTo:self.view animated:YES]; // Show loading indicator until login is finished
}

-(void)showAlert:(NSString*)title message:(NSString*)message
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
}

-(void)loadTaggedPhotos
{
	[FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"me/photos?fields=images&type=tagged"]
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
							   if (!error && result)
							   {
								   for (NSDictionary *dict in [result objectForKey:@"data"])
								   {
									   [lstPhoto addObject:dict];
									   
									   if ([lstPhoto count] >= 10)
									   {
										   break;
									   }
								   }
								   
								   if ([lstPhoto count] >= 10)
								   {
									   [self createAccount];
								   }
								   else
								   {
									   [self loadUploadedPhotos];
								   }
								}
							   else
							   {
								   NSLog(@"Failed");
							   }
                              /* handle the result */
                          }];

}

-(void)loadUploadedPhotos
{
	[FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"me/photos?fields=images&type=uploaded"]
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
							  
							  [MBProgressHUD hideHUDForView:self.view animated:YES];
							  
                              if (!error && result)
							  {
								  for (NSDictionary *dict in [result objectForKey:@"data"])
								  {
									  [lstPhoto addObject:dict];
									  
									  if ([lstPhoto count] >= 10)
									  {
										  break;
									  }
								  }
								  
								  [self createAccount];
							  }
                              else
							  {
                                  NSLog(@"Failed");
                              }
                          }];
}

-(void)createAccount
{
	[ MBProgressHUD showHUDAddedTo:self.view animated:YES ];
	
	void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
		
		[ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
		
		if( [ [ _responseObject objectForKey : @"success" ] isEqualToString : @"1" ] )
		{
			[YYYCommunication sharedManager].me = [[NSMutableDictionary alloc] initWithDictionary:[_responseObject objectForKey:@"detail"]];
			[YYYCommunication sharedManager].lstNotification = [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"notification"]];
			
			//Go to Main Page
			if ([[[YYYCommunication sharedManager].me objectForKey:@"user_gender"] isEqualToString:@"female"])
			{
				[[YYYAppDelegate sharedDelegate] setTheme:1];
			}
			else
			{
				[[YYYAppDelegate sharedDelegate] setTheme:0];
			}
			
			NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
			[defaults setObject:[_responseObject objectForKey:@"detail"] forKey:@"userinfo"];
			[defaults setObject:[_responseObject objectForKey:@"notification"] forKey:@"notifications"];
			
			if (![defaults objectForKey:@"distance"])
				[defaults setObject:@"99" forKey:@"distance"];
			
			if (![defaults objectForKey:@"ageh"])
				[defaults setObject:@"80" forKey:@"ageh"];
			
			if (![defaults objectForKey:@"agel"])
				[defaults setObject:@"10" forKey:@"agel"];
			
			if (![defaults objectForKey:@"push"])
				[defaults setObject:@"1" forKey:@"push"];
			
			[defaults synchronize];
			
			PFInstallation *currentInstallation = [PFInstallation currentInstallation];
			[currentInstallation setChannels:[[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"c%@",[[YYYCommunication sharedManager].me objectForKey:@"user_facebookid"]], nil]];
			[currentInstallation setObject: [[YYYCommunication sharedManager].me objectForKey:@"user_facebookid"] forKey: @"owner"];
			[currentInstallation saveInBackground];
			
			UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
			YYYContainViewController *viewcontroller = [storyboard instantiateViewControllerWithIdentifier:@"YYYContainViewController"];
			UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewcontroller];
			[YYYAppDelegate sharedDelegate].window.rootViewController = navController;
		}
		else
		{
			[ self  showAlert:@"Oops!" message:@"An unknown error occured" ] ;
			return ;
		}
	} ;
	
	void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
		// Hide ;
		[ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
		
		// Error ;
		[ self  showAlert:@"Oops!" message:@"An unknown error occured" ] ;
	} ;
	
	NSMutableArray *lstURL = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
	for (int i = 0; i < [lstPhoto count]; i++)
	{
		[lstURL replaceObjectAtIndex:i withObject:[[[[lstPhoto objectAtIndex:i] objectForKey:@"images"] objectAtIndex:0] objectForKey:@"source"]];
	}
	
	[[ YYYCommunication sharedManager ] SignUp:[dictUser objectForKey:@"id"]
									 firstname:[dictUser objectForKey:@"first_name"]
									  lastname:[dictUser objectForKey:@"last_name"]
										gender:[dictUser objectForKey:@"gender"]
										   age:[self getAge:[dictUser objectForKey:@"birthday"]]
									  latitude:[NSString stringWithFormat:@"%f",[YYYAppDelegate sharedDelegate].fLat]
									 longitude:[NSString stringWithFormat:@"%f",[YYYAppDelegate sharedDelegate].fLat]
										photo1:[lstURL objectAtIndex:0]
										photo2:[lstURL objectAtIndex:1]
										photo3:[lstURL objectAtIndex:2]
										photo4:[lstURL objectAtIndex:3]
										photo5:[lstURL objectAtIndex:4]
										photo6:[lstURL objectAtIndex:5]
										photo7:[lstURL objectAtIndex:6]
										photo8:[lstURL objectAtIndex:7]
										photo9:[lstURL objectAtIndex:8]
									   photo10:[lstURL objectAtIndex:9]
									 successed:successed
									   failure:failure];
}

-(void)fbLogedIn
{
	[MBProgressHUD showHUDAddedTo:self.view animated:YES]; // Show loading indicator until login is finished
	
	[[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *result, NSError *error)
     {
		 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
		 
         // Did everything come back okay with no errors?
         if (!error && result)
		 {
			 dictUser = [[NSMutableDictionary alloc] initWithDictionary:result];
			 
			 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
			 if ([defaults objectForKey:@"distance"])
			 {
				 [self createAccount];
			 }
			 else
			 {
				 [self loadTaggedPhotos];
			 }
		 }
         else
		 {
             NSLog(@"%@",error.description);
         }
     }];
}

-(NSString *)getAge:(NSString *)pstrDate
{
    NSArray *arrayDateData = [pstrDate componentsSeparatedByString:@"/"];
    NSString *strAge = @"";
    if([arrayDateData count]>=2){
        
        NSDate *currentDate = [NSDate date];
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate]; // Get necessary date components
        
        int nAge = (int)[components year] - [[arrayDateData objectAtIndex:2] intValue];
        
        strAge = [NSString stringWithFormat:@"%d",nAge - 1];
    }else{
        strAge = @"";
    }
	
    return strAge;
}

- (IBAction)login:(id)sender
{
    NSLog(@"login button touch up completed");
}

- (IBAction)dismiss:(id)sender
{
    NSLog(@"dismiss button touch up completed");
}

@end
