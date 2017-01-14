//
//  YYYAddProjectController.h
//  GiveIt100
//
//  Created by Wang MeiHua on 2/2/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYYAddProjectController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
{
    IBOutlet UIButton *btAdd;
    IBOutlet UITextField *txtTitle;
    IBOutlet UIView *viewForCategory;
    
    IBOutlet UIPickerView *pickerView;
    IBOutlet UIButton *btCategory;
    
    NSMutableArray *lstCategory;
}
-(IBAction)btAddClick:(id)sender;
@end
