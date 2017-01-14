//
//  YYYContactViewController.h
//  MoMo
//
//  Created by Wang MeiHua on 11/6/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODRefreshControl.h"

@interface YYYContactViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
	IBOutlet UISegmentedControl *segmentCtl;
	IBOutlet UITableView *tblFriend;
	IBOutlet UITableView *tblGroup;
	IBOutlet UITableView *tblBlock;
	
    ODRefreshControl				*topRefresh1;
    ODRefreshControl				*topRefresh2;
    ODRefreshControl				*topRefresh3;
    
	NSMutableArray *lstCreated;
	NSMutableArray *lstJoined;
	NSMutableArray *lstRequest;
}

-(IBAction)btSegmentClicked:(id)sender;

@end
