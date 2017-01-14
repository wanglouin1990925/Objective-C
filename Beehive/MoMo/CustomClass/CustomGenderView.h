//
//  CustomGenderView.h
//  MoMo
//
//  Created by King on 11/18/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GenderViewDelegate <NSObject>

-(void)DidGenderViewDissmiss:(int)buttonIndex gender:(NSString*)gender view:(id)view;

@end

@interface CustomGenderView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
	IBOutlet UIPickerView *pickerView;
}

+ (id)sharedView;

-(IBAction)btDoneClick:(id)sender;
-(IBAction)btCancelClick:(id)sender;

@property (nonatomic,retain) id<GenderViewDelegate> delegate;

@end
