//
//  YYYFeedbackViewController.m
//  DND
//
//  Created by Wang MeiHua on 10/19/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYFeedbackViewController.h"

@interface YYYFeedbackViewController ()

@end

@implementation YYYFeedbackViewController

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
	
	txtView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
	txtView.layer.borderWidth = 1.0f;
	txtView.layer.cornerRadius = 2.0f;
	txtView.clipsToBounds = YES;
	txtView.text = @"";
	
	[txtView becomeFirstResponder];
	
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO];
}

-(IBAction)btBackClick:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btSendClick:(id)sender
{
	[[ YYYCommunication sharedManager ] SendFeedback:txtView.text successed:nil failure:nil];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Thanks for sending us Feedback" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
