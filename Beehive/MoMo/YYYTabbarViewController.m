//
//  YYYTabbarViewController.m
//  MoMo
//
//  Created by Wang MeiHua on 10/30/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYTabbarViewController.h"

@interface YYYTabbarViewController ()

@end

@implementation YYYTabbarViewController

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
	
	CustomTabbarView *tabbar = [CustomTabbarView sharedView];
	[tabbar setFrame:CGRectMake(0, 0, 320, 49)];
	[self.tabBar addSubview:tabbar];
	tabbar.delegate = self;
	[tabbar setCurrentTab:0];
	[tabbar initBadge];

    // Do any additional setup after loading the view.
}

-(void)DidTabbarClicked:(int)index
{
	[self setSelectedIndex:index];
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
