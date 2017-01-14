//
//  YYYProjectDetailController.h
//  GiveIt100
//
//  Created by Wang MeiHua on 2/1/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYYProjectDetailController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField *txtTitle;
    IBOutlet UIButton *btSave;
    IBOutlet UIButton *btDelete;
}
-(IBAction)btSaveClick:(id)sender;
-(IBAction)btDeleteClick:(id)sender;
@property (nonatomic,retain) NSDictionary *dict;
@end
