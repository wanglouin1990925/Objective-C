//
//  YYYPrListController.h
//  GiveIt100
//
//  Created by Wang MeiHua on 1/13/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYYPrListController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *tbl_project;
}

@property (nonatomic,retain) NSArray *lst_project;

@end
