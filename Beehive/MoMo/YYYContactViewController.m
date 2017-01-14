//
//  YYYContactViewController.m
//  MoMo
//
//  Created by Wang MeiHua on 11/6/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYContactViewController.h"
#import "CustomTableViewHeader.h"
#import "YYYGroupProfileViewController.h"
#import "YYYUserProfileViewController.h"
#import "YYYCommunication.h"
#import "UIImageView+AFNetworking.h"
#import <CoreLocation/CoreLocation.h>
#import "YYYAppDelegate.h"
#import "MBProgressHUD.h"
#import "YYYSelfGroupProfileViewController.h"

@interface YYYContactViewController ()

@end

@implementation YYYContactViewController

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
	
	[tblGroup setHidden:YES];
	[tblBlock setHidden:YES];
    
    topRefresh1 = [[ODRefreshControl alloc] initInScrollView:tblBlock];
    [topRefresh1 addTarget:self action:@selector(loadUserProfile) forControlEvents:UIControlEventValueChanged];
    
    topRefresh2 = [[ODRefreshControl alloc] initInScrollView:tblFriend];
    [topRefresh2 addTarget:self action:@selector(loadUserProfile) forControlEvents:UIControlEventValueChanged];
    
    topRefresh3 = [[ODRefreshControl alloc] initInScrollView:tblGroup];
    [topRefresh3 addTarget:self action:@selector(loadUserProfile) forControlEvents:UIControlEventValueChanged];
	
	lstCreated = [[NSMutableArray alloc] init];
	lstJoined = [[NSMutableArray alloc] init];
	lstRequest = [[NSMutableArray alloc] init];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData:) name:@"INCOMEMESSAGE" object:nil];
	
    // Do any additional setup after loading the view.
}

-(void)loadUserProfile
{
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        [topRefresh1 endRefreshing];
        [topRefresh2 endRefreshing];
        [topRefresh3 endRefreshing];
        
        if ([[_responseObject objectForKey:@"success"] isEqualToString:@"1"])
        {
            [YYYCommunication sharedManager].dictInfo	= [[NSMutableDictionary alloc] initWithDictionary:[_responseObject objectForKey:@"detail"]];
            [YYYCommunication sharedManager].lstPhoto	= [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"photoarray"]];
            [YYYCommunication sharedManager].lstGroup	= [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"grouparray"]];
            [YYYCommunication sharedManager].lstFriend	= [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"friendarray"]];
            [YYYCommunication sharedManager].lstBlock	= [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"blockarray"]];
            
            [self reloadData];
        }
        else
        {
            
        }
    } ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
    {
        [topRefresh1 endRefreshing];
        [topRefresh2 endRefreshing];
        [topRefresh3 endRefreshing];
    } ;
    
    [[YYYCommunication sharedManager] Login:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_phone"]
                                   password:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_password"]
                                   latitude:[NSString stringWithFormat:@"%f",[YYYAppDelegate sharedDelegate].fLat]
                                  longitude:[NSString stringWithFormat:@"%f",[YYYAppDelegate sharedDelegate].fLng]
                                  successed:successed
                                    failure:failure];
}

-(void)loadData:(NSNotification*)notif
{
	if ([lstRequest count] != [[notif.userInfo objectForKey:@"requests"] count])
	{
		[lstRequest removeAllObjects];
		for (NSDictionary *dict in [notif.userInfo objectForKey:@"requests"])
		{
			[lstRequest addObject:dict];
		}
		
		[tblGroup reloadData];
	}
	
	if (([lstCreated count] + [lstJoined count]) != [[notif.userInfo objectForKey:@"groups"] count])
	{
		[YYYCommunication sharedManager].lstGroup	= [[NSMutableArray alloc] initWithArray:[notif.userInfo objectForKey:@"groups"]];
		[self reloadData];
	}
}

-(void)reloadData
{
	[lstJoined removeAllObjects];
	[lstCreated removeAllObjects];
	
    
    
	for (NSDictionary *dict in [YYYCommunication sharedManager].lstGroup)
	{
		if ([[dict objectForKey:@"createrid"] intValue] == [[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"] intValue])
		{
			[lstCreated addObject:dict];
		}
		else
		{
			[lstJoined addObject:dict];
		}
	}
	
	[tblFriend reloadData];
	[tblGroup reloadData];
	[tblBlock reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (tableView == tblGroup)
	{
		if (section == 0)
		{
			return [lstCreated count];
		}
		else if (section == 1)
		{
			return [lstJoined count];
		}
		else
		{
			return 0;
		}
	}
	else if (tableView == tblFriend)
	{
		return [[YYYCommunication sharedManager].lstFriend count];
	}
	else if (tableView == tblBlock)
	{
		return [[YYYCommunication sharedManager].lstBlock count];
	}
	else
	{
		return 0;
	}
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (tableView == tblGroup)
		return 2;
	else if (tableView == tblFriend)
		return 1;
	else if (tableView == tblBlock)
		return 1;
	else
		return 0;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (tableView == tblGroup)
	{
		if (section == 0)
			return @"Created";
		else if (section == 1)
			return @"Joined";
		else
			return @"";
	}
	else
	{
		return @"";
	}
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView == tblGroup)
	{
		static NSString *identifer = @"GroupCell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
		
		NSDictionary *dictGroup = nil;
		
		UILabel *lblMark = (UILabel*)[cell viewWithTag:104];
		[lblMark setHidden:YES];
		
		if (indexPath.section == 0)
		{
			dictGroup = [lstCreated objectAtIndex:indexPath.row];
			
			int nRequestCount = 0;
			for (NSDictionary *dict in lstRequest)
			{
				if ([[dict objectForKey:@"groupid"] intValue] == [[dictGroup objectForKey:@"id"] intValue])
				{
					nRequestCount++;
				}
			}
			
			if (nRequestCount)
				[lblMark setHidden:NO];
		}
		else
		{
			dictGroup = [lstJoined objectAtIndex:indexPath.row];
		}
		
		UIImageView *imvAvatar = (UIImageView*)[cell viewWithTag:100];
		imvAvatar.layer.cornerRadius = 10.0f;
		imvAvatar.clipsToBounds = YES;
		[imvAvatar setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[dictGroup objectForKey:@"avatar"]]]];
		
		UILabel *lblGroupTitle = (UILabel*)[cell viewWithTag:101];
		[lblGroupTitle setText:[dictGroup objectForKey:@"title"]];
		
		UILabel *lblInfo = (UILabel*)[cell viewWithTag:102];
		CLLocation *location1 = [[CLLocation alloc] initWithLatitude:[YYYAppDelegate sharedDelegate].fLat longitude:[YYYAppDelegate sharedDelegate].fLng];
		CLLocation *location2 = [[CLLocation alloc] initWithLatitude:[[dictGroup objectForKey:@"latitude"] floatValue] longitude:[[dictGroup objectForKey:@"longitude"] floatValue]];
		
        float fDistance = [location1 distanceFromLocation:location2]/1000;
        
        NSLocale *locale = [NSLocale currentLocale];
        BOOL isMetric = [[locale objectForKey:NSLocaleUsesMetricSystem] boolValue];
        if (isMetric)
        {
            [lblInfo setText:[NSString stringWithFormat:@"%.2fkm",fDistance]];
        }
        else
        {
            [lblInfo setText:[NSString stringWithFormat:@"%.2fmi",fDistance * 0.621371]];
        }
		
		UILabel *lblAbout = (UILabel*)[cell viewWithTag:103];
		[lblAbout setText:[dictGroup objectForKey:@"about"]];
		
		return cell;
	}
	else if (tableView == tblBlock)
	{
		static NSString *identifer = @"UserCell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
		
		NSDictionary *dict = [[YYYCommunication sharedManager].lstBlock objectAtIndex:indexPath.row];
		
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
        
		[imvAvatar setImageWithURL:[NSURL URLWithString:avatarURL]];
		
		//Name
		UILabel *lblName = (UILabel*)[cell viewWithTag:101];
		[lblName setText:[dict objectForKey:@"user_name"]];
		
		//Distance
		UILabel *lblDistance = (UILabel*)[cell viewWithTag:102];
		
		CLLocation *location1 = [[CLLocation alloc] initWithLatitude:[YYYAppDelegate sharedDelegate].fLat longitude:[YYYAppDelegate sharedDelegate].fLng];
		CLLocation *location2 = [[CLLocation alloc] initWithLatitude:[[dict objectForKey:@"user_latitude"] floatValue] longitude:[[dict objectForKey:@"user_longitude"] floatValue]];
		float fDistance = [location1 distanceFromLocation:location2]/1000;

        NSLocale *locale = [NSLocale currentLocale];
        BOOL isMetric = [[locale objectForKey:NSLocaleUsesMetricSystem] boolValue];
        if (isMetric)
        {
            [lblDistance setText:[NSString stringWithFormat:@"%.2fkm",fDistance]];
        }
        else
        {
            [lblDistance setText:[NSString stringWithFormat:@"%.2fmi",fDistance * 0.621371]];
        }
		
		//About Me
		UILabel *lblAboutme = (UILabel*)[cell viewWithTag:103];
		[lblAboutme setText:[dict objectForKey:@"user_aboutme"]];
		
		return cell;
	}
	else if (tableView == tblFriend)
	{
		static NSString *identifer = @"UserCell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
		
		NSDictionary *dict = [[YYYCommunication sharedManager].lstFriend objectAtIndex:indexPath.row];
		
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
        
		[imvAvatar setImageWithURL:[NSURL URLWithString:avatarURL]];
		
		//Name
		UILabel *lblName = (UILabel*)[cell viewWithTag:101];
		[lblName setText:[dict objectForKey:@"user_name"]];
		
		//Distance
		UILabel *lblDistance = (UILabel*)[cell viewWithTag:102];
		
		CLLocation *location1 = [[CLLocation alloc] initWithLatitude:[YYYAppDelegate sharedDelegate].fLat longitude:[YYYAppDelegate sharedDelegate].fLng];
		CLLocation *location2 = [[CLLocation alloc] initWithLatitude:[[dict objectForKey:@"user_latitude"] floatValue] longitude:[[dict objectForKey:@"user_longitude"] floatValue]];
		float fDistance = [location1 distanceFromLocation:location2]/1000;
        
        NSLocale *locale = [NSLocale currentLocale];
        BOOL isMetric = [[locale objectForKey:NSLocaleUsesMetricSystem] boolValue];
        if (isMetric)
        {
            [lblDistance setText:[NSString stringWithFormat:@"%.2fkm",fDistance]];
        }
        else
        {
            [lblDistance setText:[NSString stringWithFormat:@"%.2fmi",fDistance * 0.621371]];
        }		
		
		//About Me
		UILabel *lblAboutme = (UILabel*)[cell viewWithTag:103];
		[lblAboutme setText:[dict objectForKey:@"user_aboutme"]];
		
		return cell;
	}
	else
		return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView == tblFriend)
	{
		[self goToUserProfile:[[[YYYCommunication sharedManager].lstFriend objectAtIndex:indexPath.row] objectForKey:@"user_id"]];
	}
	else if (tableView == tblGroup)
	{
		if (indexPath.section == 0)
		{
			[self goToGroupProfile:[[lstCreated objectAtIndex:indexPath.row] objectForKey:@"id"]];
		}
		else
		{
			[self goToGroupProfile:[[lstJoined objectAtIndex:indexPath.row] objectForKey:@"id"]];
		}
	}
	else if (tableView == tblBlock)
	{
		[self goToUserProfile:[[[YYYCommunication sharedManager].lstBlock objectAtIndex:indexPath.row] objectForKey:@"user_id"]];
	}
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

-(IBAction)btSegmentClicked:(id)sender
{
	if (segmentCtl.selectedSegmentIndex == 0)
	{
		[tblFriend setHidden:NO];
		[tblGroup setHidden:YES];
		[tblBlock setHidden:YES];
	}
	else if (segmentCtl.selectedSegmentIndex == 1)
	{
		[tblFriend setHidden:YES];
		[tblGroup setHidden:NO];
		[tblBlock setHidden:YES];
	}
	else if (segmentCtl.selectedSegmentIndex == 2)
	{
		[tblFriend setHidden:YES];
		[tblGroup setHidden:YES];
		[tblBlock setHidden:NO];
	}
}

-(void)goToUserProfile:(NSString*)userID
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

-(void)goToGroupProfile:(NSString*)groupID
{
	[MBProgressHUD showHUDAddedTo:[YYYAppDelegate sharedDelegate].window animated:YES];
	
	void ( ^successed )( id _responseObject ) = ^( id _responseObject )
	{
		[MBProgressHUD hideAllHUDsForView:[YYYAppDelegate sharedDelegate].window animated:YES];
		
		if ([[_responseObject objectForKey:@"success"] isEqualToString:@"1"])
		{
			if ([[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"] intValue] == [[[_responseObject objectForKey:@"detail"] objectForKey:@"createrid"] intValue])
			{
				YYYSelfGroupProfileViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYSelfGroupProfileViewController"];
				
				viewcontroller.dictInfo		= [[NSMutableDictionary alloc] initWithDictionary:[_responseObject objectForKey:@"detail"]];
				viewcontroller.lstUsers		= [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"userarray"]];
				viewcontroller.lstPhotos	= [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"photoarray"]];
				viewcontroller.lstPending	= [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"pending"]];
				
				[self.navigationController pushViewController:viewcontroller animated:YES];
			}
			else
			{
				YYYGroupProfileViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYGroupProfileViewController"];
				
				viewcontroller.dictInfo		= [[NSMutableDictionary alloc] initWithDictionary:[_responseObject objectForKey:@"detail"]];
				viewcontroller.lstUsers		= [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"userarray"]];
				viewcontroller.lstPhotos	= [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"photoarray"]];
				
				[self.navigationController pushViewController:viewcontroller animated:YES];
			}
		}
		else
		{
			
		}
	} ;
	
	void ( ^failure )( NSError* _error ) = ^( NSError* _error )
	{
		[MBProgressHUD hideAllHUDsForView:[YYYAppDelegate sharedDelegate].window animated:YES];
	} ;
	
	[[YYYCommunication sharedManager] LoadGroupProfile:groupID
											 successed:successed
											   failure:failure];
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
