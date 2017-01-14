//
//  YYYVerificationViewController.h
//  MoMo
//
//  Created by King on 11/17/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYYVerificationViewController : UITableViewController
{
	IBOutlet UILabel *lblPhone;
	IBOutlet UITextField *txtCode;
    
    NSString *verificationCode;
}

-(IBAction)btBackClick:(id)sender;
-(IBAction)btDoneClick:(id)sender;
-(IBAction)btResendClick:(id)sender;

@property (nonatomic,retain) NSString	*dialCode;
@property (nonatomic,retain) NSString	*phone;
@property (nonatomic,retain) NSString	*password;
@property (nonatomic,retain) NSString	*username;
@property (nonatomic,retain) NSString	*name;
@property (nonatomic,retain) NSString	*birthday;
@property (nonatomic,retain) NSString	*gender;
@property (nonatomic,retain) UIImage	*imgAvatar;

@end
