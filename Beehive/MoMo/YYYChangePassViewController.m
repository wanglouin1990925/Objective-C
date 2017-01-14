//
//  YYYChangePassViewController.m
//  MoMo
//
//  Created by King on 11/18/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYChangePassViewController.h"
#import "MBProgressHUD.h"
#import "YYYCommunication.h"
#import "YYYAppDelegate.h"

@interface YYYChangePassViewController ()

@end

@implementation YYYChangePassViewController

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
    
}

-(IBAction)btBackClick:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btSaveClick:(id)sender
{
    NSString *curPass = [[YYYCommunication sharedManager].dictInfo objectForKey:@"user_password"];    
	if (![txtCurrent.text isEqualToString:[[YYYAppDelegate sharedDelegate] decryptString:curPass]])
	{
		[self showAlert:@"Oops!" message:@"Incorrect current password"];
		return;
	}
	
	if (txtNew.text.length < 6)
	{
		[self showAlert:@"Oops!" message:@"Password must be at least 6 characters"];
		return;
	}
	
	if (![txtNew.text isEqualToString:txtConfirm.text])
	{
		[self showAlert:@"Oops!" message:@"Incorrect confirm password"];
		return;
	}
	
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	void ( ^successed )( id _responseObject ) = ^( id _responseObject )
	{
		[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
		if ([[_responseObject objectForKey:@"success"] isEqualToString:@"1"])
		{
			[YYYCommunication sharedManager].dictInfo = [[NSMutableDictionary alloc] initWithDictionary:[_responseObject objectForKey:@"detail"]];
			[txtNew		setText:@""];
			[txtCurrent setText:@""];
			[txtConfirm setText:@""];
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
    
	[[YYYCommunication sharedManager] ChangePassword:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"]
											password:txtConfirm.text
										   successed:successed
											 failure:failure];
	
	[self.navigationController popViewControllerAnimated:YES];
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
