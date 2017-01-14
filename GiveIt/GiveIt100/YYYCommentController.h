//
//  YYYCommentController.h
//  GiveIt100
//
//  Created by Wang MeiHua on 1/31/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYYCommentController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *tbl_comment;
    NSMutableArray *lst_comment;
    
    IBOutlet UIView *viewForComment;
    IBOutlet UITextField *txtComment;
    IBOutlet UIButton *btComment;
}

-(IBAction)btCommentClick:(id)sender;
@property (nonatomic,retain) NSString *strPostID;
@property (nonatomic,retain) NSString *POSTMESSAGE;

@end
