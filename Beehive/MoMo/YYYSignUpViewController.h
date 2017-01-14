//
//  YYYSignUpTableViewController.h
//  MoMo
//
//  Created by Wang MeiHua on 11/13/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYYCountryListController.h"
#import "CustomBirthdayView.h"
#import "CustomGenderView.h"

@interface YYYSignUpViewController : UITableViewController<CountryListDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,GenderViewDelegate,BirthdayViewDelegate>
{
	IBOutlet UIButton		*btPhoto;
	IBOutlet UILabel		*lblCountry;
	IBOutlet UITextField	*txtPhone;
	IBOutlet UITextField	*txtPassword;
	IBOutlet UITextField	*txtUsername;
	IBOutlet UITextField	*txtName;
	IBOutlet UIButton		*btGender;
	IBOutlet UIButton		*btBirthday;
	
	NSString *strCountry;
	NSString *strDialCode;
    
    BOOL isPhotoSelected;
}

-(IBAction)btCountryClick:(id)sender;
-(IBAction)btGenderClick:(id)sender;
-(IBAction)btBirthdayClick:(id)sender;
-(IBAction)btPhotoClick:(id)sender;

@end
