//
//  YYYGroupMemberViewController.m
//  MoMo
//
//  Created by King on 12/11/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYJoinPendingViewController.h"
#import "YYYAppDelegate.h"
#import "YYYCommunication.h"
#import "MBProgressHUD.h"
#import <CoreLocation/CoreLocation.h>
#import "UIImageView+AFNetworking.h"
#import "YYYUserProfileViewController.h"

@interface YYYJoinPendingViewController ()

@end

@implementation YYYJoinPendingViewController

@synthesize lstPending;
@synthesize groupID;
@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
	lstNewAccept = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)btBackClick:(id)sender
{
	[delegate DidJobPendingUpdated:lstPending :lstNewAccept];
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)DidDeclineClicked:(int)index
{
	[MBProgressHUD showHUDAddedTo:[YYYAppDelegate sharedDelegate].window animated:YES];
	
	void ( ^successed )( id _responseObject ) = ^( id _responseObject )
	{
		[MBProgressHUD hideAllHUDsForView:[YYYAppDelegate sharedDelegate].window animated:YES];
		
		if ([[_responseObject objectForKey:@"success"] isEqualToString:@"1"])
		{
			[lstPending removeObjectAtIndex:index];
			[tblPending reloadData];
		}
		else
		{
			
		}
	} ;
	
	void ( ^failure )( NSError* _error ) = ^( NSError* _error )
	{
		[MBProgressHUD hideAllHUDsForView:[YYYAppDelegate sharedDelegate].window animated:YES];
	} ;
	
	[[YYYCommunication sharedManager] DeclineGroup:[[lstPending objectAtIndex:index] objectForKey:@"user_id"]
										   groupid:groupID
										 successed:successed
										   failure:failure];
}

-(void)DidAcceptClicked:(int)index
{
	[MBProgressHUD showHUDAddedTo:[YYYAppDelegate sharedDelegate].window animated:YES];
	
	void ( ^successed )( id _responseObject ) = ^( id _responseObject )
	{
		[MBProgressHUD hideAllHUDsForView:[YYYAppDelegate sharedDelegate].window animated:YES];
		
		if ([[_responseObject objectForKey:@"success"] isEqualToString:@"1"])
		{
			[lstNewAccept addObject:[lstPending objectAtIndex:index]];
			[lstPending removeObjectAtIndex:index];			
			[tblPending reloadData];
		}
		else
		{
			
		}
	} ;
	
	void ( ^failure )( NSError* _error ) = ^( NSError* _error )
	{
		[MBProgressHUD hideAllHUDsForView:[YYYAppDelegate sharedDelegate].window animated:YES];
	} ;
	
	[[YYYCommunication sharedManager] AcceptGroup:[[lstPending objectAtIndex:index] objectForKey:@"user_id"]
										  groupid:groupID
										successed:successed
										  failure:failure];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [lstPending count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *identifer = @"CustomPendingCell";
	
	CustomPendingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
	cell.index		= (int)indexPath.row;
	cell.delegate	= self;
	
	NSDictionary *dict = [lstPending objectAtIndex:indexPath.row];
	
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
	
	[lblDistance setText:[NSString stringWithFormat:@"%.2fkm | %@",fDistance,[self getDiffString:[[dict objectForKey:@"lastlogin"] intValue]]]];
	
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
	
	[[YYYCommunication sharedManager] LoadUserProfile:[[lstPending objectAtIndex:indexPath.row] objectForKey:@"user_id"]
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
