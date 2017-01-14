//
//  YYYSettingViewController.h
//  DND
//
//  Created by Wang MeiHua on 10/10/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REDRangeSlider.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface YYYSettingViewController : UITableViewController
{
	IBOutlet UIView *viewForAge;
	IBOutlet UILabel *lblDistance;
	IBOutlet UILabel *lblAge;
	IBOutlet UISlider *sldDistance;
	IBOutlet UISwitch *swhPush;
	NSUserDefaults *defaults;
}

@property (strong, nonatomic) REDRangeSlider *sldAge;

-(IBAction)btBackClick:(id)sender;
-(IBAction)distanceChanged:(id)sender;
-(IBAction)btLogoutClick:(id)sender;
-(IBAction)pushValueChanged:(id)sender;

@end
