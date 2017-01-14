//
//  YYYSProjectController.h
//  GiveIt100
//
//  Created by Wang MeiHua on 1/11/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYYSProjectController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *tblProject;
    NSMutableArray *lstProjects;
}
-(IBAction)btAddClick:(id)sender;
@end
