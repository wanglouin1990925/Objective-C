//
//  YYYEditProfileViewController.h
//  MoMo
//
//  Created by King on 11/18/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZTextView.h"
#import "CustomBirthdayView.h"
#import "CustomGenderView.h"

@interface YYYEditProfileViewController : UITableViewController<GenderViewDelegate,BirthdayViewDelegate>
{
	IBOutlet UITextField    *txtName;
	IBOutlet UITextField    *txtUsername;
	IBOutlet SZTextView     *txtAboutme;
	IBOutlet UILabel        *lblGender;
	IBOutlet UILabel        *lblBirthday;
    
    IBOutlet SZTextView     *txtCompany;
    IBOutlet SZTextView     *txtUniversity;
    IBOutlet SZTextView     *txtHometown;
    IBOutlet SZTextView     *txtHobbies;
    IBOutlet SZTextView     *txtMusic;
    IBOutlet SZTextView     *txtBooks;
    IBOutlet SZTextView     *txtMovies;
    IBOutlet SZTextView     *txtLooking;
}
-(IBAction)btBackClick:(id)sender;
-(IBAction)btSaveClick:(id)sender;
-(IBAction)btGenderClick:(id)sender;
-(IBAction)btBirthdayClick:(id)sender;
-(IBAction)btAlbumClick:(id)sender;
-(IBAction)btChangePassClick:(id)sender;
-(IBAction)btLogoutClick:(id)sender;

@end
