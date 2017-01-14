//
//  YYYEditGroupProfileViewController.m
//  MoMo
//
//  Created by King on 11/20/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYEditGroupProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"
#import "YYYCommunication.h"
#import "MBProgressHUD.h"
#import "YYYGroupMemberViewController.h"

@interface YYYEditGroupProfileViewController ()

@end

@implementation YYYEditGroupProfileViewController

@synthesize dictGroup;
@synthesize lstPhoto;
@synthesize lstUser;

@synthesize delegate;

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
	
	txtAbout.placeholder = @"Write something here.";
	
	btPhoto.layer.cornerRadius = 10.0f;
	btPhoto.clipsToBounds = YES;
	btPhoto.layer.borderWidth = 1.0f;
	btPhoto.layer.borderColor = [[UIColor lightGrayColor] CGColor];
	
	[txtGroupName setText:[dictGroup objectForKey:@"title"]];
	[lblChoosePlace setText:[dictGroup objectForKey:@"location"]];
	[btPhoto setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[dictGroup objectForKey:@"avatar"]]]];
	[txtAbout setText:[dictGroup objectForKey:@"about"]];
}

-(IBAction)btBackClick:(id)sender
{
	[delegate DidGroupProfilUpdated:dictGroup :lstUser :lstPhoto];
	
	int index = -1;
	for (int i = 0; i < [[YYYCommunication sharedManager].lstGroup count]; i++)
	{
		NSDictionary *dict = [[YYYCommunication sharedManager].lstGroup objectAtIndex:i];
		if ([[dictGroup objectForKey:@"id"] intValue] == [[dict objectForKey:@"id"] intValue])
		{
			index = i;
		}
	}
	
	if (index != -1)
		[[YYYCommunication sharedManager].lstGroup replaceObjectAtIndex:index withObject:dictGroup];
	
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btChoosePlaceClick:(id)sender
{
	YYYPlacesViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYPlacesViewController"];
	viewcontroller.delegate = self;
	[self.navigationController pushViewController:viewcontroller animated:YES];
}

#pragma makr PlaceViewDelegate

-(void)DidPlaceSelected:(NSDictionary *)_dictPlace
{
	dictPlace = _dictPlace;
	[lblChoosePlace setText:[dictPlace objectForKey:@"name"]];
}

-(IBAction)btAlbumClick:(id)sender
{
	YYYEditGroupAlbumViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYEditGroupAlbumViewController"];
	viewcontroller.lstPhoto = [[NSMutableArray alloc] initWithArray:lstPhoto];
	viewcontroller.delegate = self;
	viewcontroller.groupID = [dictGroup objectForKey:@"id"];
	[self.navigationController pushViewController:viewcontroller animated:YES];
}

-(void)DidAlbumUpdated:(NSMutableArray *)_lstPhoto
{
	lstPhoto = _lstPhoto;
}

-(IBAction)btDeletGroupClick:(id)sender
{
    [MBProgressHUD showHUDAddedTo:[YYYAppDelegate sharedDelegate].window animated:YES];
    
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        [MBProgressHUD hideAllHUDsForView:[YYYAppDelegate sharedDelegate].window animated:YES];
        
        if ([[_responseObject objectForKey:@"success"] isEqualToString:@"1"])
        {
            int index = -1;
            for (int i = 0; i < [[YYYCommunication sharedManager].lstGroup count]; i++)
            {
                NSDictionary *dict  = [[YYYCommunication sharedManager].lstGroup objectAtIndex:i];
                if ([[dict objectForKey:@"id"] intValue] == [[dictGroup objectForKey:@"id"] intValue])
                {
                    index = i;
                    break;
                }
            }
            
            if (index != -1)
                [[YYYCommunication sharedManager].lstGroup removeObjectAtIndex:index];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            [self showAlert:@"Oops!" message:@"Failed to delete group. Please try again"];
        }
    } ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
    {
        [self showAlert:@"Oops!" message:@"Failed to delete group. Please try again"];
        [MBProgressHUD hideAllHUDsForView:[YYYAppDelegate sharedDelegate].window animated:YES];
    } ;
    
    [[YYYCommunication sharedManager] DeleteGroup:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"]
                                          groupid:[dictGroup objectForKey:@"id"]
                                        successed:successed
                                          failure:failure];
}

-(IBAction)btMembersClick:(id)sender
{
	YYYGroupMemberViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYGroupMemberViewController"];
	viewcontroller.lstMember = [[NSMutableArray alloc] initWithArray:lstUser];
	viewcontroller.delegate = self;
	[self.navigationController pushViewController:viewcontroller animated:YES];
}

-(void)DidMemberUpdated:(NSMutableArray *)lstMember
{
	lstUser = lstMember;
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
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	void ( ^successed )( id _responseObject ) = ^( id _responseObject )
	{
		[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
		if ([[_responseObject objectForKey:@"success"] isEqualToString:@"1"])
		{
			dictGroup = [[NSMutableDictionary alloc] initWithDictionary:[_responseObject objectForKey:@"detail"]];
			[btPhoto setImage:[info objectForKey:UIImagePickerControllerEditedImage] forState:UIControlStateNormal];
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
	
	[[YYYCommunication sharedManager] EditGroupAvatar:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"]
											  groupid:[dictGroup objectForKey:@"id"]
												photo:UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerEditedImage], 0.2f)
											successed:successed
											  failure:failure];
	
	[picker dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)btSaveClick:(id)sender
{
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	void ( ^successed )( id _responseObject ) = ^( id _responseObject )
	{
		[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
		if ([[_responseObject objectForKey:@"success"] isEqualToString:@"1"])
		{
			dictGroup = [[NSMutableDictionary alloc] initWithDictionary:[_responseObject objectForKey:@"detail"]];
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
	
	NSString *latitude	= [dictGroup objectForKey:@"latitude"];
	NSString *longitude = [dictGroup objectForKey:@"longitude"];
	if (dictPlace)
	{
		latitude	= [[[dictPlace objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"];
		longitude	= [[[dictPlace objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"];
	}
	
	[[YYYCommunication sharedManager] EditGroupProfile:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"]
											   groupid:[dictGroup objectForKey:@"id"]
												 title:txtGroupName.text
												 place:lblChoosePlace.text
												 about:txtAbout.text
											  latitude:latitude
											 longitude:longitude
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
