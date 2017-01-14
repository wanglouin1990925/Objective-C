//
//  YYYEditAlbumViewController.h
//  MoMo
//
//  Created by King on 11/18/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYYCommunication.h"
#import "YYYAppDelegate.h"

@protocol EditGroupAlbumViewDelegate <NSObject>

-(void)DidAlbumUpdated:(NSMutableArray*)lstPhoto;

@end

@interface YYYEditGroupAlbumViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
	int nSelected;
}

@property (nonatomic,retain) NSMutableArray *lstPhoto;
@property (nonatomic,retain) NSString *groupID;
@property (nonatomic,retain) id<EditGroupAlbumViewDelegate> delegate;

@end
