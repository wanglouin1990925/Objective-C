//
//  YYYProfileViewController.h
//  MoMo
//
//  Created by Wang MeiHua on 11/5/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPhotoLargeView.h"
#import "ODRefreshControl.h"

@interface YYYProfileViewController : UIViewController<UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,CustomPhotoLargeViewDelegate>
{
	IBOutlet UIView *vwInfoContainer;
	IBOutlet UIView *vwProfile;
	IBOutlet UIScrollView *scvContent;
	
	IBOutlet UIView *vwAboutMe;
	IBOutlet UIView *vwAlbum;
	IBOutlet UIView *vwGroup;
	
	IBOutlet UIScrollView *scvAlbum;
	
	//Informations
	IBOutlet UIImageView *imvAvatar;
	IBOutlet UIImageView *imvCover;
	IBOutlet UIImageView *imvGender;
	IBOutlet UILabel *lblName;
	IBOutlet UILabel *lblAge;
	IBOutlet UILabel *lblDistance;
	IBOutlet UILabel *lblAboutme;
    
    ODRefreshControl    *topRefresh;
	
	BOOL bAvatar;
}

-(IBAction)btEditAvatarClick:(id)sender;
-(IBAction)btEditCoverClick:(id)sender;

@end
