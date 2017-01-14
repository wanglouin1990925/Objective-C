//
//  YYYVerificationViewController.m
//  MoMo
//
//  Created by King on 11/17/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYVerificationViewController.h"
#import "YYYTabbarViewController.h"
#import "YYYAppDelegate.h"
#import "MBProgressHUD.h"
#import "YYYAppDelegate.h"
#import "YYYCommunication.h"
#import "NSData+Base64.h"

@interface YYYVerificationViewController ()

@end

@implementation YYYVerificationViewController

@synthesize dialCode;
@synthesize phone;
@synthesize password;
@synthesize imgAvatar;
@synthesize username;
@synthesize birthday;
@synthesize gender;
@synthesize name;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	txtCode.layer.borderColor = [[UIColor grayColor] CGColor];
	txtCode.layer.borderWidth = 1.0f;
	[txtCode becomeFirstResponder];
	
	[lblPhone setText:[NSString stringWithFormat:@"%@ %@",dialCode,phone]];
    
    verificationCode = [self verificationCode];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self sendSMS:[NSString stringWithFormat:@"%@%@",dialCode,phone] :verificationCode];
}

-(IBAction)btBackClick:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btDoneClick:(id)sender
{
    [txtCode resignFirstResponder];
    
    if (![txtCode.text isEqualToString:verificationCode])
    {
        [self showAlert:@"Error" message:@"Please input correct verification code"];
        return;
    }
    
    NSString *phonenumber = [NSString stringWithFormat:@"%@%@",[[dialCode stringByReplacingOccurrencesOfString:@"+" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""],phone];
    
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	void ( ^successed )( id _responseObject ) = ^( id _responseObject )
	{
		[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
		if ([[_responseObject objectForKey:@"success"] isEqualToString:@"1"])
		{
			[YYYCommunication sharedManager].dictInfo	= [[NSMutableDictionary alloc] initWithDictionary:[_responseObject objectForKey:@"detail"]];
			[YYYCommunication sharedManager].lstPhoto	= [[NSMutableArray alloc] initWithObjects:nil];
			[YYYCommunication sharedManager].lstGroup	= [[NSMutableArray alloc] initWithObjects:nil];
			[YYYCommunication sharedManager].lstFriend	= [[NSMutableArray alloc] initWithObjects:nil];
			[YYYCommunication sharedManager].lstBlock	= [[NSMutableArray alloc] initWithObjects:nil];
			
			YYYTabbarViewController *tabController = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYTabbarViewController"];
			[YYYAppDelegate sharedDelegate].window.rootViewController = tabController;
			
			[[YYYAppDelegate sharedDelegate] startTimer];
			
			PFInstallation *currentInstallation = [PFInstallation currentInstallation];
			[currentInstallation setChannels:[[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"c%@",[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"]], nil]];
			[currentInstallation setObject: [[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"] forKey: @"owner"];
			[currentInstallation saveInBackground];
            
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            
            [userDefault setObject:dialCode     forKey:@"countrycode"];
            [userDefault setObject:phone        forKey:@"username"];
            [userDefault setObject:password     forKey:@"password"];
            
            [userDefault synchronize];
		}
		else
		{
			[self showAlert:@"Oops!" message:[_responseObject objectForKey:@"detail"]];
		}
	} ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
	{
		[self showAlert:@"Oops!" message:@"An unknown error occured"];
		[ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
    } ;
	
	[[YYYCommunication sharedManager] SignUp:phonenumber
									password:password
									username:username
										name:name
									birthday:birthday
									  gender:gender
									latitude:[NSString stringWithFormat:@"%f",[YYYAppDelegate sharedDelegate].fLat]
								   longitude:[NSString stringWithFormat:@"%f",[YYYAppDelegate sharedDelegate].fLng]
									   photo:UIImageJPEGRepresentation(imgAvatar,0.2)
								   successed:successed
									 failure:failure];
}

-(IBAction)btResendClick:(id)sender
{
    verificationCode = [self verificationCode];
    [self sendSMS:[NSString stringWithFormat:@"%@%@",dialCode,phone] :verificationCode];
}

-(void)showAlert:(NSString*)title message:(NSString*)message
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
}

-(NSString*)verificationCode
{
	NSString *strCode = @"";
	
	for (int i = 0; i < 5; i++)
	{
		NSNumber * randomNumber = [NSNumber numberWithInt:(arc4random() % 9 + 1)];
		strCode = [NSString stringWithFormat:@"%@%@",strCode,[randomNumber stringValue]];
	}
	
	NSLog(@"%@",strCode);
	
	return strCode;
}

-(void)sendSMS:(NSString*)_phone :(NSString*)_code
{
	NSString *kTwilioSID	= @"AC44b53fdf1c00ccaffa961ef9d9cca3d7";
	NSString *kTwilioSecret = @"e02ac68a2935e03390b90c5a38257c41";
	NSString *kFromNumber	= @"%2B12036543400";
	
	NSString *kToNumber = [_phone stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
	NSString *kMessage = [NSString stringWithFormat:@"Your verification code is %@. From Beehive Support.",_code];
	
	// Build request
	NSString *urlString = [NSString stringWithFormat:@"https://%@:%@@api.twilio.com/2010-04-01/Accounts/%@/SMS/Messages", kTwilioSID, kTwilioSecret, kTwilioSID];
	NSURL *url = [NSURL URLWithString:urlString];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:url];
	[request setHTTPMethod:@"POST"];
	
	// Set up the body
	NSString *bodyString = [NSString stringWithFormat:@"From=%@&To=%@&Body=%@", kFromNumber, kToNumber, kMessage];
	NSData *data = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
	[request setHTTPBody:data];
	NSError *error;
	NSURLResponse *response;
	NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
	// Handle the received data
	if (error)
	{
		NSLog(@"Error: %@", error);
//		[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
	}
	else {
		NSString *receivedString = [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
		NSLog(@"Request sent. %@", receivedString);
        
        [self showAlert:nil message:@"Verification code has been sent to your phone"];
        
//		[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
