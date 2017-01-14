//
//  YYYSignUpTableViewController.m
//  MoMo
//
//  Created by Wang MeiHua on 11/13/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYSignUpViewController.h"
#import "YYYAppDelegate.h"
#import "YYYTabbarViewController.h"
#import "YYYVerificationViewController.h"

@interface YYYSignUpViewController ()

@end

@implementation YYYSignUpViewController

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
	
	btPhoto.layer.cornerRadius = 10.0f;
	btPhoto.clipsToBounds = YES;
	btPhoto.layer.borderWidth = 1.0f;
	btPhoto.layer.borderColor = [[UIColor lightGrayColor] CGColor];
	
	strCountry = @"United States";
	strDialCode = @"+1";
	[lblCountry setText:[NSString stringWithFormat:@"%@ (%@)",strCountry,strDialCode]];
	
    isPhotoSelected = NO;
    
	//Set Temp Data
//	[txtPhone		setText:@"11111111"];
//	[txtPassword	setText:@"123123"];
//	[txtUsername	setText:@"wang90925"];
//	[btBirthday		setTitle:@"1990-11-18" forState:UIControlStateNormal];
//	[btGender		setTitle:@"Male" forState:UIControlStateNormal];
//	[btPhoto		setImage:[UIImage imageNamed:@"user_temp.jpg"] forState:UIControlStateNormal];
	
	UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
	[self.view addGestureRecognizer:gesture];
}

-(void)handleTap
{
	[self.view endEditing:YES];
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

-(BOOL)checkValidatePhoneNumber:(NSString*)phone
{
	NSCharacterSet *_NumericOnly = [NSCharacterSet decimalDigitCharacterSet];
	NSCharacterSet *myStringSet = [NSCharacterSet characterSetWithCharactersInString:phone];
	
	if ([_NumericOnly isSupersetOfSet: myStringSet])
	{
		return YES;
	}
	
	return NO;
}

-(IBAction)btDoneClick:(id)sender
{
    if (!isPhotoSelected)
    {
        [self showAlert:@"Oops!" message:@"Profile picture required"];
        return;
    }
    
	if (![self checkValidatePhoneNumber:txtPhone.text])
	{
		[self showAlert:@"Oops!" message:@"Wrong phone number"];
		return;
	}
	
	if (txtPassword.text.length < 6)
	{
		[self showAlert:@"Oops!" message:@"Password must be at least 6 characters"];
		return;
	}
	if (txtName.text.length < 1)
	{
		[self showAlert:@"Oops!" message:@"Please input a name"];
		return;
	}
	
	if (txtUsername.text.length < 1)
	{
		[self showAlert:@"Oops!" message:@"Please input a username"];
		return;
	}
	
	if ([btBirthday.currentTitle isEqualToString:@"Birthday"])
	{
		[self showAlert:@"Oops!" message:@"Please select birthday"];
		return;
	}
	
	if ([btGender.currentTitle isEqualToString:@"Gender"])
	{
		[self showAlert:@"Oops!" message:@"Please select gender"];
		return;
	}
	
	YYYVerificationViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYVerificationViewController"];
	viewcontroller.dialCode		= strDialCode;
	viewcontroller.phone		= txtPhone.text;
	viewcontroller.password		= txtPassword.text;
	viewcontroller.imgAvatar	= btPhoto.currentImage;
	viewcontroller.username		= txtUsername.text;
	viewcontroller.gender		= btGender.currentTitle;
	viewcontroller.birthday		= btBirthday.currentTitle;
	viewcontroller.name			= txtName.text;
	[self.navigationController pushViewController:viewcontroller animated:YES];
}

-(IBAction)btPhotoClick:(id)sender
{
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From Camera",@"From Library", nil];
	[sheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
		//Camera
		UIImagePickerController *picker = [[UIImagePickerController alloc] init];
		picker.delegate = self;
		picker.allowsEditing = YES;
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
		[self presentViewController:picker animated:YES completion:NULL];
	}
	else if (buttonIndex == 1)
	{
		//Library
		UIImagePickerController *picker = [[UIImagePickerController alloc] init];
		picker.delegate = self;
		picker.allowsEditing = YES;
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		[self presentViewController:picker animated:YES completion:NULL];
	}
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    isPhotoSelected = YES;
	[btPhoto setImage:[info objectForKey:UIImagePickerControllerEditedImage] forState:UIControlStateNormal];
	[picker dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)btCountryClick:(id)sender
{
	YYYCountryListController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYCountryListController"];
	viewcontroller.delegate = self;
	[self.navigationController pushViewController:viewcontroller animated:YES];
}

-(void)DidCountrySelected:(NSString *)country code:(NSString *)code
{
	[lblCountry setText:[NSString stringWithFormat:@"%@ (%@)",country,code]];
	strCountry = country;
	strDialCode = code;
}

-(IBAction)btGenderClick:(id)sender
{
	[self.view endEditing:YES];
	CustomGenderView *view = [CustomGenderView sharedView];
    [view setFrame:CGRectMake(0, 0, 320, [YYYAppDelegate sharedDelegate].window.screen.bounds.size.height)];
	view.delegate = self;
	[[YYYAppDelegate sharedDelegate].window addSubview:view];
}

-(void)DidGenderViewDissmiss:(int)buttonIndex gender:(NSString *)gender view:(id)view
{
	[view removeFromSuperview];
	if (buttonIndex == 1)
	{
		[btGender setTitle:gender forState:UIControlStateNormal];
	}
}

-(IBAction)btBirthdayClick:(id)sender
{
	[self.view endEditing:YES];
	CustomBirthdayView *view = [CustomBirthdayView sharedView];
    [view setFrame:CGRectMake(0, 0, 320, [YYYAppDelegate sharedDelegate].window.screen.bounds.size.height)];
	view.delegate = self;
	[[YYYAppDelegate sharedDelegate].window addSubview:view];
}

-(void)DidBirthdayViewDissmiss:(int)buttonIndex date:(NSString *)date view:(id)view
{
	[view removeFromSuperview];
	if (buttonIndex == 1)
	{
		[btBirthday setTitle:date forState:UIControlStateNormal];
	}
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
