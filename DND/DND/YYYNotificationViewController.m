//
//  YYYNotifcationViewController.m
//  DND
//
//  Created by Wang MeiHua on 10/10/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYNotificationViewController.h"
#import "ODRefreshControl.h"
#import "YYYCommunication.h"
#import "YYYAppDelegate.h"
#import "MBProgressHUD.h"

@interface YYYNotificationViewController ()

@end

@implementation YYYNotificationViewController

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
	
	refreshControl = [[ODRefreshControl alloc] initInScrollView:tblNotification];
    [refreshControl addTarget:self action:@selector(loadNotification) forControlEvents:UIControlEventValueChanged];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNotification) name:@"RefreshNotification" object:nil];
	
    // Do any additional setup after loading the view.
}

-(void)loadNotification
{
	[MBProgressHUD showHUDAddedTo:[YYYAppDelegate sharedDelegate].window animated:YES];
	
	void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
		
		[ MBProgressHUD hideHUDForView : [YYYAppDelegate sharedDelegate].window animated : YES ] ;
		
		if( [ [ _responseObject objectForKey : @"success" ] isEqualToString : @"1" ] )
		{
			[YYYCommunication sharedManager].lstNotification = [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"detail"]];
			[tblNotification reloadData];
			
			NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
			[defaults setObject:[_responseObject objectForKey:@"notification"] forKey:@"notifications"];
			[defaults synchronize];
			
			[refreshControl endRefreshing];
		}
		else
		{
			[ self  showAlert:@"Oops!" message:@"An unknown error occured" ] ;
			[refreshControl endRefreshing];
			
			return ;
		}
	} ;
	
	void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
		// Hide ;
		[ MBProgressHUD hideHUDForView : [YYYAppDelegate sharedDelegate].window animated : YES ] ;
		
		// Error ;
		[ self  showAlert:@"Oops!" message:@"An unknown error occured" ] ;
	} ;
	
	[[ YYYCommunication sharedManager ] GetNotifications:[[YYYCommunication sharedManager].me objectForKey:@"user_id"]
											  facebookid:[[YYYCommunication sharedManager].me objectForKey:@"user_facebookid"]
											   successed:successed
												 failure:failure];
}

#pragma mark UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[YYYCommunication sharedManager].lstNotification count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CustomNotifcationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomRateCell"];
	[cell initWithData:[[YYYCommunication sharedManager].lstNotification objectAtIndex:indexPath.row]];
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[delegate DidNotificationUserClicked:[NSString stringWithFormat:@"%d",(int)indexPath.row]];
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
