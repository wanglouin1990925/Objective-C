//
//  YYYGroupProfileViewController.h
//  MoMo
//
//  Created by Wang MeiHua on 11/6/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPhotoLargeView.h"

@interface YYYGroupProfileViewController : UIViewController<UIScrollViewDelegate,CustomPhotoLargeViewDelegate>
{
	IBOutlet UIScrollView *scvContent;
	IBOutlet UIView *vwProfile;
	
	
	//Information
	IBOutlet UIScrollView *scvPhoto;
	IBOutlet UIView *vwAbout;
	IBOutlet UIView *vwMember;
	IBOutlet UIView *vwLocation;
	IBOutlet UIView *vwOwner;
	
	IBOutlet UIImageView *imvAvatar;
	IBOutlet UILabel *lblLocation;
	IBOutlet UILabel *lblOwner;
	IBOutlet UILabel *lblAbout;
	IBOutlet UILabel *lblMembers;
	IBOutlet UIImageView *imvOwner;
	IBOutlet UIScrollView *scvMembers;
	
	IBOutlet UIView	*vwJoin;
	IBOutlet UIView	*vwLeave;
	IBOutlet UIView *vwChat;
	NSMutableArray *lstMemberID;
}

@property (nonatomic,retain) NSMutableDictionary	*dictInfo;
@property (nonatomic,retain) NSMutableArray			*lstUsers;
@property (nonatomic,retain) NSMutableArray			*lstPhotos;

-(IBAction)btOwnerClicked:(id)sender;
-(IBAction)btJoinClicked:(id)sender;
-(IBAction)btLeaveClicked:(id)sender;
-(IBAction)btChatClick:(id)sender;

@end
