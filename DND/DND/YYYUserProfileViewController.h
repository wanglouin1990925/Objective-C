//
//  YYYProfileViewController.h
//  DND
//
//  Created by Wang MeiHua on 10/11/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPhotoLargeView.h"
#import "CustomRateMe.h"
#import "CustomRateCell.h"

@interface YYYUserProfileViewController : UIViewController<UIScrollViewDelegate,CustomPhotoLargeViewDelegate,UITableViewDataSource,UITableViewDelegate,CustomRateDelegate,CustomRateCellDelegate,UIScrollViewDelegate>
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
	
	float fRate;
	BOOL isFirstload;
	
	NSMutableDictionary *dictUser;
	ODRefreshControl *refreshControl;
}

-(IBAction)btEyeClick:(id)sender;
-(IBAction)btBackClick:(id)sender;
-(IBAction)btRateClick:(id)sender;

@property (nonatomic,retain) NSString *strFBID;
@property (nonatomic,retain) NSString *strFBFirstname;
@property (nonatomic,retain) NSString *strFBLastname;
@property (nonatomic,retain) NSString *strFBAge;
@property (nonatomic,retain) NSString *strFBGender;

@end
