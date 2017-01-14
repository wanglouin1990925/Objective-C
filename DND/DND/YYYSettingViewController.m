//
//  YYYSettingViewController.m
//  DND
//
//  Created by Wang MeiHua on 10/10/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYSettingViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AOTutorialController.h"
#import "AOTutorialViewController.h"
#import "YYYAppDelegate.h"

@interface YYYSettingViewController ()

@end

@implementation YYYSettingViewController

@synthesize sldAge;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sldAge = [[REDRangeSlider alloc] initWithFrame:CGRectMake(20, -10, 220, 34)];
    sldAge.tintColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:1.0f];
    [sldAge addTarget:self action:@selector(ageChanged:) forControlEvents:UIControlEventValueChanged];
	
	defaults = [NSUserDefaults standardUserDefaults];
	sldAge.maxValue = 70;
    sldAge.minValue = 0;
	
	[viewForAge addSubview:self.sldAge];
	
	[sldDistance setValue:[[defaults objectForKey:@"distance"] intValue]];
	[lblDistance setText:[NSString stringWithFormat:@"%dmiles",[[defaults objectForKey:@"distance"] intValue]]];
	
	[sldAge setLeftValue:[[defaults objectForKey:@"ageh"] intValue] - 10];
	[sldAge setRightValue:[[defaults objectForKey:@"agel"] intValue] - 10];
	[lblAge setText:[NSString stringWithFormat:@"%d ~ %d",[[defaults objectForKey:@"ageh"] intValue],[[defaults objectForKey:@"agel"] intValue]]];
	
	if ([[defaults objectForKey:@"push"] isEqualToString:@"1"])
	{
		[swhPush setOn:YES];
	}
	else
	{
		[swhPush setOn:NO];
	}
}

-(IBAction)btLogoutClick:(id)sender
{
	[PFUser logOut];
	
	if (FBSession.activeSession.state == FBSessionStateOpen
		|| FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
		[FBSession.activeSession closeAndClearTokenInformation];
	}
	
	[[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userinfo"];
	[[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"notifications"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	AOTutorialController *vc = [[AOTutorialController alloc] initWithBackgroundImages:[[NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Config.plist"]] valueForKeyPath:@"Tutorial.Images"]
                                                                      andInformations:[[NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Config.plist"]] valueForKeyPath:@"Tutorial.Labels"]];
	[vc setButtons:AOTutorialButtonSignup | AOTutorialButtonLogin];
	[[YYYAppDelegate sharedDelegate].window setRootViewController:vc];
}

-(void)ageChanged:(id)sender
{
	[lblAge setText:[NSString stringWithFormat:@"%d To %d",(int)sldAge.leftValue + 10,(int)sldAge.rightValue + 10]];
	
	[defaults setObject:[NSString stringWithFormat:@"%d",(int)sldAge.rightValue + 10] forKey:@"ageh"];
	[defaults setObject:[NSString stringWithFormat:@"%d",(int)sldAge.leftValue + 10] forKey:@"agel"];
	[defaults synchronize];
}

-(IBAction)distanceChanged:(id)sender
{
	[lblDistance setText:[NSString stringWithFormat:@"%dMiles",(int)sldDistance.value]];
	
	[defaults setObject:[NSString stringWithFormat:@"%d",(int)sldDistance.value] forKey:@"distance"];
	[defaults synchronize];
}

-(IBAction)pushValueChanged:(id)sender
{
	if (swhPush.isOn)
		[defaults setObject:@"1" forKey:@"push"];
	else
		[defaults setObject:@"0" forKey:@"push"];
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO];
}

-(void)viewDidDisappear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshTrending" object:nil];
	[super viewDidDisappear:animated];
}

-(IBAction)btBackClick:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
	[self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
