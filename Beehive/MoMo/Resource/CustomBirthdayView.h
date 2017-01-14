//
//  CustomBirthdayView.h
//  MoMo
//
//  Created by King on 11/18/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BirthdayViewDelegate <NSObject>

-(void)DidBirthdayViewDissmiss:(int)buttonIndex date:(NSString*)date view:(id)view;

@end

@interface CustomBirthdayView : UIView
{
	IBOutlet UIDatePicker *datePicker;
}

+ (id)sharedView;

-(IBAction)btDoneClick:(id)sender;
-(IBAction)btCancelClick:(id)sender;

@property (nonatomic,retain) id<BirthdayViewDelegate> delegate;

@end
