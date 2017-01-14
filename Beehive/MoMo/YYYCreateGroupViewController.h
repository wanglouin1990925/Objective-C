//
//  YYYCreateGroupViewController.h
//  MoMo
//
//  Created by King on 11/18/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYYPlacesViewController.h"
#import "SZTextView.h"

@interface YYYCreateGroupViewController : UITableViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PlacesViewDelegate>
{
	IBOutlet UIButton		*btPhoto;
	IBOutlet UITextField	*txtGroupName;
	IBOutlet UILabel		*lblPlace;
	IBOutlet SZTextView		*txtAbout;
	NSDictionary *dictPlace;
}

-(IBAction)btPhotoClick:(id)sender;
-(IBAction)btPlaceClick:(id)sender;
-(IBAction)btBackClick:(id)sender;
-(IBAction)btDoneClick:(id)sender;

@end
