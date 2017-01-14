//
//  CustomBirthdayView.m
//  MoMo
//
//  Created by King on 11/18/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "CustomBirthdayView.h"

@implementation CustomBirthdayView

@synthesize delegate;

+ (id)sharedView
{
	CustomBirthdayView *customView = [[[NSBundle mainBundle] loadNibNamed:@"CustomBirthdayView" owner:nil options:nil] lastObject];
    
	// make sure customView is not nil or the wrong class!
    if ([customView isKindOfClass:[CustomBirthdayView class]])
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
	NSDate *date = [datePicker date];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	[delegate DidBirthdayViewDissmiss:1 date:[formatter stringFromDate:date] view:self];
}

-(IBAction)btCancelClick:(id)sender
{
	[delegate DidBirthdayViewDissmiss:0 date:@"" view:self];
}


@end
