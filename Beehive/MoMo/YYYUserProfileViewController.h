//
//  YYYProfileViewController.h
//  MoMo
//
//  Created by Wang MeiHua on 11/5/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPhotoLargeView.h"

@interface YYYUserProfileViewController : UIViewController<UIScrollViewDelegate,UIActionSheetDelegate,CustomPhotoLargeViewDelegate>
{
	IBOutlet UIView *vwInfoContainer;
	IBOutlet UIView *vwProfile;
	IBOutlet UIScrollView *scvContent;
	
	IBOutlet UIView *vwAboutMe;
	IBOutlet UIView *vwAlbum;
	IBOutlet UIView *vwGroup;
	
	//Informations
	IBOutlet UIImageView *imvAvatar;
	IBOutlet UIImageView *imvCover;
	IBOutlet UIImageView *imvGender;
	IBOutlet UILabel *lblName;
	IBOutlet UILabel *lblAge;
	IBOutlet UILabel *lblDistance;
	IBOutlet UILabel *lblAboutme;
	
	IBOutlet UIView		*vwNormal;
	IBOutlet UIView		*vwFriend;
	IBOutlet UIView		*vwBlock;	
}

-(IBAction)btBackClick:(id)sender;
-(IBAction)btChatClick:(id)sender;
-(IBAction)btAddClick:(id)sender;
-(IBAction)btBlockClick:(id)sender;
-(IBAction)btUnFriendClick:(id)sender;
-(IBAction)btUnBlockClick:(id)sender;

@property (nonatomic,retain) NSDictionary *dictInfo;
@property (nonatomic,retain) NSArray *lstPhoto;
@property (nonatomic,retain) NSArray *lstGroup;

@end
