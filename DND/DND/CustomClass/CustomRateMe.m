//
//  CustomRateMe.m
//  DND
//
//  Created by Wang MeiHua on 11/4/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "CustomRateMe.h"

@implementation CustomRateMe

@synthesize delegate;
@synthesize starRatingView1;
@synthesize starRatingView2;
@synthesize starRatingView3;
@synthesize starRatingView4;
@synthesize starRatingView5;
@synthesize starRatingView6;
@synthesize starRatingView7;

+ (id)sharedView
{
	CustomRateMe *customView = [[[NSBundle mainBundle] loadNibNamed:@"CustomRateMe" owner:nil options:nil] lastObject];
    
	// make sure customView is not nil or the wrong class!
    if ([customView isKindOfClass:[CustomRateMe class]])
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

-(void)initUI
{
	self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
	self.layer.borderWidth = 1.0f;
	self.layer.cornerRadius = 2.0f;
	self.clipsToBounds = YES;
	
	txtView.layer.borderColor = [[UIColor grayColor] CGColor];
	txtView.layer.borderWidth = 1.0;
	
	[scvContent setContentSize:CGSizeMake(scvContent.frame.size.width, scvContent.frame.size.height + 216)];
	
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
	tapGesture.delegate = self;
	[scvContent addGestureRecognizer:tapGesture];
	
	imgStar1 = [self imageWithColor:[UIColor redColor]];
	imgStar2 = [self imageWithColor:[UIColor colorWithRed:255/255.0f green:127/255.0f blue:3/255.0f alpha:1.0f]];
	imgStar3 = [self imageWithColor:[UIColor colorWithRed:255/255.0f green:0/255.0f blue:255/255.0f alpha:1.0f]];
	imgStar4 = [self imageWithColor:[UIColor colorWithRed:0/255.0f green:255/255.0f blue:0/255.0f alpha:1.0f]];
	imgStar5 = [self imageWithColor:[UIColor blueColor]];
	
	[sldAmb setMaximumTrackImage:imgStar1 forState:UIControlStateNormal];
	[sldAmb setMinimumTrackImage:imgStar1 forState:UIControlStateNormal];
	
	[sldAtt setMaximumTrackImage:imgStar1 forState:UIControlStateNormal];
	[sldAtt setMinimumTrackImage:imgStar1 forState:UIControlStateNormal];
	
	[sldPer setMaximumTrackImage:imgStar1 forState:UIControlStateNormal];
	[sldPer setMinimumTrackImage:imgStar1 forState:UIControlStateNormal];
	
	[sldInt setMaximumTrackImage:imgStar1 forState:UIControlStateNormal];
	[sldInt setMinimumTrackImage:imgStar1 forState:UIControlStateNormal];
	
	[sldCre setMaximumTrackImage:imgStar1 forState:UIControlStateNormal];
	[sldCre setMinimumTrackImage:imgStar1 forState:UIControlStateNormal];
	
	[sldMan setMaximumTrackImage:imgStar1 forState:UIControlStateNormal];
	[sldMan setMinimumTrackImage:imgStar1 forState:UIControlStateNormal];
	
	[sldGoo setMaximumTrackImage:imgStar1 forState:UIControlStateNormal];
	[sldGoo setMinimumTrackImage:imgStar1 forState:UIControlStateNormal];
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 2.0f, 2.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
	
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return image;
}

-(IBAction)slideValueChanged:(id)sender
{
	UISlider *slider = (UISlider*)sender;
	float fScore = slider.value;
	
	[((UILabel*)[self viewWithTag:slider.tag + 100]) setText:[NSString stringWithFormat:@"%.1f",fScore]];
	
	if (fScore < 2)
	{
		[slider setMaximumTrackImage:imgStar1 forState:UIControlStateNormal];
		[slider setMinimumTrackImage:imgStar1 forState:UIControlStateNormal];
	}
	else if (fScore < 4)
	{
		[slider setMaximumTrackImage:imgStar2 forState:UIControlStateNormal];
		[slider setMinimumTrackImage:imgStar2 forState:UIControlStateNormal];
	}
	else if (fScore < 6)
	{
		[slider setMaximumTrackImage:imgStar3 forState:UIControlStateNormal];
		[slider setMinimumTrackImage:imgStar3 forState:UIControlStateNormal];
	}
	else if (fScore < 8)
	{
		[slider setMaximumTrackImage:imgStar4 forState:UIControlStateNormal];
		[slider setMinimumTrackImage:imgStar4 forState:UIControlStateNormal];
	}
	else
	{
		[slider setMaximumTrackImage:imgStar5 forState:UIControlStateNormal];
		[slider setMinimumTrackImage:imgStar5 forState:UIControlStateNormal];
	}
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
	UIView *hitView = [gestureRecognizer.view hitTest:[gestureRecognizer locationInView:gestureRecognizer.view] withEvent:nil];
	if ([hitView isKindOfClass:[UITextView class]] || [hitView isKindOfClass:[DXStarRatingView class]])
	{
		return NO;
	}
	return YES;
}

-(void)tapDetected
{
	[scvContent setContentOffset:CGPointMake(0, 0)];
	[self endEditing:YES];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	[scvContent setContentOffset:CGPointMake(0, 216)];
	return YES;
}

//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//	[UIView animateWithDuration:1.0 animations:^{
//		CGRect rt = vwRate.frame;
//		rt.origin.y = rt.origin.y - 216;
//		vwRate.frame = rt;
//	} completion:^(BOOL finished) {
//		
//	}];
//	
//	return YES;
//}
//
//-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
//{
//	[UIView animateWithDuration:1.0 animations:^{
//		CGRect rt = vwRate.frame;
//		rt.origin.y = rt.origin.y + 216;
//		vwRate.frame = rt;
//	} completion:^(BOOL finished) {
//		
//	}];
//	
//	return YES;
//}

-(IBAction)btCancelClick:(id)sender
{
	[delegate DidCancelClicked:self];
}

-(IBAction)btSendClick:(id)sender
{
	if (txtView.text.length < 1)
	{
		[self showAlert:@"Oops!" message:@"Please input review"];
		return;
	}
	
	if ([btNickname.titleLabel.text isEqualToString:@"Select a nickname"])
	{
		[self showAlert:@"Oops!" message:@"Please select nickname"];
		return;
	}
	
	if (txtView.text.length < 5)
	{
		[self showAlert:@"Oops!" message:@"Review need to be at least 5 characters"];
		return;
	}
	
	if (![self valideString:txtView.text.lowercaseString])
	{
		[self showAlert:@"Oops!" message:@"Review can't contain link or hyperlink."];
		return;
	}
	
//	float star = (starRatingView1._stars + starRatingView2._stars + starRatingView3._stars + starRatingView4._stars + starRatingView5._stars + starRatingView6._stars + starRatingView7._stars)/7.0f;

	float star = 0;
	
	for (int i = 200; i < 207; i++)
	{
		UILabel *lbl = (UILabel*)[self viewWithTag:i];
		star = star + lbl.text.floatValue;
	}
	
	star = star/14.0f;
	star = [[NSString stringWithFormat:@"%.1f",star] floatValue];	
	
	[delegate DidSendClicked:star comment:txtView.text nickname:btNickname.titleLabel.text view:self];
}

-(BOOL)valideString:(NSString*)string
{
	if ([string hasPrefix:@"http://"] || [string hasPrefix:@"https://"] || [string hasPrefix:@"ftp://"] || [string hasPrefix:@"mailto://"])
	{
		return NO;
	}
	
	return YES;
}

-(void)showAlert:(NSString*)title message:(NSString*)message
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
}

-(IBAction)btSelNiceNameClick:(id)sender
{
	[txtView resignFirstResponder];
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Select a nickname" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Friend",@"Boyfriend",@"Girlfriend",@"Ex-Boyfriend",@"Ex-Girlfriend", nil];
	[sheet showInView:self];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
		[btNickname setTitle:@"Friend" forState:UIControlStateNormal];
	}
	else if (buttonIndex == 1)
	{
		[btNickname setTitle:@"Boyfriend" forState:UIControlStateNormal];
	}
	else if (buttonIndex == 2)
	{
		[btNickname setTitle:@"Girlfriend" forState:UIControlStateNormal];
	}
	else if (buttonIndex == 3)
	{
		[btNickname setTitle:@"Ex-Boyfriend" forState:UIControlStateNormal];
	}
	else if (buttonIndex == 4)
	{
		[btNickname setTitle:@"Ex-Girlfriend" forState:UIControlStateNormal];
	}
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
