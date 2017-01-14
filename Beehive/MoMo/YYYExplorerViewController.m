//
//  YYYExplorerViewController.m
//  MoMo
//
//  Created by Wang MeiHua on 10/30/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYExplorerViewController.h"
#import "YYYGroupProfileViewController.h"
#import "YYYCreateGroupViewController.h"
#import "YYYCommunication.h"
#import "YYYAppDelegate.h"
#import "UIImageView+AFNetworking.h"
#import <CoreLocation/CoreLocation.h>
#import <sdwebimage/UIImageView+WebCache.h>
#import "MBProgressHUD.h"

@interface YYYExplorerViewController ()

@end

@implementation YYYExplorerViewController

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

	topRefresh = [[ODRefreshControl alloc] initInScrollView:tableView];
	[topRefresh addTarget:self action:@selector(loadGroups) forControlEvents:UIControlEventValueChanged];
	
	bottomRefresh = [[MNMBottomPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60 tableView:tableView withClient:self];
					 
	lstGroups = [[NSMutableArray alloc] init];
	[self loadGroups];
	
    // Do any additional setup after loading the view.
}

-(void)loadGroups
{
	void ( ^successed )( id _responseObject ) = ^( id _responseObject )
	{
		[topRefresh endRefreshing];
		
		if ([[_responseObject objectForKey:@"success"] isEqualToString:@"1"])
		{
			[lstGroups removeAllObjects];
			
			for (NSDictionary *dict in [_responseObject objectForKey:@"detail"])
			{
				[lstGroups addObject:dict];
			}
			
			[tableView reloadData];
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
    
	[[YYYCommunication sharedManager] LoadGroups:[NSString stringWithFormat:@"%d",0]
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
				[lstGroups addObject:dict];
			}
			
			[tableView reloadData];
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
    
	[[YYYCommunication sharedManager] LoadGroups:[NSString stringWithFormat:@"%d",(int)[lstGroups count]]
										latitude:[NSString stringWithFormat:@"%f",[YYYAppDelegate sharedDelegate].fLat]
									   longitude:[NSString stringWithFormat:@"%f",[YYYAppDelegate sharedDelegate].fLng]
									   successed:successed
										 failure:failure];
}

-(IBAction)btCreateGroup:(id)sender
{
	YYYCreateGroupViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYCreateGroupViewController"];
	[self.navigationController pushViewController:viewcontroller animated:YES];
}


-(NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section
{
	return [lstGroups count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)_tableView
{
	return 1;
}

-(UITableViewCell*)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *identifer = @"GroupCell";
	
	UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifer];
	
	NSDictionary *dictGroup = [lstGroups objectAtIndex:indexPath.row];
	
	UIImageView *imvAvatar = (UIImageView*)[cell viewWithTag:100];
	imvAvatar.layer.cornerRadius = 10.0f;
	imvAvatar.clipsToBounds = YES;
//	[imvAvatar setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[dictGroup objectForKey:@"avatar"]]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
    
    [imvAvatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[dictGroup objectForKey:@"avatar"]]] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
    
	
	UILabel *lblGroupTitle = (UILabel*)[cell viewWithTag:101];
	[lblGroupTitle setText:[dictGroup objectForKey:@"title"]];
	
	UILabel *lblInfo = (UILabel*)[cell viewWithTag:102];
    float fDistanceKm = [[dictGroup objectForKey:@"distance_in_km"] floatValue];
    
    NSLocale *locale = [NSLocale currentLocale];
    BOOL isMetric = [[locale objectForKey:NSLocaleUsesMetricSystem] boolValue];
    if (isMetric)
    {
        [lblInfo setText:[NSString stringWithFormat:@"%.2fkm(%@)",fDistanceKm,[dictGroup objectForKey:@"members"]]];
    }
    else
    {
        [lblInfo setText:[NSString stringWithFormat:@"%.2fmi(%@)",fDistanceKm * 0.621371,[dictGroup objectForKey:@"members"]]];
    }
	
	UILabel *lblAbout = (UILabel*)[cell viewWithTag:103];
	[lblAbout setText:[dictGroup objectForKey:@"about"]];
	
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
			YYYGroupProfileViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYGroupProfileViewController"];
			
			viewcontroller.dictInfo		= [[NSMutableDictionary alloc] initWithDictionary:[_responseObject objectForKey:@"detail"]];
			viewcontroller.lstUsers		= [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"userarray"]];
			viewcontroller.lstPhotos	= [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"photoarray"]];
			
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
    
	[[YYYCommunication sharedManager] LoadGroupProfile:[[lstGroups objectAtIndex:indexPath.row] objectForKey:@"id"]
											 successed:successed
											   failure:failure];
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
