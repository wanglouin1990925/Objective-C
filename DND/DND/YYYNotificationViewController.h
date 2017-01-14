//
//  YYYNotifcationViewController.h
//  DND
//
//  Created by Wang MeiHua on 10/10/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNotifcationCell.h"
#import "ODRefreshControl.h"

@protocol NotificationViewControllerDelegate <NSObject>

-(void)DidNotificationUserClicked:(NSString*)userIndex;

@end

@interface YYYNotificationViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
	IBOutlet UITableView *tblNotification;
	ODRefreshControl *refreshControl;
}

@property (nonatomic,retain) id<NotificationViewControllerDelegate> delegate;

@end
