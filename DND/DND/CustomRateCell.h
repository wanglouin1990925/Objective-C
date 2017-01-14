//
//  CustomRateCell.h
//  DND
//
//  Created by Wang MeiHua on 11/4/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomRateCellDelegate <NSObject>

-(void)DidUpvoteClicked:(int)cellIndex;
-(void)DidReportClicked:(int)cellIndex;
-(void)DidDownvoteClicked:(int)cellIndex;
-(void)DidCommentClicked:(int)cellIndex;

@end

@interface CustomRateCell : UITableViewCell
{
	
}

-(IBAction)btUpVoteClick:(id)sender;
-(IBAction)btDownVoteClick:(id)sender;
-(IBAction)btReportClick:(id)sender;

@property (nonatomic,retain) id<CustomRateCellDelegate> delegate;
@property int cellIndex;

@end
