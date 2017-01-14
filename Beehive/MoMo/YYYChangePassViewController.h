//
//  YYYChangePassViewController.h
//  MoMo
//
//  Created by King on 11/18/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYYChangePassViewController : UITableViewController
{
	IBOutlet UITextField *txtCurrent;
	IBOutlet UITextField *txtNew;
	IBOutlet UITextField *txtConfirm;
}

-(IBAction)btBackClick:(id)sender;
-(IBAction)btSaveClick:(id)sender;

@end
