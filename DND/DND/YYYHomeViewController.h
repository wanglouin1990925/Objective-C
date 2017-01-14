//
//  YYYHomeViewController.h
//  DND
//
//  Created by Wang MeiHua on 10/10/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODRefreshControl.h"

@protocol HomeViewControllerDelegate <NSObject>

-(void)DidHomeUserClicked:(NSString*)userIndex;

@end

@interface YYYHomeViewController : TMQuiltViewController<TMQuiltViewDelegate>
{
	NSMutableArray *lstFriend;
	NSMutableArray *lstUsers;
	
	BOOL bFirstLoad;
	
	ODRefreshControl *refreshControl;
}

@property (nonatomic,retain) id<HomeViewControllerDelegate> delegate;

@end
