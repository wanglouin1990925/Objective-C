//
//  YYYEditProfileController.h
//  GiveIt100
//
//  Created by Wang MeiHua on 1/13/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYYEditProfileController : UITableViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    IBOutlet UITextField *txtUsername;
    IBOutlet UITextField *txtLocation;
    IBOutlet UITextView *txtBio;
    IBOutlet UITextField *txtEmail;
    IBOutlet UIButton *btPhoto;
    IBOutlet UIImageView *imvPhoto;
    
    BOOL bPhoto;
}
-(IBAction)btPhotoClick:(id)sender;
-(IBAction)btSaveClick:(id)sender;
@end
