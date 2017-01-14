//
//  YYYEditProfileViewController.m
//  MoMo
//
//  Created by King on 11/18/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYEditProfileViewController.h"
#import "MBProgressHUD.h"
#import "YYYCommunication.h"
#import "YYYAppDelegate.h"
#import "YYYChangePassViewController.h"
#import "YYYEditAlbumViewController.h"
#import "YYYStartViewController.h"

@interface YYYEditProfileViewController ()

@end

@implementation YYYEditProfileViewController

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
    
	[txtAboutme     setPlaceholder:@"Write something here"];
    [txtCompany     setPlaceholder:@"Write something here"];
    [txtUniversity  setPlaceholder:@"Write something here"];
    [txtHometown    setPlaceholder:@"Write something here"];
    [txtHobbies     setPlaceholder:@"Write something here"];
    [txtMusic       setPlaceholder:@"Write something here"];
    [txtMovies      setPlaceholder:@"Write something here"];
	[txtBooks       setPlaceholder:@"Write something here"];
    [txtLooking     setPlaceholder:@"Write something here"];
    
	UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
	[self.view addGestureRecognizer:gesture];
	
	[self showProfile];
}

-(void)showProfile
{
	[self.navigationItem    setTitle:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_username"]];
	[txtName                setText:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_name"]];
	[txtUsername            setText:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_username"]];
	[txtAboutme             setText:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_aboutme"]];
	[lblBirthday            setText:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_birthday"]];
	[lblGender              setText:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_gender"]];
    [txtCompany             setText:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_company"]];
    [txtUniversity          setText:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_university"]];
    [txtHometown            setText:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_hometown"]];
    [txtHobbies             setText:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_hobbies"]];
    [txtMusic               setText:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_music"]];
    [txtBooks               setText:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_books"]];
    [txtMovies              setText:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_movies"]];
    [txtLooking             setText:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_looking"]];
}

-(void)handleTap
{
	[self.view endEditing:YES];
}

-(IBAction)btBackClick:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btSaveClick:(id)sender
{
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	void ( ^successed )( id _responseObject ) = ^( id _responseObject )
	{
		[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
		if ([[_responseObject objectForKey:@"success"] isEqualToString:@"1"])
		{
			[YYYCommunication sharedManager].dictInfo = [[NSMutableDictionary alloc] initWithDictionary:[_responseObject objectForKey:@"detail"]];
		}
		else
		{
			[self showAlert:@"Oops!" message:@"Unknown error occured. Please try again"];
		}
	} ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
	{
		[self showAlert:@"Oops!" message:@"An unknown error occured"];
		[ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
    } ;
    
	[[YYYCommunication sharedManager] EditProfile:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"]
										 username:txtUsername.text
											 name:txtName.text
										   gender:lblGender.text
										 birthday:lblBirthday.text
											about:txtAboutme.text
                                          company:txtCompany.text
                                       university:txtUniversity.text
                                         hometown:txtHometown.text
                                          hobbies:txtHobbies.text
                                            music:txtMusic.text
                                            books:txtBooks.text
                                           movies:txtMovies.text
                                          looking:txtLooking.text
                                        successed:successed
                                          failure:failure];
}

-(IBAction)btGenderClick:(id)sender
{
	[self.view endEditing:YES];
	CustomGenderView *view = [CustomGenderView sharedView];
	view.delegate = self;
	[[YYYAppDelegate sharedDelegate].window addSubview:view];
}

-(void)DidGenderViewDissmiss:(int)buttonIndex gender:(NSString *)gender view:(id)view
{
	[view removeFromSuperview];
	if (buttonIndex == 1)
	{
		[lblGender setText:gender];
	}
}

-(IBAction)btBirthdayClick:(id)sender
{
	[self.view endEditing:YES];
	CustomBirthdayView *view = [CustomBirthdayView sharedView];
	view.delegate = self;
	[[YYYAppDelegate sharedDelegate].window addSubview:view];
}

-(void)DidBirthdayViewDissmiss:(int)buttonIndex date:(NSString *)date view:(id)view
{
	[view removeFromSuperview];
	if (buttonIndex == 1)
	{
		[lblBirthday setText:date];
	}
}

-(IBAction)btAlbumClick:(id)sender
{
	YYYEditAlbumViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYEditAlbumViewController"];
	[self.navigationController pushViewController:viewcontroller animated:YES];
}

-(IBAction)btChangePassClick:(id)sender
{
	YYYChangePassViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYChangePassViewController"];
	[self.navigationController pushViewController:viewcontroller animated:YES];
}

-(void)showAlert:(NSString*)title message:(NSString*)message
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
}

-(IBAction)btLogoutClick:(id)sender
{
	YYYStartViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYStartViewController"];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewcontroller];
	
	[YYYAppDelegate sharedDelegate].window.rootViewController = navController;
    [[YYYAppDelegate sharedDelegate] stopTimer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
