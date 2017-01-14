//
//  YYYProfileViewController.m
//  DND
//
//  Created by Wang MeiHua on 10/11/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYProfileViewController.h"
#import "CustomFeedCell.h"
#import "ODRefreshControl.h"
#import "UIImageView+AFNetworking.h"
#import "YYYAppDelegate.h"
#import "YYYCommunication.h"
#import "YYYAppDelegate.h"
#import "YYYReportViewController.h"
#import "YYYCommentViewController.h"

@interface YYYProfileViewController ()

@end

@implementation YYYProfileViewController

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
	
//	ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:tblFeed];
//    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
	
	[self showProfile];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadProfile) name:@"RefreshMyProfile" object:nil];
	
	// Do any additional setup after loading the view.
}

-(void)showProfile
{
	int nPhotCount = 10;
	
	lstPhoto = [[NSMutableArray alloc] init];
	
	if (![[[YYYCommunication sharedManager].me objectForKey:@"user_photo1"] isEqualToString:@""])
		[lstPhoto addObject:[[YYYCommunication sharedManager].me objectForKey:@"user_photo1"]];
	
	if (![[[YYYCommunication sharedManager].me objectForKey:@"user_photo2"] isEqualToString:@""])
		[lstPhoto addObject:[[YYYCommunication sharedManager].me objectForKey:@"user_photo2"]];
	
	if (![[[YYYCommunication sharedManager].me objectForKey:@"user_photo3"] isEqualToString:@""])
		[lstPhoto addObject:[[YYYCommunication sharedManager].me objectForKey:@"user_photo3"]];
	
	if (![[[YYYCommunication sharedManager].me objectForKey:@"user_photo4"] isEqualToString:@""])
		[lstPhoto addObject:[[YYYCommunication sharedManager].me objectForKey:@"user_photo4"]];
	
	if (![[[YYYCommunication sharedManager].me objectForKey:@"user_photo5"] isEqualToString:@""])
		[lstPhoto addObject:[[YYYCommunication sharedManager].me objectForKey:@"user_photo5"]];
	
	if (![[[YYYCommunication sharedManager].me objectForKey:@"user_photo6"] isEqualToString:@""])
		[lstPhoto addObject:[[YYYCommunication sharedManager].me objectForKey:@"user_photo6"]];
	
	if (![[[YYYCommunication sharedManager].me objectForKey:@"user_photo7"] isEqualToString:@""])
		[lstPhoto addObject:[[YYYCommunication sharedManager].me objectForKey:@"user_photo7"]];
	
	if (![[[YYYCommunication sharedManager].me objectForKey:@"user_photo8"] isEqualToString:@""])
		[lstPhoto addObject:[[YYYCommunication sharedManager].me objectForKey:@"user_photo8"]];
	
	if (![[[YYYCommunication sharedManager].me objectForKey:@"user_photo9"] isEqualToString:@""])
		[lstPhoto addObject:[[YYYCommunication sharedManager].me objectForKey:@"user_photo9"]];
	
	if (![[[YYYCommunication sharedManager].me objectForKey:@"user_photo10"] isEqualToString:@""])
		[lstPhoto addObject:[[YYYCommunication sharedManager].me objectForKey:@"user_photo10"]];
	
	nPhotCount = (int)[lstPhoto count];
	
	lstComment = [[NSMutableArray alloc] initWithArray:[[YYYCommunication sharedManager].me objectForKey:@"comments"]];
	[tblFeed reloadData];
	
	for (UIView *view in scvPhoto.subviews)
	{
		if ([view isKindOfClass:[UIImageView class]])
		{
			[view removeFromSuperview];
		}
	}
	
	for (int i = 0; i < nPhotCount; i++)
	{
		UIImageView *imvPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(scvPhoto.frame.size.width*i, 0, scvPhoto.frame.size.width, scvPhoto.frame.size.height)];
		imvPhoto.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
		[imvPhoto setImageWithURL:[NSURL URLWithString:[lstPhoto objectAtIndex:i]]];
		[imvPhoto setContentMode:UIViewContentModeScaleAspectFill];
		
		[scvPhoto addSubview:imvPhoto];
	}
	
	[lblUsername setText:[NSString stringWithFormat:@"%@ %@",[[YYYCommunication sharedManager].me objectForKey:@"user_firstname"],[[YYYCommunication sharedManager].me objectForKey:@"user_lastname"]]];
	[lblScore setText:[NSString stringWithFormat:@"%.1f",2*[[[YYYCommunication sharedManager].me objectForKey:@"rate"] floatValue]]];
	
	[scvPhoto setContentSize:CGSizeMake(320*nPhotCount, 200)];
	[pgCtl setNumberOfPages:nPhotCount];
}

-(void)loadProfile
{
	void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
		
		[ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
		
		if( [ [ _responseObject objectForKey : @"success" ] isEqualToString : @"1" ] )
		{
			[YYYCommunication sharedManager].me = [[NSMutableDictionary alloc] initWithDictionary:[_responseObject objectForKey:@"detail"]];
			
			NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
			[defaults setObject:[_responseObject objectForKey:@"detail"] forKey:@"userinfo"];
			[defaults synchronize];
			
			[self showProfile];
		}
		else
		{
			
		}
	} ;
	
	void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {

	} ;
	
	[[ YYYCommunication sharedManager ] SignUp:[[YYYCommunication sharedManager].me objectForKey:@"user_facebookid"]
									 firstname:@""
									  lastname:@""
										gender:@""
										   age:@""
									  latitude:@""
									 longitude:@""
										photo1:@""
										photo2:@""
										photo3:@""
										photo4:@""
										photo5:@""
										photo6:@""
										photo7:@""
										photo8:@""
										photo9:@""
									   photo10:@""
									 successed:successed
									   failure:failure];
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

#pragma mark CustomPhotoLargeViewDelegate

-(void)DidBackClick
{
	[customPhotoView removeFromSuperview];
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


//- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
//{
//    double delayInSeconds = 3.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [refreshControl endRefreshing];
//    });
//}


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
	
	float fStar = [[[lstComment objectAtIndex:indexPath.row] objectForKey:@"rat_score"] floatValue] * 2;
	
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
	[lblComments setText:[NSString stringWithFormat:@"%d",[[[lstComment objectAtIndex:indexPath.row] objectForKey:@"commentarray"] count]]];
	
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

-(void)showAlert:(NSString*)title message:(NSString*)message
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
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
	[delegate DidCommentClicked:[[lstComment objectAtIndex:cellIndex] objectForKey:@"rat_id"] commentarray:[[NSMutableArray alloc] initWithArray:[[lstComment objectAtIndex:cellIndex] objectForKey:@"commentarray"]]];
}

-(void)DidReportClicked:(int)cellIndex
{
	[delegate DidReportClick:@"0"];
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
