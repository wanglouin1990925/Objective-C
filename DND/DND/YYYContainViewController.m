//
//  YYYHomeViewController.m
//  DND
//
//  Created by Wang MeiHua on 10/7/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYContainViewController.h"
#import "MBProgressHUD.h"
#import "YYYAppDelegate.h"
#import "YYYUserProfileViewController.h"
#import "YYYCommentViewController.h"

#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import <AVFoundation/AVFoundation.h>
#import "AFHTTPSessionManager.h"
#import "CustomSearchCell.h"
#import "YYYReportViewController.h"

@interface YYYContainViewController ()

@end

@implementation YYYContainViewController

@synthesize strInfo;
@synthesize homeviewcontroller;
@synthesize notificationviewcontroller;
@synthesize settingviewcontroller;
@synthesize profileviewcontroller;
@synthesize trendingviewcontroller;

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
	
	[btHome.titleLabel setFont:[UIFont fontWithName:@"Dosis-Book" size:20.0]];
	[btNotification.titleLabel setFont:[UIFont fontWithName:@"Dosis-Book" size:20.0]];
	[btProfile.titleLabel setFont:[UIFont fontWithName:@"Dosis-Book" size:20.0]];
	[btSetting.titleLabel setFont:[UIFont fontWithName:@"Dosis-Book" size:20.0]];
	
	[scvTopBar setContentSize:CGSizeMake(520, 64)];
	[scvContent setContentSize:CGSizeMake(1280, scvContent.frame.size.height)];
	
	imvIndicator.layer.cornerRadius = 1.0f;
	imvIndicator.clipsToBounds = YES;
	
	homeviewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYHomeViewController"];
	[homeviewcontroller.view setFrame:CGRectMake(0, 44, 320, scvContent.frame.size.height - 40)];
	homeviewcontroller.delegate = self;
	[scvContent addSubview:homeviewcontroller.view];
	
	trendingviewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYTrendingViewController"];
	[trendingviewcontroller.view setFrame:CGRectMake(320, 44, 320, scvContent.frame.size.height - 40)];
	trendingviewcontroller.delegate = self;
	[scvContent addSubview:trendingviewcontroller.view];
	
	notificationviewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYNotificationViewController"];
	[notificationviewcontroller.view setFrame:CGRectMake(640, 0, 320, scvContent.frame.size.height)];
	notificationviewcontroller.delegate = self;
	[scvContent addSubview:notificationviewcontroller.view];
	
	profileviewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYProfileViewController"];
	[profileviewcontroller.view setFrame:CGRectMake(960, 0, 320, scvContent.frame.size.height)];
	profileviewcontroller.delegate = self;
	[scvContent addSubview:profileviewcontroller.view];
	
	vwSegmentBackView = [[UIView alloc] initWithFrame:CGRectMake(320, 0.5, 320, 43.5)];
	foursquareSegmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"Near By", @"World Wide"]];
	
	if ([[[YYYCommunication sharedManager].me objectForKey:@"user_gender"] isEqualToString:@"male"])
	{
		[vwNavBar			setBackgroundColor:COLOR_GUY];
		[vwNavSubBar		setBackgroundColor:COLOR_GUY];
		[scvNavSubBar			setBackgroundColor:COLOR_GUY];
		[vwSegmentBackView	setBackgroundColor:COLOR_GUY];
		foursquareSegmentedControl.titleTextColor = COLOR_GUY;
		foursquareSegmentedControl.segmentIndicatorBackgroundColor =  COLOR_GUY;
	}
	else
	{
		[vwNavBar			setBackgroundColor:COLOR_GIRL];
		[vwNavSubBar		setBackgroundColor:COLOR_GIRL];
		[scvNavSubBar	setBackgroundColor:COLOR_GIRL];
		[vwSegmentBackView setBackgroundColor:COLOR_GIRL];
		foursquareSegmentedControl.titleTextColor = COLOR_GIRL;
		foursquareSegmentedControl.segmentIndicatorBackgroundColor =  COLOR_GIRL;
	}
	
    foursquareSegmentedControl.selectedTitleTextColor = [UIColor whiteColor];
    foursquareSegmentedControl.selectedTitleFont = [UIFont fontWithName:@"Dosis-Book" size:15.0];
	foursquareSegmentedControl.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f];
    foursquareSegmentedControl.borderWidth = 0.0f;
    foursquareSegmentedControl.segmentIndicatorBorderWidth = 0.0f;
    foursquareSegmentedControl.segmentIndicatorInset = 1.0f;
    foursquareSegmentedControl.segmentIndicatorBorderColor = self.view.backgroundColor;
    [foursquareSegmentedControl sizeToFit];
    foursquareSegmentedControl.cornerRadius = CGRectGetHeight(foursquareSegmentedControl.frame) / 2.0f;
    foursquareSegmentedControl.center = CGPointMake(160, 22);
	[foursquareSegmentedControl addTarget:self action:@selector(swhTrendingClicked) forControlEvents:UIControlEventValueChanged];
	
    [vwSegmentBackView addSubview:foursquareSegmentedControl];
	[scvContent addSubview:vwSegmentBackView];
	
	
	lstFilteredFriend = [[NSMutableArray alloc] init];
	lstFriend = [[NSMutableArray alloc] init];
	
	[self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"CustomSearchCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CustomSearchCell"];
	
	[srcBar removeFromSuperview];
	[srcBar setFrame:CGRectMake(0, 0, 320, 44)];
	[scvContent addSubview:srcBar];
	
	[self loadFriend];
	
	// Do any additional setup after loading the view.
}

-(void)swhTrendingClicked
{
	[trendingviewcontroller swhTrendingChanged:foursquareSegmentedControl.selectedSegmentIndex];
}

-(void)loadProfile
{
	
}

-(void)loadFriend
{
	MBProgressHUD *progressView = [MBProgressHUD showHUDAddedTo:[YYYAppDelegate sharedDelegate].window animated:YES];
	[progressView setLabelText:@"Loading"];
	
	NSString *strURL = [NSString stringWithFormat:@"https://graph.facebook.com/v1.0/me/friends?fields=first_name,last_name,gender,birthday&format=json&access_token=%@",[[FBSession activeSession].accessTokenData accessToken]];
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	manager.securityPolicy.allowInvalidCertificates = YES;
	
	[manager GET:strURL parameters:nil success:^(AFHTTPRequestOperation *operation, id _responseObject){
		
		[MBProgressHUD hideAllHUDsForView:[YYYAppDelegate sharedDelegate].window animated:YES];
		
		for (NSDictionary *dict in [_responseObject objectForKey:@"data"])
		{
			[lstFriend addObject:dict];
		}
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *_error) {
		
		[MBProgressHUD hideAllHUDsForView:[YYYAppDelegate sharedDelegate].window animated:YES];
		NSLog(@"%@",_error.description);
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//	if (scrollView == scvTopBar)
//	{
//		if (CGRectContainsPoint(btHome.frame, CGPointMake(scrollView.contentOffset.x, 40)) || CGRectContainsPoint(btHome.frame, CGPointMake(scrollView.contentOffset.x, 40)) || CGRectContainsPoint(btHome.frame, CGPointMake(scrollView.contentOffset.x, 40)) || CGRectContainsPoint(btHome.frame, CGPointMake(scrollView.contentOffset.x, 40)))
//		{
//			[self setIndicatorPos:scrollView.contentOffset.x/130];
//		}
//	}
//	else
//	{
//		if (CGRectContainsPoint(btHome.frame, CGPointMake(scrollView.contentOffset.x, 40)) || CGRectContainsPoint(btHome.frame, CGPointMake(scrollView.contentOffset.x, 40)) || CGRectContainsPoint(btHome.frame, CGPointMake(scrollView.contentOffset.x, 40)) || CGRectContainsPoint(btHome.frame, CGPointMake(scrollView.contentOffset.x, 40)))
//		{
//			[self setIndicatorPos:scvTopBar.contentOffset.x/130];
//		}
//	}
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	if (scrollView == scvTopBar)
	{
		int nPage = (int)scvTopBar.contentOffset.x/130.0f + 0.5f;
		[scvTopBar setContentOffset:CGPointMake(nPage * 130, 0)];
		[scvContent setContentOffset:CGPointMake(nPage * 320, 0)];
	}
	else if (scrollView == scvContent)
	{
		int nPage = (int)scvContent.contentOffset.x/320.0f + 0.5f;
		[scvTopBar setContentOffset:CGPointMake(nPage * 130, 0)];
		[scvContent setContentOffset:CGPointMake(nPage * 320, 0)];
	}
	
//	if (scrollView == scvTopBar)
//	{
//		if (CGRectContainsPoint(btHome.frame, CGPointMake(scrollView.contentOffset.x, 40)) || CGRectContainsPoint(btHome.frame, CGPointMake(scrollView.contentOffset.x, 40)) || CGRectContainsPoint(btHome.frame, CGPointMake(scrollView.contentOffset.x, 40)) || CGRectContainsPoint(btHome.frame, CGPointMake(scrollView.contentOffset.x, 40)))
//		{
//			[self setIndicatorPos:scrollView.contentOffset.x/130];
//		}
//	}
//	else
//	{
//		if (CGRectContainsPoint(btHome.frame, CGPointMake(scrollView.contentOffset.x, 40)) || CGRectContainsPoint(btHome.frame, CGPointMake(scrollView.contentOffset.x, 40)) || CGRectContainsPoint(btHome.frame, CGPointMake(scrollView.contentOffset.x, 40)) || CGRectContainsPoint(btHome.frame, CGPointMake(scrollView.contentOffset.x, 40)))
//		{
//			[self setIndicatorPos:scvTopBar.contentOffset.x/130];
//		}
//	}
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (scrollView == scvTopBar)
	{
		[self.searchDisplayController setActive:NO animated:NO];
		[self addSearchBar];
		
		[scvContent setContentOffset:CGPointMake(scrollView.contentOffset.x*320/130.0f, 0)];
//		[self setIndicatorPos:scrollView.contentOffset.x/130];
	}
	else
	{
		[scvTopBar setContentOffset:CGPointMake(scrollView.contentOffset.x*130/320.0f, 0)];
//		[self setIndicatorPos:scrollView.contentOffset.x/320];
	}
}

-(void)setIndicatorPos:(int)page
{
	CGRect rtHome = CGRectMake(135, 53, 50, 3);
	CGRect rtNotification = CGRectMake(115, 53, 90, 3);
	CGRect rtSetting = CGRectMake(132, 53, 56, 3);
	CGRect rtProfile = CGRectMake(135, 53, 50, 3);
	
	NSMutableArray *lstFrames = [[NSMutableArray alloc] initWithObjects:NSStringFromCGRect(rtHome),NSStringFromCGRect(rtNotification),NSStringFromCGRect(rtSetting),NSStringFromCGRect(rtProfile), nil];
	
	[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
		
		[imvIndicator setFrame:CGRectFromString([lstFrames objectAtIndex:page])];
		
	} completion:^(BOOL finished) {
		
	}];
}

-(IBAction)btNextClick:(id)sender
{
	if (scvTopBar.contentOffset.x > 260)
	{
		YYYSettingViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYSettingViewController"];
		[self.navigationController pushViewController:viewcontroller animated:YES];
		return;
	}
	
	[scvTopBar setContentOffset:CGPointMake(scvTopBar.contentOffset.x + 130, 0) animated:YES];
}

-(IBAction)btPrevClick:(id)sender
{
	if (scvTopBar.contentOffset.x < 130)
		return;
	
	[scvTopBar setContentOffset:CGPointMake(scvTopBar.contentOffset.x - 130, 0) animated:YES];
}

#pragma mark SearchDisplayDelegate

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
	[srcBar removeFromSuperview];
	[srcBar setFrame:CGRectMake(0, 64, 320, 44)];
	[self.view addSubview:srcBar];
	
	srcBar.showsCancelButton = YES;
	isSearching = YES;
	return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
	[self performSelector:@selector(addSearchBar) withObject:nil afterDelay:0.5f];
	return YES;
}

-(void)addSearchBar
{
	[srcBar removeFromSuperview];
	[srcBar setFrame:CGRectMake(0, 0, 320, 44)];
	[scvContent addSubview:srcBar];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	if (searchText.length != 0)
		[self searchFriend:searchText.lowercaseString];
}

-(void)searchFriend:(NSString*)keyword
{
	[lstFilteredFriend removeAllObjects];
	
	for (NSDictionary *dict in lstFriend)
	{
		NSString *strName = [[NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"first_name"],[dict objectForKey:@"last_name"]] lowercaseString];
		if ([strName rangeOfString:keyword].location != NSNotFound )
		{
			[lstFilteredFriend addObject:dict];
		}
	}
	
	[self.searchDisplayController.searchResultsTableView reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[self searchFriend:searchBar.text.lowercaseString];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[searchBar endEditing:NO];
	srcBar.showsCancelButton = NO;
	[self performSelector:@selector(addSearchBar) withObject:nil afterDelay:0.5f];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (isSearching)
	{
		return [lstFilteredFriend count];
	}
	
	return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CustomSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomSearchCell"];
	[cell initData:[lstFilteredFriend objectAtIndex:indexPath.row]];
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	YYYUserProfileViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYUserProfileViewController"];

	viewcontroller.strFBID = [NSString stringWithFormat:@"%@",[[lstFilteredFriend objectAtIndex:indexPath.row] objectForKey:@"id"]];
	viewcontroller.strFBFirstname = [[lstFilteredFriend objectAtIndex:indexPath.row] objectForKey:@"first_name"];
	viewcontroller.strFBLastname = [[lstFilteredFriend objectAtIndex:indexPath.row] objectForKey:@"last_name"];
	viewcontroller.strFBGender = [[lstFilteredFriend objectAtIndex:indexPath.row] objectForKey:@"gender"];
	viewcontroller.strFBAge = [self getAge:[[lstFilteredFriend objectAtIndex:indexPath.row] objectForKey:@"birthday"]];

	[self.navigationController pushViewController:viewcontroller animated:YES];
}

-(NSString *)getAge:(NSString *)date
{
    NSArray *arrayDateData = [date componentsSeparatedByString:@"/"];
    NSString *strAge = @"";
    if([arrayDateData count]>=3){
        
        NSDate *currentDate = [NSDate date];
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate]; // Get necessary date components
        
        int nAge = (int)[components year] - [[arrayDateData objectAtIndex:2] intValue];
        
        strAge = [NSString stringWithFormat:@"%d",nAge - 1];
    }else{
        strAge = @"30";
    }
	
    return strAge;
}

#pragma mark HomeViewDelegate

-(void)DidHomeUserClicked:(NSString *)userIndex
{
	YYYUserProfileViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYUserProfileViewController"];

	viewcontroller.strFBID = userIndex;
	
	[self.navigationController pushViewController:viewcontroller animated:YES];
}


#pragma DidTrendingViewDelegate

-(void)DidTrendingUserClicked:(NSString *)userIndex
{
	YYYUserProfileViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYUserProfileViewController"];

	viewcontroller.strFBID = userIndex;
	
	[self.navigationController pushViewController:viewcontroller animated:YES];
}

#pragma DidNotificationViewDelegate

-(void)DidNotificationUserClicked:(NSString *)userIndex
{
//	YYYUserProfileViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYUserProfileViewController"];
//	viewcontroller.strUserID = userIndex;
//	viewcontroller.strFBID = @"";
//	[self.navigationController pushViewController:viewcontroller animated:YES];
	
	[self performSelectorOnMainThread:@selector(btNextClick:) withObject:nil waitUntilDone:0];
}

#pragma mark ProfileViewDelegate

-(void)DidCommentClicked:(NSString *)rateid commentarray:(NSMutableArray *)lstComment
{
	YYYCommentViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYCommentViewController"];
	viewcontroller.rateid = rateid;
	viewcontroller.lstComment = lstComment;
	viewcontroller.bMyProfile = YES;
	[self.navigationController pushViewController:viewcontroller animated:YES];
}

-(void)DidReportClick:(NSString *)rateid
{
	YYYReportViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYReportViewController"];
	[self.navigationController presentViewController:viewcontroller animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
