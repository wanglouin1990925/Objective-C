//
//  YYYEditAlbumViewController.m
//  MoMo
//
//  Created by King on 11/18/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYEditAlbumViewController.h"
#import "UIButton+AFNetworking.h"
#import "YYYCommunication.h"
#import "MBProgressHUD.h"

@interface YYYEditAlbumViewController ()

@end

@implementation YYYEditAlbumViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	nSelected = -1;
	[self showPhotos];
	
    // Do any additional setup after loading the view.
}

-(void)showPhotos
{
	for (int i = 0; i < [[YYYCommunication sharedManager].lstPhoto count]; i++)
	{
		UIButton *btPhoto = [[UIButton alloc] initWithFrame:CGRectMake(8 + 78*(i%4), 16 + 78 *(i/4), 70, 70)];
		[btPhoto addTarget:self action:@selector(editPhoto:) forControlEvents:UIControlEventTouchUpInside];
		[btPhoto setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[[[YYYCommunication sharedManager].lstPhoto objectAtIndex:i] objectForKey:@"photo"]]]];
		btPhoto.layer.cornerRadius = 10;
		btPhoto.clipsToBounds = YES;
		btPhoto.tag = 100 + [[[[YYYCommunication sharedManager].lstPhoto objectAtIndex:i] objectForKey:@"id"] intValue];
		[self.view addSubview:btPhoto];
	}
}

-(IBAction)editPhoto:(id)sender
{
	nSelected = (int)[sender tag] - 100;
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Edit this Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Remove" otherButtonTitles:@"From Camera",@"From Library", nil];
	[sheet showInView:self.view];
}

-(IBAction)btAddClick:(id)sender
{
	nSelected = -1;
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Add a New Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From Camera",@"From Library", nil];
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
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	void ( ^successed )( id _responseObject ) = ^( id _responseObject )
	{
		[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
		if ([[_responseObject objectForKey:@"success"] isEqualToString:@"1"])
		{
			[YYYCommunication sharedManager].lstPhoto = [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"photoarray"]];
			[self showPhotos];
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
    
	[[YYYCommunication sharedManager] UploadPhoto:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"]
										  photoid:[NSString stringWithFormat:@"%d",nSelected]
											photo:UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerEditedImage], 0.2f)
										successed:successed
										  failure:failure];
	
	
	[picker dismissViewControllerAnimated:YES completion:nil];
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

-(IBAction)btBackClick:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

@end
