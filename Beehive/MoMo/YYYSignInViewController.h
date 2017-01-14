//
//  YYYSignInViewController.h
//  MoMo
//
//  Created by Wang MeiHua on 11/13/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYYSignInViewController : UITableViewController
{
	IBOutlet UITextField *txtPhone;
	IBOutlet UITextField *txtPass;
}

-(IBAction)btBackClick:(id)sender;
-(IBAction)btDoneClick:(id)sender;

@end
