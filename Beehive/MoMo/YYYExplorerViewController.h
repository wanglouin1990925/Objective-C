//
//  YYYExplorerViewController.h
//  MoMo
//
//  Created by Wang MeiHua on 10/30/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTableViewHeader.h"
#import "ODRefreshControl.h"
#import "MNMBottomPullToRefreshManager.h"

@interface YYYExplorerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MNMBottomPullToRefreshManagerClient,UIScrollViewDelegate>
{
	IBOutlet UITableView *tableView;

	ODRefreshControl				*topRefresh;
	MNMBottomPullToRefreshManager	*bottomRefresh;
	
	NSMutableArray *lstGroups;
}

-(IBAction)btCreateGroup:(id)sender;

@end
