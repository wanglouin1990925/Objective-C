//
//  YYYSignUpController.h
//  GiveIt100
//
//  Created by Wang MeiHua on 1/10/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYYSignUpController : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    IBOutlet UILabel *lblTerms;
}
@property (nonatomic, weak) IBOutlet UITextField * emailField;
@property (nonatomic, weak) IBOutlet UITextField * passwordField;
@property (nonatomic, weak) IBOutlet UITextField * confirmField;
@property (nonatomic, weak) IBOutlet UITextField * usernameField;

@property (nonatomic, weak) IBOutlet UIButton *signupButton;
@property (nonatomic, weak) IBOutlet UIView * infoView;
@property (nonatomic, weak) IBOutlet UILabel * infoLabel;

@property (nonatomic, weak) IBOutlet UIButton *photoButton;


-(IBAction)btNextClick:(id)sender;
-(IBAction)btPhotoClick:(id)sender;
@end
