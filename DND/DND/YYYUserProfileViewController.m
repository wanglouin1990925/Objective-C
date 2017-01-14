//
//  YYYProfileViewController.m
//  DND
//
//  Created by Wang MeiHua on 10/11/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYUserProfileViewController.h"
#import "CustomFeedCell.h"
#import "ODRefreshControl.h"
#import "UIImageView+AFNetworking.h"
#import "YYYAppDelegate.h"
#import "YYYCommunication.h"
#import "YYYAppDelegate.h"
#import "YYYReportViewController.h"

#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import <AVFoundation/AVFoundation.h>
#import "AFHTTPSessionManager.h"
#import "YYYCommentViewController.h"

@interface YYYUserProfileViewController ()

@end

@implementation YYYUserProfileViewController

@synthesize strFBID;
@synthesize strFBFirstname;
@synthesize strFBLastname;
@synthesize strFBAge;
@synthesize strFBGender;

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
	
	refreshControl = [[ODRefreshControl alloc] initInScrollView:tblFeed];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
	
	[self.navigationItem setTitle:@"Profile"];
	
	lstPhoto	= [[NSMutableArray alloc] init];
	lstComment	= [[NSMutableArray alloc] init];
	
	isFirstload = YES;
	
	UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe)];
	swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft || UISwipeGestureRecognizerDirectionRight;
	[tblFeed addGestureRecognizer:swipeGesture];
	
	[self loadProfile];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadProfile) name:@"RefreshUserProfile" object:nil];
	
	// Do any additional setup after loading the view.
}

-(void)handleSwipe
{
	[self.navigationController popViewControllerAnimated:YES];
	[self.navigationController setNavigationBarHidden:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (scrollView == scvPhoto)
	{
		int nPage = scrollView.contentOffset.x/320;
		[pgCtl setCurrentPage:nPage];
	}
	else
	{
		if (scrollView.contentOffset.y >= 0)
		{
			[vwProfile setFrame:CGRectMake(0, -scrollView.contentOffset.y, 320, 200)];
			[vwDummy setFrame:CGRectMake(0, 0, 320, 200)];
		}
		else
		{
			[vwProfile setFrame:CGRectMake(0, 0, 320, 200 - scrollView.contentOffset.y)];
			[vwDummy setFrame:CGRectMake(0, 0, 320, 200 - scrollView.contentOffset.y)];
		}
	}
}

-(void)showProfile:(int)index
{
	if([lstPhoto count] < 1)
		[lstPhoto addObject:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",strFBID]];
	
	[refreshControl endRefreshing];
	
	if (index == 0)
	{
		[lblUsername setText:[NSString stringWithFormat:@"%@ %@",[dictUser objectForKey:@"user_firstname"],[dictUser objectForKey:@"user_lastname"]]];
		[lblScore setText:[NSString stringWithFormat:@"%.1f",fRate * 2]];
		
		[scvPhoto setContentSize:CGSizeMake(320*[lstPhoto count], 200)];
		[pgCtl setNumberOfPages:[lstPhoto count]];
		
		for (UIView *view in scvPhoto.subviews)
		{
			if ([view isKindOfClass:[UIImageView class]])
			{
				[view removeFromSuperview];
			}
		}
		
		for (int i = 0; i < [lstPhoto count]; i++)
		{
			UIImageView *imvPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(320*i, 0, scvPhoto.frame.size.width, scvPhoto.frame.size.height)];
			imvPhoto.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
			[imvPhoto setImageWithURL:[NSURL URLWithString:[lstPhoto objectAtIndex:i]]];
			imvPhoto.contentMode = UIViewContentModeScaleAspectFill;
			[scvPhoto addSubview:imvPhoto];
		}
		
		[tblFeed reloadData];
	}
	else
	{
		[lblUsername setText:[NSString stringWithFormat:@"%@ %@",strFBFirstname,strFBLastname]];
		[lblScore setText:[NSString stringWithFormat:@"%.1f",fRate * 2]];
		
		[scvPhoto setContentSize:CGSizeMake(320*[lstPhoto count], 200)];
		[pgCtl setNumberOfPages:[lstPhoto count]];
		
		for (UIView *view in scvPhoto.subviews)
		{
			if ([view isKindOfClass:[UIImageView class]])
			{
				[view removeFromSuperview];
			}
		}
		
		for (int i = 0; i < [lstPhoto count]; i++)
		{
			UIImageView *imvPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(320*i, 0, scvPhoto.frame.size.width, scvPhoto.frame.size.height)];
			[imvPhoto setImageWithURL:[NSURL URLWithString:[lstPhoto objectAtIndex:i]]];
			imvPhoto.contentMode = UIViewContentModeScaleAspectFill;
			[scvPhoto addSubview:imvPhoto];
		}
		
		[tblFeed reloadData];
	}
}

-(void)loadFriendsPhoto
{
	[lstPhoto removeAllObjects];
	
	MBProgressHUD *progressView = [MBProgressHUD showHUDAddedTo:[YYYAppDelegate sharedDelegate].window animated:YES];
	[progressView setLabelText:@"Loading"];
	
	NSString *strURL = [NSString stringWithFormat:@"https://graph.facebook.com/v1.0/%@/albums?fields=photos.limit(10)&access_token=%@",strFBID,[[FBSession activeSession].accessTokenData accessToken]];
	
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	manager.securityPolicy.allowInvalidCertificates = YES;
	
	[manager GET:strURL parameters:nil success:^(AFHTTPRequestOperation *operation, id _responseObject)
	{
		[MBProgressHUD hideAllHUDsForView:[YYYAppDelegate sharedDelegate].window animated:YES];
		
		for (NSDictionary *dict in [_responseObject objectForKey:@"data"])
		{
			for (NSDictionary *dictPhotos in [[dict objectForKey:@"photos"] objectForKey:@"data"])
			{
				[lstPhoto addObject:[[[dictPhotos objectForKey:@"images"] objectAtIndex:0] objectForKey:@"source"]];
				
				if ([lstPhoto count] >= 10)
				{
					break;
				}
			}
			
			if ([lstPhoto count] >= 10)
			{
				break;
			}
		}
		
		[self showProfile:1];
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *_error) {
		
		[MBProgressHUD hideAllHUDsForView:[YYYAppDelegate sharedDelegate].window animated:YES];
		NSLog(@"%@",_error.description);
		
    }];
}

-(void)loadProfile
{
	if (isFirstload)
	{
		isFirstload = NO;
		[ MBProgressHUD showHUDAddedTo:self.view animated:YES ];
	}
	
	void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
		
		[ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
		
		if( [ [ _responseObject objectForKey : @"success" ] isEqualToString : @"1" ] )
		{
			if ( [ [_responseObject objectForKey:@"existing"] isEqualToString : @"1" ] )
			{
				dictUser = [[NSMutableDictionary alloc] initWithDictionary:[_responseObject objectForKey:@"detail"]];
				lstComment = [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"comment"]];
				fRate = [[_responseObject objectForKey:@"rate"] floatValue];
				
				[lstPhoto	removeAllObjects];
				
				if (![[ dictUser objectForKey:@"user_photo1"] isEqualToString:@""])
					[lstPhoto addObject:[dictUser objectForKey:@"user_photo1"]];
				
				if (![[dictUser objectForKey:@"user_photo2"] isEqualToString:@""])
					[lstPhoto addObject:[dictUser objectForKey:@"user_photo2"]];
				
				if (![[dictUser objectForKey:@"user_photo3"] isEqualToString:@""])
					[lstPhoto addObject:[dictUser objectForKey:@"user_photo3"]];
				
				if (![[dictUser objectForKey:@"user_photo4"] isEqualToString:@""])
					[lstPhoto addObject:[dictUser objectForKey:@"user_photo4"]];
				
				if (![[dictUser objectForKey:@"user_photo5"] isEqualToString:@""])
					[lstPhoto addObject:[dictUser objectForKey:@"user_photo5"]];
				
				if (![[dictUser objectForKey:@"user_photo6"] isEqualToString:@""])
					[lstPhoto addObject:[dictUser objectForKey:@"user_photo6"]];
				
				if (![[dictUser objectForKey:@"user_photo7"] isEqualToString:@""])
					[lstPhoto addObject:[dictUser objectForKey:@"user_photo7"]];
				
				if (![[dictUser objectForKey:@"user_photo8"] isEqualToString:@""])
					[lstPhoto addObject:[dictUser objectForKey:@"user_photo8"]];
				
				if (![[dictUser objectForKey:@"user_photo9"] isEqualToString:@""])
					[lstPhoto addObject:[dictUser objectForKey:@"user_photo9"]];
				
				if (![[dictUser objectForKey:@"user_photo10"] isEqualToString:@""])
					[lstPhoto addObject:[dictUser objectForKey:@"user_photo10"]];
				
				[self showProfile:0];
			}
			else
			{
				lstComment = [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"comment"]];
				fRate = [[_responseObject objectForKey:@"rate"] floatValue];
				
				[self loadFriendsPhoto];
			}
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
		
		// Error ;
		[ self  showAlert:@"Oops!" message:@"An unknown error occured" ] ;
	} ;
	
	[[ YYYCommunication sharedManager ] LoadUserProfile:strFBID
											  successed:successed
												failure:failure];
}

-(void)showAlert:(NSString*)title message:(NSString*)message
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO];
}

-(void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

-(IBAction)btBackClick:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
	[self.navigationController setNavigationBarHidden:YES];
}

-(IBAction)btRateClick:(id)sender
{
	CustomRateMe *view = [CustomRateMe sharedView];
	view.frame = [YYYAppDelegate sharedDelegate].window.frame;
	view.center = [YYYAppDelegate sharedDelegate].window.center;
	[view initUI];
	view.delegate = self;
	[[YYYAppDelegate sharedDelegate].window addSubview:view];
}

-(IBAction)btEyeClick:(id)sender
{
	if (!customPhotoView)
	{
		customPhotoView = [CustomPhotoLargeView sharedView];
		[customPhotoView initWithData:lstPhoto];
		customPhotoView.delegate = self;
	}
	
	customPhotoView.alpha = 0.0;
	[[YYYAppDelegate sharedDelegate].window addSubview:customPhotoView];
	[customPhotoView setCurrentPage:scvPhoto.contentOffset.x/320];
	
	[UIView animateWithDuration:0.5 animations:^{
		customPhotoView.alpha = 1.0f;
	} completion:^(BOOL finished) {
		
	}];
}

#pragma mark CustomRateViewDelegate

-(void)DidSendClicked:(float)star comment:(NSString *)comment nickname:(NSString *)nickname view:(id)view
{
	[view removeFromSuperview];
	
	if (dictUser)
	{
		[self rateExistingUser:star comment:comment nickname:nickname];
	}
	else
	{
		[self rateFBUser:star comment:comment nickname:nickname];
	}
	
}

-(void)rateExistingUser:(float)star comment:(NSString *)comment nickname:(NSString *)nickname
{
	[ MBProgressHUD showHUDAddedTo:self.view animated:YES ];
	
	void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
		
		[ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
		
		if( [ [ _responseObject objectForKey : @"success" ] isEqualToString : @"1" ] )
		{
			fRate = [[_responseObject objectForKey:@"rate"] floatValue];
			lstComment = [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"comment"]];
			
			[lblScore setText:[NSString stringWithFormat:@"%.1f",fRate*2]];
			[tblFeed reloadData];

			NSString *note = [NSString stringWithFormat:@"You have been rated a %.2f stars",fRate*2];
			[[YYYAppDelegate sharedDelegate] sendPushNotification:[dictUser objectForKey:@"user_facebookid"] :note];
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
		
		// Error ;
		[ self  showAlert:@"Oops!" message:@"An unknown error occured" ] ;
	} ;
	
	[[ YYYCommunication sharedManager ] RateUser:[[YYYCommunication sharedManager].me objectForKey:@"user_id"]
									  userfbidto:[dictUser objectForKey:@"user_facebookid"]
										   score:[NSString stringWithFormat:@"%.1f",star]
										 comment:comment
										nickname:nickname
									   successed:successed
										 failure:failure];
}

-(void)rateFBUser:(float)star comment:(NSString *)comment nickname:(NSString *)nickname
{
	[ MBProgressHUD showHUDAddedTo:self.view animated:YES ];
	
	void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
		
		[ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
		
		if( [ [ _responseObject objectForKey : @"success" ] isEqualToString : @"1" ] )
		{
			dictUser = [[NSMutableDictionary alloc] initWithDictionary:[_responseObject objectForKey:@"detail"]];
			lstComment = [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"comment"]];
			fRate = [[_responseObject objectForKey:@"rate"] floatValue];
			
			[lstPhoto	removeAllObjects];
			
			if (![[ dictUser objectForKey:@"user_photo1"] isEqualToString:@""])
				[lstPhoto addObject:[dictUser objectForKey:@"user_photo1"]];
			
			if (![[dictUser objectForKey:@"user_photo2"] isEqualToString:@""])
				[lstPhoto addObject:[dictUser objectForKey:@"user_photo2"]];
			
			if (![[dictUser objectForKey:@"user_photo3"] isEqualToString:@""])
				[lstPhoto addObject:[dictUser objectForKey:@"user_photo3"]];
			
			if (![[dictUser objectForKey:@"user_photo4"] isEqualToString:@""])
				[lstPhoto addObject:[dictUser objectForKey:@"user_photo4"]];
			
			if (![[dictUser objectForKey:@"user_photo5"] isEqualToString:@""])
				[lstPhoto addObject:[dictUser objectForKey:@"user_photo5"]];
			
			if (![[dictUser objectForKey:@"user_photo6"] isEqualToString:@""])
				[lstPhoto addObject:[dictUser objectForKey:@"user_photo6"]];
			
			if (![[dictUser objectForKey:@"user_photo7"] isEqualToString:@""])
				[lstPhoto addObject:[dictUser objectForKey:@"user_photo7"]];
			
			if (![[dictUser objectForKey:@"user_photo8"] isEqualToString:@""])
				[lstPhoto addObject:[dictUser objectForKey:@"user_photo8"]];
			
			if (![[dictUser objectForKey:@"user_photo9"] isEqualToString:@""])
				[lstPhoto addObject:[dictUser objectForKey:@"user_photo9"]];
			
			if (![[dictUser objectForKey:@"user_photo10"] isEqualToString:@""])
				[lstPhoto addObject:[dictUser objectForKey:@"user_photo10"]];
			
			[self showProfile:0];
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
		
		// Error ;
		[ self  showAlert:@"Oops!" message:@"An unknown error occured" ] ;
	} ;
	
	NSMutableArray *lstURL = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
	for (int i = 0; i < [lstPhoto count]; i++)
	{
		[lstURL replaceObjectAtIndex:i withObject:[lstPhoto objectAtIndex:i]];
	}
	
	[[ YYYCommunication sharedManager ] RateFBUser:[[YYYCommunication sharedManager].me objectForKey:@"user_id"]
									  userfbidto:strFBID
										   score:[NSString stringWithFormat:@"%.1f",star]
										 comment:comment
										nickname:nickname
										 firstname:strFBFirstname
										  lastname:strFBLastname
											gender:strFBGender
											   age:strFBAge
										  latitude:@"0"
										 longitude:@"0"
											photo1:[lstURL objectAtIndex:0]
											photo2:[lstURL objectAtIndex:1]
											photo3:[lstURL objectAtIndex:2]
											photo4:[lstURL objectAtIndex:3]
											photo5:[lstURL objectAtIndex:4]
											photo6:[lstURL objectAtIndex:5]
											photo7:[lstURL objectAtIndex:6]
											photo8:[lstURL objectAtIndex:7]
											photo9:[lstURL objectAtIndex:8]
										   photo10:[lstURL objectAtIndex:9]
									   successed:successed
										 failure:failure];
}

-(void)DidCancelClicked:view
{
	[view removeFromSuperview];
}

#pragma mark CustomPhotoLargeViewDelegate

-(void)DidBackClick
{
	[customPhotoView removeFromSuperview];
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
	[self loadProfile];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [lstComment count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGRect labelRect = [[[lstComment objectAtIndex:indexPath.row] objectForKey:@"rat_comment"] boundingRectWithSize:CGSizeMake(235, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0]} context:nil];
	
	int labelHeight = labelRect.size.height;
	
	if (labelHeight < 65)
		labelHeight = 65;
	
	return 37 + labelHeight + 53;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
	static NSString *identifier = @"Cell";
	
	CustomRateCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	
	cell.delegate = self;
	cell.cellIndex = (int)indexPath.row;
	
	float fStar = [[[lstComment objectAtIndex:indexPath.row] objectForKey:@"rat_score"] floatValue] * 2 ;
	
	UILabel *lblStar = (UILabel*)[cell viewWithTag:100];
	[lblStar setText:[NSString stringWithFormat:@"%.1f",fStar]];
	
	UILabel *lblComment = (UILabel*)[cell viewWithTag:101];
	[lblComment setText:[[lstComment objectAtIndex:indexPath.row] objectForKey:@"rat_comment"]];
	
	UILabel *lblNickname = (UILabel*)[cell viewWithTag:110];
	[lblNickname setText:[[lstComment objectAtIndex:indexPath.row] objectForKey:@"rat_nickname"]];
	
	UILabel *lblDate = (UILabel*)[cell viewWithTag:105];
	[lblDate setText:[self getDiffString:[[[lstComment objectAtIndex:indexPath.row] objectForKey:@"timediff"] intValue]]];
	
	int nVotes = [[[lstComment objectAtIndex:indexPath.row] objectForKey:@"rat_upvotes"] intValue] - [[[lstComment objectAtIndex:indexPath.row] objectForKey:@"rat_downvotes"] intValue];
	
	UILabel *lblVote = (UILabel*)[cell viewWithTag:103];
	[lblVote setText:[NSString stringWithFormat:@"%d",nVotes]];
	
	UILabel *lblComments = (UILabel*)[cell viewWithTag:106];
	[lblComments setText:[NSString stringWithFormat:@"%d",(int)[[[lstComment objectAtIndex:indexPath.row] objectForKey:@"commentarray"] count]]];
	
	UIButton *btUpvote		= (UIButton*)[cell viewWithTag:102];
	UIButton *btDownvote	= (UIButton*)[cell viewWithTag:104];
	
	btUpvote.userInteractionEnabled = YES;
	btDownvote.userInteractionEnabled = YES;
	
	btDownvote.selected = NO;
	btUpvote.selected = NO;
	
	if ([[[lstComment objectAtIndex:indexPath.row] objectForKey:@"voteuserarray"] containsObject:[[YYYCommunication sharedManager].me objectForKey:@"user_id"]])
	{
		btDownvote.userInteractionEnabled = NO;
		btUpvote.userInteractionEnabled = NO;
		
		btDownvote.selected = YES;
		btUpvote.selected = YES;
	}
	
	UIView *vwStarOverlay = (UIView*)[cell viewWithTag:109];
	CGRect rt = vwStarOverlay.frame;
	rt.size.width = (10.0 - fStar)*15.0;
	rt.size.height = 15;
	rt.origin.x = 167 - (10.0 - fStar)*15.0;
	rt.origin.y = 13;
	vwStarOverlay.frame = rt;
	
	return cell;
}

#pragma mark CustomRateCellDelegate

-(void)DidUpvoteClicked:(int)cellIndex
{
	[MBProgressHUD showHUDAddedTo:[YYYAppDelegate sharedDelegate].window animated:YES];
	
	void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
		
		[ MBProgressHUD hideHUDForView : [YYYAppDelegate sharedDelegate].window animated : YES ] ;
		
		if( [ [ _responseObject objectForKey : @"success" ] isEqualToString : @"1" ] )
		{
			[lstComment replaceObjectAtIndex:cellIndex withObject:[_responseObject objectForKey:@"detail"]];
			[tblFeed reloadData];
		}
		else
		{
			[ self  showAlert:@"Oops!" message:@"An unknown error occured" ] ;
			return ;
		}
	} ;
	
	void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
		// Hide ;
		[ MBProgressHUD hideHUDForView : [YYYAppDelegate sharedDelegate].window animated : YES ] ;
		
		// Error ;
		[ self  showAlert:@"Oops!" message:@"An unknown error occured" ] ;
	} ;
	
	[[ YYYCommunication sharedManager ] Vote:[[YYYCommunication sharedManager].me objectForKey:@"user_id"]
									  rateid:[[lstComment objectAtIndex:cellIndex] objectForKey:@"rat_id"]
										type:@"up"
								   successed:successed
									 failure:failure];
}

-(void)DidDownvoteClicked:(int)cellIndex
{
	[MBProgressHUD showHUDAddedTo:[YYYAppDelegate sharedDelegate].window animated:YES];
	
	void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
		
		[ MBProgressHUD hideHUDForView : [YYYAppDelegate sharedDelegate].window animated : YES ] ;
		
		if( [ [ _responseObject objectForKey : @"success" ] isEqualToString : @"1" ] )
		{
			[lstComment replaceObjectAtIndex:cellIndex withObject:[_responseObject objectForKey:@"detail"]];
			[tblFeed reloadData];
		}
		else
		{
			[ self  showAlert:@"Oops!" message:@"An unknown error occured" ] ;
			return ;
		}
	} ;
	
	void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
		// Hide ;
		[ MBProgressHUD hideHUDForView : [YYYAppDelegate sharedDelegate].window animated : YES ] ;

		// Error ;
		[ self  showAlert:@"Oops!" message:@"An unknown error occured" ] ;
	} ;
	
	[[ YYYCommunication sharedManager ] Vote:[[YYYCommunication sharedManager].me objectForKey:@"user_id"]
									  rateid:[[lstComment objectAtIndex:cellIndex] objectForKey:@"rat_id"]
										type:@"down"
								   successed:successed
									 failure:failure];
}

-(void)DidCommentClicked:(int)cellIndex
{
	YYYCommentViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYCommentViewController"];
	viewcontroller.rateid = [[lstComment objectAtIndex:cellIndex] objectForKey:@"rat_id"];
	viewcontroller.lstComment = [[NSMutableArray alloc] initWithArray:[[lstComment objectAtIndex:cellIndex] objectForKey:@"commentarray"]];
	viewcontroller.bMyProfile = NO;
	
	if (dictUser)
	{
		viewcontroller.facebookid = [dictUser objectForKey:@"user_facebookid"];
	}
	
	[self.navigationController pushViewController:viewcontroller animated:YES];
}

-(void)DidReportClicked:(int)cellIndex
{
	YYYReportViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYReportViewController"];
	[self.navigationController presentViewController:viewcontroller animated:YES completion:nil];
}

-(NSString*)getDiffString:(int)diffSec
{
	if (diffSec < 60)
	{
		return [NSString stringWithFormat:@"%dsecs ago",diffSec];
	}
	else if (diffSec < 60*60)
	{
		return [NSString stringWithFormat:@"%dmins ago",diffSec/60];
	}
	else if (diffSec <  60*60*60)
	{
		return [NSString stringWithFormat:@"%dhours ago",diffSec/3600];
	}
	else if (diffSec <  60*60*60*60)
	{
		return [NSString stringWithFormat:@"%ddays ago",diffSec/216000];
	}
	else
	{
		return [NSString stringWithFormat:@"%dmonths ago",diffSec/12960000];
	}
	
	return @"";
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
