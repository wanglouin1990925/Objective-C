//
//  YYYGroupProfileViewController.m
//  MoMo
//
//  Created by Wang MeiHua on 11/6/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYGroupProfileViewController.h"
#import "YYYCommunication.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"
#import "MBProgressHUD.h"
#import "YYYUserProfileViewController.h"
#import "YYYAppDelegate.h"
#import "YYYGroupMessageViewController.h"

@interface YYYGroupProfileViewController ()

@end

@implementation YYYGroupProfileViewController

@synthesize dictInfo;
@synthesize lstPhotos;
@synthesize lstUsers;

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
	
	lstMemberID = [[NSMutableArray alloc] init];
	[self showProfile];
	
    // Do any additional setup after loading the view.
}

-(void)showProfile
{
	for (UIView *view in scvPhoto.subviews)
	{
		if ([view isKindOfClass:[UIButton class]])
		{
			[view removeFromSuperview];
		}
	}
	
	for (UIView *view in scvMembers.subviews)
	{
		if ([view isKindOfClass:[UIButton class]])
		{
			[view removeFromSuperview];
		}
	}
	
	[self.navigationItem setTitle:[dictInfo objectForKey:@"title"]];
	
	[imvAvatar setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[dictInfo objectForKey:@"avatar"]]]];
	
	
	for (int i = 0; i < [lstPhotos count]; i++)
	{
		UIButton *btPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
		[btPhoto setFrame:CGRectMake(8 + 78 * (i%4), 45 + 78 * (i/4), 70, 70)];
		[btPhoto setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[[lstPhotos objectAtIndex:i] objectForKey:@"photo"]]]];
		btPhoto.layer.cornerRadius = 10.0f;
		btPhoto.clipsToBounds = YES;
		btPhoto.tag = 2000 + i;
		[btPhoto addTarget:self action:@selector(btSinglePhotoClicked:) forControlEvents:UIControlEventTouchUpInside];
		[scvPhoto addSubview:btPhoto];
	}

	//Layout
	
	[lblAbout setText:[dictInfo objectForKey:@"about"]];
	CGRect labelRect = [[lblAbout text] boundingRectWithSize:CGSizeMake(300, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [lblAbout font]} context:nil];
	
	CGRect rt = vwAbout.frame;
	rt.size.height = 45 + labelRect.size.height + 10 + 5;
	vwAbout.frame = rt;
	
	rt = vwMember.frame;
	rt.origin.y = vwAbout.frame.origin.y + vwAbout.frame.size.height;
	vwMember.frame = rt;
	
	rt = vwLocation.frame;
	rt.origin.y = vwMember.frame.origin.y + vwMember.frame.size.height;
	vwLocation.frame = rt;
	
	rt = vwOwner.frame;
	rt.origin.y = vwLocation.frame.origin.y + vwLocation.frame.size.height;
	vwOwner.frame = rt;
	
	//Members
	[lblMembers setText:[NSString stringWithFormat:@"  MEMBERS (%d)",(int)[lstUsers count]]];
	for (int i = 0; i < [lstUsers count]; i++)
	{
		UIButton *btUser = [UIButton buttonWithType:UIButtonTypeCustom];
		[btUser setFrame:CGRectMake(13 + 58*i, 15, 50, 50)];
        
        NSString *avatarURL = [[lstUsers objectAtIndex:i] objectForKey:@"user_avatar"];
        NSString *facebookID = [[lstUsers objectAtIndex:i] objectForKey:@"user_facebookid"];
        
        if ([avatarURL isEqualToString:@""])
        {
            avatarURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",facebookID];
        }
        else
        {
            avatarURL = [NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[[lstUsers objectAtIndex:i] objectForKey:@"user_avatar"]];
        }
        
		[btUser setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:avatarURL]];
        
		btUser.layer.cornerRadius = 7.0f;
		btUser.clipsToBounds = YES;
		btUser.tag = 1000 + i;
		[btUser addTarget:self action:@selector(btUserClick:) forControlEvents:UIControlEventTouchUpInside];
		[scvMembers addSubview:btUser];
	}
	[scvMembers setContentSize:CGSizeMake(13 + 58 * [lstUsers count], 80)];
	
	//Location
	[lblLocation setText:[dictInfo objectForKey:@"location"]];
	
	//Owner
	[lblOwner setText:[[lstUsers objectAtIndex:0] objectForKey:@"user_name"]];
    
    NSString *avatarURL = [[lstUsers objectAtIndex:0] objectForKey:@"user_avatar"];
    NSString *facebookID = [[lstUsers objectAtIndex:0] objectForKey:@"user_facebookid"];
    
    if ([avatarURL isEqualToString:@""])
    {
        avatarURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",facebookID];
    }
    else
    {
        avatarURL = [NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[[lstUsers objectAtIndex:0] objectForKey:@"user_avatar"]];
    }
    
	[imvOwner setImageWithURL:[NSURL URLWithString:avatarURL]];
    
	imvOwner.layer.cornerRadius = 7.0f;
	imvOwner.clipsToBounds = YES;
	
	[scvContent setContentSize:CGSizeMake(320, vwOwner.frame.origin.y + vwOwner.frame.size.height)];
	
	[vwJoin setHidden:YES];
	[vwLeave setHidden:YES];
	[vwChat setHidden:YES];
	
	if ([[dictInfo objectForKey:@"createrid"] intValue] != [[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"] intValue])
	{
		[lstMemberID removeAllObjects];
		
		for (NSDictionary *dict in lstUsers)
		{
			[lstMemberID addObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"user_id"]]];
		}
		
		if ([lstMemberID containsObject:[NSString stringWithFormat:@"%@",[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"]]])
		{
			[vwLeave setHidden:NO];
		}
		else
		{
			[vwJoin setHidden:NO];
		}
	}
	else
	{
		[vwChat setHidden:NO];
	}
}

-(IBAction)btChatClick:(id)sender
{
	YYYGroupMessageViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYGroupMessageViewController"];
	viewcontroller.dictGroup	= dictInfo;
	viewcontroller.lstMembers	= lstUsers;
	[self.navigationController pushViewController:viewcontroller animated:YES];
	
}

-(IBAction)btJoinClicked:(id)sender
{
	[MBProgressHUD showHUDAddedTo:[YYYAppDelegate sharedDelegate].window animated:YES];
	
	void ( ^successed )( id _responseObject ) = ^( id _responseObject )
	{
		[MBProgressHUD hideAllHUDsForView:[YYYAppDelegate sharedDelegate].window animated:YES];
		
		if ([[_responseObject objectForKey:@"success"] isEqualToString:@"1"])
		{
            [self showAlert:nil message:@"Request to join the group has been sent"];
		}
		else
		{
			[self showAlert:@"Failed" message:@"Failed to request to join the group"];
		}
	} ;
	
	void ( ^failure )( NSError* _error ) = ^( NSError* _error )
	{
		[MBProgressHUD hideAllHUDsForView:[YYYAppDelegate sharedDelegate].window animated:YES];
	} ;
	
	[[YYYCommunication sharedManager] JoinGroup:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"]
										groupid:[dictInfo objectForKey:@"id"]
									  successed:successed
										failure:failure];
}

-(IBAction)btLeaveClicked:(id)sender
{
	[MBProgressHUD showHUDAddedTo:[YYYAppDelegate sharedDelegate].window animated:YES];
	
	void ( ^successed )( id _responseObject ) = ^( id _responseObject )
	{
		[MBProgressHUD hideAllHUDsForView:[YYYAppDelegate sharedDelegate].window animated:YES];
		
		if ([[_responseObject objectForKey:@"success"] isEqualToString:@"1"])
		{
			int index = -1;
			for (int i = 0; i < [lstUsers count]; i++)
			{
				NSDictionary *dict  = [lstUsers objectAtIndex:i];
				if ([[dict objectForKey:@"user_id"] intValue] == [[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"] intValue])
				{
					index = i;
					break;
				}
			}
			
			if (index != -1)
			{
				[lstUsers removeObjectAtIndex:index];
				[self showProfile];
			}
			
			index = -1;
			for (int i = 0; i < [[YYYCommunication sharedManager].lstGroup count]; i++)
			{
				NSDictionary *dict  = [[YYYCommunication sharedManager].lstGroup objectAtIndex:i];
				if ([[dict objectForKey:@"id"] intValue] == [[dictInfo objectForKey:@"id"] intValue])
				{
					index = i;
					break;
				}
			}
			
			if (index != -1)
				[[YYYCommunication sharedManager].lstGroup removeObjectAtIndex:index];
		}
		else
		{
			
		}
	} ;
	
	void ( ^failure )( NSError* _error ) = ^( NSError* _error )
	{
		[MBProgressHUD hideAllHUDsForView:[YYYAppDelegate sharedDelegate].window animated:YES];
	} ;
	
	[[YYYCommunication sharedManager] LeaveGroup:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"]
										 groupid:[dictInfo objectForKey:@"id"]
									   successed:successed
										 failure:failure];
}

-(IBAction)btSinglePhotoClicked:(id)sender
{
	CustomPhotoLargeView *view = [CustomPhotoLargeView sharedView];
	[view setFrame:[YYYAppDelegate sharedDelegate].window.frame];
	view.delegate = self;
	[view initWithData:lstPhotos];
	[view setCurrentPage:(int)[sender tag] - 2000];
	[[YYYAppDelegate sharedDelegate].window addSubview:view];
}

-(void)DidBackClick:(id)view
{
	[view removeFromSuperview];
}

-(IBAction)btUserClick:(id)sender
{
	[self gotoUserProfile:[[lstUsers objectAtIndex:[sender tag] - 1000] objectForKey:@"user_id"]];
}

-(IBAction)btOwnerClicked:(id)sender
{
	[self gotoUserProfile:[dictInfo objectForKey:@"createrid"]];
}

-(void)gotoUserProfile:(NSString*)userID
{
	[MBProgressHUD showHUDAddedTo:[YYYAppDelegate sharedDelegate].window animated:YES];
	
	void ( ^successed )( id _responseObject ) = ^( id _responseObject )
	{
		[MBProgressHUD hideAllHUDsForView:[YYYAppDelegate sharedDelegate].window animated:YES];
		
		if ([[_responseObject objectForKey:@"success"] isEqualToString:@"1"])
		{
			YYYUserProfileViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYUserProfileViewController"];
			
			viewcontroller.dictInfo = [[NSDictionary alloc] initWithDictionary:[_responseObject objectForKey:@"detail"]];
			viewcontroller.lstPhoto = [[NSArray alloc] initWithArray:[_responseObject objectForKey:@"photoarray"]];
			viewcontroller.lstGroup = [[NSArray alloc] initWithArray:[_responseObject objectForKey:@"grouparray"]];
			
			[self.navigationController pushViewController:viewcontroller animated:YES];
		}
		else
		{
			
		}
	} ;
	
	void ( ^failure )( NSError* _error ) = ^( NSError* _error )
	{
		[MBProgressHUD hideAllHUDsForView:[YYYAppDelegate sharedDelegate].window animated:YES];
	} ;
	
	[[YYYCommunication sharedManager] LoadUserProfile:userID
											successed:successed
											  failure:failure];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (scrollView.contentOffset.y >= 0)
	{
		[vwProfile setFrame:CGRectMake(0, 0, 320, 180)];
	}
	else
	{
		[vwProfile setFrame:CGRectMake(0, scrollView.contentOffset.y, 320, 180 - scrollView.contentOffset.y)];
	}
}

-(IBAction)btBackClick:(id)sender
{
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
