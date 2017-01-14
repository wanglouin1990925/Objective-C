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

@interface YYYEditAlbumViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
	IBOutlet UIView *vwAlbum;
	int nSelected;
}
@end
