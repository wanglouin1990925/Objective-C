//
//  YYYCreateGroupViewController.m
//  MoMo
//
//  Created by King on 11/18/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYCreateGroupViewController.h"
#import "YYYPlacesViewController.h"
#import "YYYAppDelegate.h"
#import "MBProgressHUD.h"
#import "YYYCommunication.h"

#define FOURSQUARE_CLIENT_ID		@"335ZQLFOJ5GADDXW2DZRDXQABULTCZEP4T5Q5YVTJRMD4ZT1"
#define FOURSQUARE_CLIENT_SECRET	@"WRIFF0X32RG1FELQM4KMOKM2JTZH10TSXBE5A4LMAJWD4WVZ"

@interface YYYCreateGroupViewController ()

@end

@implementation YYYCreateGroupViewController

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
	
	[txtAbout setPlaceholder:@"Write something here."];
	
	UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
	[self.view addGestureRecognizer:gesture];
}

-(void)handleTap
{
	[self.view endEditing:YES];
}

-(IBAction)btPhotoClick:(id)sender
{
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Choose a Cover Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From Camera",@"From Library", nil];
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
	[btPhoto setImage:[info objectForKey:UIImagePickerControllerEditedImage] forState:UIControlStateNormal];
	[picker dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)btPlaceClick:(id)sender
{
	YYYPlacesViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYPlacesViewController"];
	viewcontroller.delegate = self;
	[self.navigationController pushViewController:viewcontroller animated:YES];
}

-(void)DidPlaceSelected:(NSDictionary *)_dictPlace
{
	dictPlace = _dictPlace;
	[lblPlace setText:[dictPlace objectForKey:@"name"]];
}

-(IBAction)btBackClick:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btDoneClick:(id)sender
{
	if (txtGroupName.text.length < 1)
	{
		[self showAlert:@"Oops!" message:@"Please input group name"];
		return;
	}
	if ([lblPlace.text isEqualToString:@"Choose Place"])
	{
		[self showAlert:@"Oops!" message:@"Please choose a plce"];
	}
	if (btPhoto.currentImage == [UIImage imageNamed:@"integrated_webcam-50.png"])
	{
		[self showAlert:@"Oops!" message:@"Upload your photo"];
		return;
	}
	if (txtAbout.text.length < 1)
	{
		[self showAlert:@"Oops!" message:@"Please input about group"];
		return;
	}
	
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	void ( ^successed )( id _responseObject ) = ^( id _responseObject )
	{
		[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
		if ([[_responseObject objectForKey:@"success"] isEqualToString:@"1"])
		{
			[YYYCommunication sharedManager].lstGroup = [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"detail"]];
			[self showAlert:@"Success" message:@"Group has been created successfully!"];
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
    
	[[YYYCommunication sharedManager] CreateGroup:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"]
											 name:txtGroupName.text
											about:txtAbout.text
											place:lblPlace.text
										 latitude:[[[dictPlace objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"]
										longitude:[[[dictPlace objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"]
											photo:UIImageJPEGRepresentation(btPhoto.currentImage, 0.2f)
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
