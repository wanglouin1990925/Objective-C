//
//  YYYTrendingViewController.h
//  DND
//
//  Created by Wang MeiHua on 10/14/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TrendingViewControllerDelegate <NSObject>

-(void)DidTrendingUserClicked:(NSString*)userIndex;

@end

@interface YYYTrendingViewController : TMQuiltViewController<TMQuiltViewDelegate>
{
	BOOL bFirstLoad;
	BOOL bNearBy;
	
	NSMutableArray *lstWorldUsers;
	NSMutableArray *lstLocalUsers;
	
	ODRefreshControl *refreshControl;
}

-(void)swhTrendingChanged:(int)nIndex;
@property (nonatomic,retain) id<TrendingViewControllerDelegate> delegate;

@end
