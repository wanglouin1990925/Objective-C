//
//  YYYNotificationController.h
//  GiveIt100
//
//  Created by Wang MeiHua on 1/11/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYYNotificationCell.h"

@interface YYYNotificationController : UIViewController<UITableViewDelegate,UITableViewDataSource,YYYNotificationCellDelegate>
{
    NSMutableArray *lstNewContent;
    IBOutlet UITableView *tbl_notification;
}
@end
