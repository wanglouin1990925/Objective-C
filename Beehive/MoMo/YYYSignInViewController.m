//
//  YYYSignInViewController.m
//  MoMo
//
//  Created by Wang MeiHua on 11/13/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYSignInViewController.h"
#import "YYYTabbarViewController.h"
#import "YYYAppDelegate.h"
#import "MBProgressHUD.h"
#import "YYYCommunication.h"
#import "YYYForgotViewController.h"

@interface YYYSignInViewController ()
	
@end

@implementation YYYSignInViewController

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
    
	[txtPhone	setText:@""];
	[txtPass	setText:@""];
	
	[txtPhone becomeFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO];
}

-(IBAction)btBackClick:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btDoneClick:(id)sender
{
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	void ( ^successed )( id _responseObject ) = ^( id _responseObject )
	{
		[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
		if ([[_responseObject objectForKey:@"success"] isEqualToString:@"1"])
		{
			[YYYCommunication sharedManager].dictInfo	= [[NSMutableDictionary alloc] initWithDictionary:[_responseObject objectForKey:@"detail"]];
			[YYYCommunication sharedManager].lstPhoto	= [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"photoarray"]];
			[YYYCommunication sharedManager].lstGroup	= [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"grouparray"]];
			[YYYCommunication sharedManager].lstFriend	= [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"friendarray"]];
			[YYYCommunication sharedManager].lstBlock	= [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"blockarray"]];
			
			YYYTabbarViewController *tabController = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYTabbarViewController"];
			[YYYAppDelegate sharedDelegate].window.rootViewController = tabController;
			
			[[YYYAppDelegate sharedDelegate] startTimer];
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
    
	[[YYYCommunication sharedManager] Login:txtPhone.text
								   password:txtPass.text
                                   latitude:[NSString stringWithFormat:@"%f",[YYYAppDelegate sharedDelegate].fLat]
                                  longitude:[NSString stringWithFormat:@"%f",[YYYAppDelegate sharedDelegate].fLng]
								  successed:successed
									failure:failure];
}

-(void)showAlert:(NSString*)title message:(NSString*)message
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
