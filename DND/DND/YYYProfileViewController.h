//
//  YYYProfileViewController.h
//  DND
//
//  Created by Wang MeiHua on 10/11/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPhotoLargeView.h"
#import "CustomRateCell.h"

@protocol ProfileViewControllerDelegate <NSObject>

-(void)DidCommentClicked:(NSString*)rateid commentarray:(NSMutableArray*)lstComment;
-(void)DidReportClick:(NSString*)rateid;

@end

@interface YYYProfileViewController : UIViewController<UIScrollViewDelegate,CustomPhotoLargeViewDelegate,UITableViewDataSource,UITableViewDelegate,CustomRateCellDelegate>
{
	IBOutlet UITableView *tblFeed;
	IBOutlet UIScrollView *scvPhoto;
	IBOutlet UIPageControl *pgCtl;
	
	IBOutlet UILabel *lblUsername;
	IBOutlet UILabel *lblScore;
	CustomPhotoLargeView *customPhotoView;
	
	NSMutableArray *lstPhoto;
	NSMutableArray *lstComment;
	
	IBOutlet UIView *vwProfile;
	IBOutlet UIView *vwDummy;
}

-(IBAction)btEyeClick:(id)sender;

@property (nonatomic,retain) id<ProfileViewControllerDelegate> delegate;

@end
