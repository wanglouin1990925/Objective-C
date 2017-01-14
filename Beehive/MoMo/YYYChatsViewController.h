//
//  YYYChatsViewController.h
//  MoMo
//
//  Created by Wang MeiHua on 10/30/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomChatsCell.h"
#import "CustomTableViewHeader.h"

@interface YYYChatsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CustomChatsCellDelegate>
{
	UIRefreshControl *refreshControl;
	IBOutlet UITableView *tableView;
	
	NSMutableArray	*lstChat;
	NSMutableArray	*lstGChat;
	NSMutableArray	*lstInCome;
	NSMutableArray	*lstGInCome;
	NSMutableArray	*lstInbound;
    NSMutableArray  *lstTemp;
    
    NSIndexPath     *indexPathForEdit;
}
@end
