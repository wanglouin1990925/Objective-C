//
//  YYYFeedController.h
//  GiveIt100
//
//  Created by Wang MeiHua on 1/17/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedHeader.h"
#import "FeedCell.h"

@interface YYYFeedController : UIViewController<UITableViewDataSource,UITableViewDelegate,FeedHeaderDelegate,FeedCellDelegate>
{
    IBOutlet UITableView *tbl_project;
    NSMutableDictionary *dict;
    NSString *strUserID;
}
@property (nonatomic,retain) NSString *strPostID;
@end
