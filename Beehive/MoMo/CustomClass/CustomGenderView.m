//
//  CustomGenderView.m
//  MoMo
//
//  Created by King on 11/18/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "CustomGenderView.h"

@implementation CustomGenderView

@synthesize delegate;

+ (id)sharedView
{
	CustomGenderView *customView = [[[NSBundle mainBundle] loadNibNamed:@"CustomGenderView" owner:nil options:nil] lastObject];
    
	// make sure customView is not nil or the wrong class!
    if ([customView isKindOfClass:[CustomGenderView class]])
        return customView;
    else
        return nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(IBAction)btDoneClick:(id)sender
{
	[delegate DidGenderViewDissmiss:1 gender:[[pickerView delegate] pickerView:pickerView titleForRow:[pickerView selectedRowInComponent:0] forComponent:0] view:self];
}

-(IBAction)btCancelClick:(id)sender
{
	[delegate DidGenderViewDissmiss:0 gender:@"" view:self];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return 2;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if (row == 0)
		return @"Male";
	else
		return @"Female";
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
