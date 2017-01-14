//
//  YYYGroupMemberViewController.h
//  MoMo
//
//  Created by King on 12/11/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GroupMemberViewDelegate <NSObject>

-(void)DidMemberUpdated:(NSMutableArray*)lstMember;

@end

@interface YYYGroupMemberViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
	IBOutlet UITableView *tblMembers;
}

@property (nonatomic,retain) NSMutableArray *lstMember;
@property (nonatomic,retain) id<GroupMemberViewDelegate> delegate;

-(IBAction)btBackClick:(id)sender;

@end
