//
//  YYYHomeController.h
//  GiveIt100
//
//  Created by Wang MeiHua on 1/10/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "ProfileCell.h"
#import "FeedCell.h"

@interface YYYHomeController : UIViewController<UITableViewDelegate,UITableViewDataSource,ProfileCellDelegate,FeedCellDelegate,UIScrollViewDelegate>
{
    IBOutlet UITableView *tbl_profile;
    NSMutableDictionary *dictProfile;
    
    BOOL bFirst;
    
    NSMutableArray *mArrDisplayCells;
}

@end
