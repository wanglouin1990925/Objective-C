//
//  YYYProfileController.h
//  GiveIt100
//
//  Created by Wang MeiHua on 1/10/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "FeedHeader.h"
#import "FeedCell.h"

@interface YYYProjectController : UIViewController<UITableViewDataSource,UITableViewDelegate,FeedHeaderDelegate,FeedCellDelegate,UIScrollViewDelegate>
{
    IBOutlet UITableView *tbl_project;
    NSMutableArray *lstProject;
    NSMutableArray *mArrDisplayCells;
    
    IBOutlet UIView *viewForCategory;
    IBOutlet UIButton *btCategory;
    
    NSString *strCurrentCategory;
    
    BOOL bFirst;
}
-(IBAction)btCategoryClick:(id)sender;
@end
