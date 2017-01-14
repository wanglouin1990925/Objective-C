//
//  YYYGroupMemberViewController.h
//  MoMo
//
//  Created by King on 12/11/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPendingCell.h"

@protocol JobPendingViewDelegate <NSObject>

-(void)DidJobPendingUpdated:(NSMutableArray*)lstPending :(NSMutableArray*)lstNewAccept;

@end

@interface YYYJoinPendingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CustomPendingCellDelegate>
{
	IBOutlet UITableView *tblPending;
	
	NSMutableArray *lstNewAccept;
}

@property (nonatomic,retain) NSMutableArray *lstPending;
@property (nonatomic,retain) NSString *groupID;
@property (nonatomic,retain) id<JobPendingViewDelegate> delegate;

-(IBAction)btBackClick:(id)sender;

@end
