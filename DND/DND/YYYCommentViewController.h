//
//  YYYCommentViewController.h
//  DND
//
//  Created by Wang MeiHua on 11/6/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYYCommentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
	IBOutlet UITableView *tblComment;
	IBOutlet UIView *vwTextfield;
	IBOutlet UITextField *txtComment;
}

-(IBAction)btSendClick:(id)sender;
-(IBAction)btBackClick:(id)sender;

@property (nonatomic,retain) NSMutableArray *lstComment;
@property (nonatomic,retain) NSString *rateid;
@property (nonatomic,retain) NSString *facebookid;

@property BOOL bMyProfile;

@end
