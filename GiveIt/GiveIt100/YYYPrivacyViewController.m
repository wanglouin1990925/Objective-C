//
//  YYYPrivacyViewController.m
//  GiveIt100
//
//  Created by Wang MeiHua on 2/21/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYPrivacyViewController.h"

@interface YYYPrivacyViewController ()

@end

@implementation YYYPrivacyViewController

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
    
    [scvPrivacy setContentSize:CGSizeMake(320, 3700)];
	// Do any additional setup after loading the view.
}

-(IBAction)btBackClick:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end