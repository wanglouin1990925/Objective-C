//
//  YYYUserProfileController.h
//  GiveIt100
//
//  Created by Wang MeiHua on 1/13/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfileCell.h"
#import "RESideMenu.h"
#import "FeedCell.h"

@interface YYYUserProfileController : UIViewController<UITableViewDataSource,UITableViewDelegate,UserProfileCellDelegate,FeedCellDelegate,UIScrollViewDelegate>
{
    IBOutlet UITableView *tbl_profile;
    NSMutableDictionary *dictProfile;
    
    BOOL bFirst;
    
    NSMutableArray *mArrDisplayCells;
}

@property (nonatomic,retain) NSString *strUserID;

@end
