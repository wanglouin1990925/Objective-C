//
//  YYYPlacesViewController.m
//  MoMo
//
//  Created by King on 11/19/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYPlacesViewController.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import <AVFoundation/AVFoundation.h>
#import "YYYAppDelegate.h"
#import "MBProgressHUD.h"
#import "UIImageView+AFNetworking.h"

@interface YYYPlacesViewController ()

@end

@implementation YYYPlacesViewController

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
	
	nSelectedIndex = -1;
	
	lstPlaces = [[NSMutableArray alloc] init];
	[self loadNearByPlaces];
	
    // Do any additional setup after loading the view.
}

-(void)loadNearByPlaces
{
	[lstPlaces removeAllObjects];
	
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	NSString *strQuery = [ NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=10000&sensor=false&key=AIzaSyDC4GTiOYK_jg4-cVZnlsJK-KwTVtCV3oE",[YYYAppDelegate sharedDelegate].fLat,[YYYAppDelegate sharedDelegate].fLng ];
	
//	NSString *strQuery = [ NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=10000&sensor=false&key=AIzaSyDC4GTiOYK_jg4-cVZnlsJK-KwTVtCV3oE",37.00,120.00 ];
	
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	manager.securityPolicy.allowInvalidCertificates = YES;
	
	[manager GET:strQuery parameters:nil success:^(AFHTTPRequestOperation *operation, id _responseObject){

		[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
		for (NSDictionary *dict in [_responseObject objectForKey:@"results"])
		{
			[lstPlaces addObject:dict];
			[tblPlaces reloadData];
		}
		
    } failure:^(AFHTTPRequestOperation *operation, NSError *_error) {
		
		[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
		NSLog(@"%@",_error.description);
		
    }];
}

-(IBAction)btBackClick:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btDoneClick:(id)sender
{
	if (nSelectedIndex == -1)
		return;
	
	[delegate DidPlaceSelected:[lstPlaces objectAtIndex:nSelectedIndex]];
	[self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [lstPlaces count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceCell"];
	
	NSDictionary *dict = [lstPlaces objectAtIndex:indexPath.row];
	
	UIImageView *imvIcon = (UIImageView*)[cell viewWithTag:100];
	[imvIcon setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"icon"]]];
	
	UILabel *lblPlace = (UILabel*)[cell viewWithTag:101];
	[lblPlace setText:[dict objectForKey:@"name"]];
	
	cell.accessoryType = UITableViewCellAccessoryNone;
	
	if (indexPath.row == nSelectedIndex)
	{
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	nSelectedIndex = (int)indexPath.row;
	[tblPlaces reloadData];
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
