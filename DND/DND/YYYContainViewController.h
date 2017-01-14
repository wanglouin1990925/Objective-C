//
//  YYYHomeViewController.h
//  DND
//
//  Created by Wang MeiHua on 10/7/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYYHomeViewController.h"
#import "YYYNotificationViewController.h"
#import "YYYSettingViewController.h"
#import "YYYProfileViewController.h"
#import "YYYTrendingViewController.h"
#import "YYYProfileViewController.h"
#import "NYSegmentedControl.h"

@interface YYYContainViewController : UIViewController<UIScrollViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate,HomeViewControllerDelegate,TrendingViewControllerDelegate,NotificationViewControllerDelegate,ProfileViewControllerDelegate>
{
	IBOutlet UIScrollView *scvTopBar;
	IBOutlet UIScrollView *scvContent;
	
	IBOutlet UIImageView *imvIndicator;
	
	IBOutlet UIButton *btHome;
	IBOutlet UIButton *btNotification;
	IBOutlet UIButton *btSetting;
	IBOutlet UIButton *btProfile;
	
	IBOutlet UISearchBar *srcBar;
	
	UIView *vwSegmentBackView;
	
	NSMutableArray *lstFilteredFriend;
	NSMutableArray *lstFriend;
	BOOL isSearching;
	
	IBOutlet UIView *vwNavBar;
	IBOutlet UIView *vwNavSubBar;
	IBOutlet UIView *scvNavSubBar;
	
	NYSegmentedControl *foursquareSegmentedControl;
}

@property (nonatomic,retain) NSString *strInfo;

@property (nonatomic,retain) YYYHomeViewController *homeviewcontroller;
@property (nonatomic,retain) YYYNotificationViewController *notificationviewcontroller;
@property (nonatomic,retain) YYYSettingViewController *settingviewcontroller;
@property (nonatomic,retain) YYYProfileViewController *profileviewcontroller;
@property (nonatomic,retain) YYYTrendingViewController *trendingviewcontroller;

-(IBAction)btNextClick:(id)sender;
-(IBAction)btPrevClick:(id)sender;

@end
