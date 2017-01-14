//
//  YYYDateListController.h
//  GiveIt100
//
//  Created by Wang MeiHua on 1/13/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddVideoCell.h"
#import <MediaPlayer/MediaPlayer.h>

@interface YYYDateListController : UIViewController<UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,AddVideoCellDelegate,UIScrollViewDelegate>
{
    IBOutlet UITableView *tbl_date;
    int nDiff;
    
    NSDate *lastDate;
    NSDateFormatter *formatter;
    NSMutableArray *lstMissedList;
    
    NSString *daynumber;
    NSString *date;
    
    BOOL bRecord;
    
}
@property (nonatomic,retain) NSDictionary *dictProject;
@end
