//
//  YYYTrendingViewController.m
//  DND
//
//  Created by Wang MeiHua on 10/14/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYTrendingViewController.h"
#import "TMPhotoQuiltViewCell.h"
#import "ODRefreshControl.h"
#import "UIImageView+AFNetworking.h"
#import <CoreLocation/CoreLocation.h>
#import "YYYAppDelegate.h"

@interface YYYTrendingViewController ()

@end

@implementation YYYTrendingViewController

@synthesize delegate;

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
	
	refreshControl = [[ODRefreshControl alloc] initInScrollView:self.quiltView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
	
	bFirstLoad = YES;
	
	lstWorldUsers = [[NSMutableArray alloc] init];
	lstLocalUsers = [[NSMutableArray alloc] init];
	
	bNearBy = YES;
	[self loadUsers];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingChanged) name:@"RefreshTrending" object:nil];
	// Do any additional setup after loading the view.
}

-(void)settingChanged
{
	[lstLocalUsers removeAllObjects];
	
	CLLocation *location1 = [[CLLocation alloc] initWithLatitude:[[[YYYCommunication sharedManager].me objectForKey:@"user_latitude"] floatValue] longitude:[[[YYYCommunication sharedManager].me objectForKey:@"user_longitude"] floatValue]];
	
	for (NSDictionary *dictUser in lstWorldUsers)
	{
		CLLocation *location2 = [[CLLocation alloc] initWithLatitude:[[dictUser objectForKey:@"user_latitude"] floatValue] longitude:[[dictUser objectForKey:@"user_longitude"] floatValue]];
		
		float fDistance = [location1 distanceFromLocation:location2]/1000;
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		if ([[defaults objectForKey:@"distance"] floatValue] > fDistance)
		{
			[lstLocalUsers addObject:dictUser];
		}
	}
	
	[self.quiltView reloadData];
}

-(void)swhTrendingChanged:(int)nIndex
{
	if (nIndex == 0)
		bNearBy = YES;
	else
		bNearBy = NO;
	
	[self.quiltView reloadData];
}

-(void)loadUsers
{
	if (bFirstLoad)
	{
		bFirstLoad = NO;
		[ MBProgressHUD showHUDAddedTo:self.view animated:YES ];
	}
	
	CLLocation *location1 = [[CLLocation alloc] initWithLatitude:[[[YYYCommunication sharedManager].me objectForKey:@"user_latitude"] floatValue] longitude:[[[YYYCommunication sharedManager].me objectForKey:@"user_longitude"] floatValue]];
	
	void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
		
		[ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
		
		//Stop Refresh
		[refreshControl endRefreshing];
		
		if( [ [ _responseObject objectForKey : @"success" ] isEqualToString : @"1" ] )
		{
			[lstWorldUsers removeAllObjects];
			[lstLocalUsers removeAllObjects];
			
			for (NSDictionary *dictUser in [_responseObject objectForKey:@"detail"])
			{
				[lstWorldUsers addObject:dictUser];
				
				CLLocation *location2 = [[CLLocation alloc] initWithLatitude:[[dictUser objectForKey:@"user_latitude"] floatValue] longitude:[[dictUser objectForKey:@"user_longitude"] floatValue]];
				
				float fDistance = [location1 distanceFromLocation:location2]/1000;
				
				NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
				if ([[defaults objectForKey:@"distance"] floatValue] > fDistance)
				{
					[lstLocalUsers addObject:dictUser];
				}
			}
			
			[self.quiltView reloadData];
		}
		else
		{
			[ self  showAlert:@"Oops!" message:@"An unknown error occured" ] ;
			return ;
		}
	} ;
	
	void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
		// Hide ;
		[ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
		
		//Stop Refresh
		[refreshControl endRefreshing];
		
		// Error ;
		[ self  showAlert:@"Oops!" message:@"An unknown error occured" ] ;
	} ;
	
	[[ YYYCommunication sharedManager ] LoadTrending:[[YYYCommunication sharedManager].me objectForKey:@"user_facebookid"]
											 success:successed
											 failure:failure];
}

-(void)showAlert:(NSString*)title message:(NSString*)message
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
	[self loadUsers];
}

- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView
{
	if (bNearBy)
		return [lstLocalUsers count];
	else
		return [lstWorldUsers count];
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath
{
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"];
    if (!cell)
	{
        cell = [[TMPhotoQuiltViewCell alloc] initWithReuseIdentifier:@"PhotoCell"];
    }
    
	NSDictionary *dictUser;
	
	if (bNearBy)
		dictUser = [lstLocalUsers objectAtIndex:indexPath.row];
	else
		dictUser = [lstWorldUsers objectAtIndex:indexPath.row];
	
    [cell.photoView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",[dictUser objectForKey:@"user_facebookid"]]]];
    cell.titleLabel.text = [NSString stringWithFormat:@"Rating : %.1f",[[dictUser objectForKey:@"rate"] floatValue] * 2];
	cell.detailLabel.text = [NSString stringWithFormat:@"%@ %@",[dictUser objectForKey:@"user_firstname"],[dictUser objectForKey:@"user_lastname"]];
	
    return cell;
}

#pragma mark - TMQuiltViewDelegate

- (NSInteger)quiltViewNumberOfColumns:(TMQuiltView *)quiltView {
    
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft
        || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)
	{
        return 3;
    }
	else
	{
        return 2;
    }
}

- (CGFloat)quiltView:(TMQuiltView *)quiltView heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 1)
	{
		return 130;
	}
	
	return 160;
}

-(void)quiltView:(TMQuiltView *)quiltView didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
	if (bNearBy)
		[delegate DidTrendingUserClicked:[[lstLocalUsers objectAtIndex:indexPath.row] objectForKey:@"user_facebookid"]];
	else
		[delegate DidTrendingUserClicked:[[lstWorldUsers objectAtIndex:indexPath.row] objectForKey:@"user_facebookid"]];
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
