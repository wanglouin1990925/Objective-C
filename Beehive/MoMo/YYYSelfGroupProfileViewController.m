//
//  YYYGroupProfileViewController.m
//  MoMo
//
//  Created by Wang MeiHua on 11/6/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYSelfGroupProfileViewController.h"
#import "YYYCommunication.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"
#import "YYYEditGroupProfileViewController.h"
#import "MBProgressHUD.h"
#import "YYYUserProfileViewController.h"
#import "YYYJoinPendingViewController.h"
#import "YYYGroupMessageViewController.h"

@interface YYYSelfGroupProfileViewController ()

@end

@implementation YYYSelfGroupProfileViewController

@synthesize dictInfo;
@synthesize lstPhotos;
@synthesize lstUsers;
@synthesize lstPending;

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
	
	[self showProfile];
	
    // Do any additional setup after loading the view.
}

-(IBAction)btChatClick:(id)sender
{
	YYYGroupMessageViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYGroupMessageViewController"];
	viewcontroller.dictGroup	= dictInfo;
	viewcontroller.lstMembers	= lstUsers;
	[self.navigationController pushViewController:viewcontroller animated:YES];
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

	int nPos = 0;
	[lblPending setText:[NSString stringWithFormat:@"   PENDING(%d)",(int)[lstPending count]]];
	//Layout
	
	[lblAbout setText:[dictInfo objectForKey:@"about"]];
	CGRect labelRect = [[lblAbout text] boundingRectWithSize:CGSizeMake(300, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [lblAbout font]} context:nil];
	
	CGRect rt = vwAbout.frame;
	rt.size.height = 45 + labelRect.size.height + 10 + 5;
	rt.origin.y = nPos + + rt.origin.y;
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

-(IBAction)btEditClick:(id)sender
{
	YYYEditGroupProfileViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYEditGroupProfileViewController"];
	
	viewcontroller.dictGroup	= [[NSMutableDictionary alloc] initWithDictionary:dictInfo];
	viewcontroller.lstUser		= [[NSMutableArray alloc] initWithArray:lstUsers];
	viewcontroller.lstPhoto		= [[NSMutableArray alloc] initWithArray:lstPhotos];
	viewcontroller.delegate		= self;
	
	[self.navigationController pushViewController:viewcontroller	animated:YES];
}

-(void)DidGroupProfilUpdated:(NSMutableDictionary*)_dictGroup :(NSMutableArray*)_lstUser :(NSMutableArray*)_lstPhoto
{
	dictInfo	= _dictGroup;
	lstPhotos	= _lstPhoto;
	lstUsers	= _lstUser;
	
	[self showProfile];
}

-(IBAction)btPendingClick:(id)sender
{
	if ([lstPending count])
	{
		YYYJoinPendingViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYJoinPendingViewController"];
		viewcontroller.lstPending	= [[NSMutableArray alloc] initWithArray:lstPending];
		viewcontroller.groupID		= [dictInfo objectForKey:@"id"];
		viewcontroller.delegate		= self;
		[self.navigationController pushViewController:viewcontroller animated:YES];
	}
}

-(void)DidJobPendingUpdated:(NSMutableArray *)_lstPending :(NSMutableArray *)_lstNewAccept
{
	lstPending = _lstPending;
	lstUsers = [[NSMutableArray alloc] initWithArray:[lstUsers arrayByAddingObjectsFromArray:_lstNewAccept]];
	[self showProfile];
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
