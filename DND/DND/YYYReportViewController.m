//
//  YYYReportViewController.m
//  DND
//
//  Created by Wang MeiHua on 11/5/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYReportViewController.h"
#import "YYYAppDelegate.h"
#import "YYYCommunication.h"

@interface YYYReportViewController ()

@end

@implementation YYYReportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
	{
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	txtComment.layer.borderColor = [[UIColor lightGrayColor] CGColor];
	txtComment.layer.borderWidth = 1.0;
	
	[txtComment becomeFirstResponder];
	
	if ([[[YYYCommunication sharedManager].me objectForKey:@"user_gender"] isEqualToString:@"male"])
	{
		[vwTopBar setBackgroundColor:COLOR_GUY];
	}
	else
	{
		[vwTopBar setBackgroundColor:COLOR_GIRL];
	}
    // Do any additional setup after loading the view.
}

-(IBAction)btCancelClick:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)btSendClick:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
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
