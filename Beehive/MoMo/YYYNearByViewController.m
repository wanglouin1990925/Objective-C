//
//  YYYNearByViewController.m
//  MoMo
//
//  Created by Wang MeiHua on 10/30/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYNearByViewController.h"
#import "ODRefreshControl.h"
#import "YYYUserProfileViewController.h"
#import "YYYCommunication.h"
#import "YYYAppDelegate.h"
#import "UIImageView+AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"

@interface YYYNearByViewController ()

@end

@implementation YYYNearByViewController

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
	
	topRefresh = [[ODRefreshControl alloc] initInScrollView:tblUser];
	[topRefresh addTarget:self action:@selector(loadUsers) forControlEvents:UIControlEventValueChanged];
	
	bottomRefresh = [[MNMBottomPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60 tableView:tblUser withClient:self];
	
	lstUsers = [[NSMutableArray alloc] init];
	[self loadUsers];
	
	// Do any additional setup after loading the view.
}

-(void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
	[bottomRefresh relocatePullToRefreshView];
}

-(void)loadUsers
{
	void ( ^successed )( id _responseObject ) = ^( id _responseObject )
	{
		[topRefresh endRefreshing];
		
		if ([[_responseObject objectForKey:@"success"] isEqualToString:@"1"])
		{
			[lstUsers removeAllObjects];
			
			for (NSDictionary *dict in [_responseObject objectForKey:@"detail"])
			{
				[lstUsers addObject:dict];
			}
			
			[tblUser reloadData];
			[bottomRefresh relocatePullToRefreshView];
		}
		else
		{
			
		}
	} ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
	{
		[topRefresh endRefreshing];
    } ;
    
	[[YYYCommunication sharedManager] LoadNearBy:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"]
										  offset:[NSString stringWithFormat:@"%d",0]
										latitude:[NSString stringWithFormat:@"%f",[YYYAppDelegate sharedDelegate].fLat]
									   longitude:[NSString stringWithFormat:@"%f",[YYYAppDelegate sharedDelegate].fLng]
									   successed:successed
										 failure:failure];
}

-(void)loadMore
{
	void ( ^successed )( id _responseObject ) = ^( id _responseObject )
	{
		[bottomRefresh tableViewReloadFinished];
		
		if ([[_responseObject objectForKey:@"success"] isEqualToString:@"1"])
		{
			for (NSDictionary *dict in [_responseObject objectForKey:@"detail"])
			{
				[lstUsers addObject:dict];
			}
			
			[tblUser reloadData];
			[bottomRefresh relocatePullToRefreshView];
		}
		else
		{
			
		}
	} ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
	{
		[bottomRefresh tableViewReloadFinished];
    } ;
    
	[[YYYCommunication sharedManager] LoadNearBy:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"]
										  offset:[NSString stringWithFormat:@"%d",(int)[lstUsers count]]
										latitude:[NSString stringWithFormat:@"%f",[YYYAppDelegate sharedDelegate].fLat]
									   longitude:[NSString stringWithFormat:@"%f",[YYYAppDelegate sharedDelegate].fLng]
									   successed:successed
										 failure:failure];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [lstUsers count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *identifer = @"UserCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
	
	NSDictionary *dict = [lstUsers objectAtIndex:indexPath.row];
	
	//Avatar
	UIImageView *imvAvatar = (UIImageView*)[cell viewWithTag:100];
	imvAvatar.layer.cornerRadius = 10.0f;
	imvAvatar.clipsToBounds = YES;
    
    NSString *avatarURL = [dict objectForKey:@"user_avatar"];
    NSString *facebookID = [dict objectForKey:@"user_facebookid"];
    
    if ([avatarURL isEqualToString:@""])
    {
        avatarURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",facebookID];
    }
    else
    {
        avatarURL = [NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[dict objectForKey:@"user_avatar"]];
    }
    
	[imvAvatar sd_setImageWithURL:[NSURL URLWithString:avatarURL] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
    
	//Name
	UILabel *lblName = (UILabel*)[cell viewWithTag:101];
	[lblName setText:[dict objectForKey:@"user_name"]];
	
    //Distance
    UILabel *lblDistance = (UILabel*)[cell viewWithTag:102];
    float fDistanceKm = [[dict objectForKey:@"distance_in_km"] floatValue];
    
    NSLocale *locale = [NSLocale currentLocale];
    BOOL isMetric = [[locale objectForKey:NSLocaleUsesMetricSystem] boolValue];
    if (isMetric)
    {
        [lblDistance setText:[NSString stringWithFormat:@"%.2fkm | %@",fDistanceKm,[self getDiffString:[[dict objectForKey:@"lastlogin"] intValue]]]];
    }
    else
    {
        [lblDistance setText:[NSString stringWithFormat:@"%.2fmi | %@",fDistanceKm * 0.621371,[self getDiffString:[[dict objectForKey:@"lastlogin"] intValue]]]];
    }
    
	//About Me
	UILabel *lblAboutme = (UILabel*)[cell viewWithTag:103];
	[lblAboutme setText:[dict objectForKey:@"user_aboutme"]];
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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
    
	[[YYYCommunication sharedManager] LoadUserProfile:[[lstUsers objectAtIndex:indexPath.row] objectForKey:@"user_id"]
											successed:successed
											  failure:failure];
}

-(NSString*)getDiffString:(int)diffSec
{
	if (diffSec < 60)
	{
		return [NSString stringWithFormat:@"%ds ago",diffSec];
	}
	else if (diffSec < 60*60)
	{
		return [NSString stringWithFormat:@"%dm ago",diffSec/60];
	}
	else if (diffSec <  60*60*24)
	{
		return [NSString stringWithFormat:@"%dh ago",diffSec/3600];
	}
	else if (diffSec <  60*60*24*30)
	{
		return [NSString stringWithFormat:@"%dd ago",diffSec/86400];
	}
	else
	{
		return [NSString stringWithFormat:@"%dM ago",diffSec/2592000];
	}
	
	return @"";
}

#pragma mark MNMBottomPullRefreshManagerClient

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[bottomRefresh tableViewScrolled];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[bottomRefresh tableViewReleased];
}

-(void)bottomPullToRefreshTriggered:(MNMBottomPullToRefreshManager *)manager
{
	[self loadMore];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
