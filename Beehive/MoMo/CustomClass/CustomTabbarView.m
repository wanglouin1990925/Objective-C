//
//  CustomTabbarView.m
//  MoMo
//
//  Created by Wang MeiHua on 10/30/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "CustomTabbarView.h"

@implementation CustomTabbarView

@synthesize delegate;

+ (id)sharedView
{
	CustomTabbarView *customView = [[[NSBundle mainBundle] loadNibNamed:@"CustomTabbarView" owner:nil options:nil] lastObject];
    
	// make sure customView is not nil or the wrong class!
    if ([customView isKindOfClass:[CustomTabbarView class]])
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

-(IBAction)btTab1Click:(id)sender
{
	[self setCurrentTab:0];
}

-(IBAction)btTab2Click:(id)sender
{
	[self setCurrentTab:1];
}

-(IBAction)btTab3Click:(id)sender
{
	[self setCurrentTab:2];
}

-(IBAction)btTab4Click:(id)sender
{
	[self setCurrentTab:3];
}

-(IBAction)btTab5Click:(id)sender
{
	[self setCurrentTab:4];
}

-(void)setCurrentTab:(int)index
{
	[imvTab1 setImage:[UIImage imageNamed:@"tabbar_location_normal"]];
	[lblTab1 setTextColor:[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1.0]];
	
	[imvTab2 setImage:[UIImage imageNamed:@"tabbar_search_normal"]];
	[lblTab2 setTextColor:[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1.0]];
	
	[imvTab3 setImage:[UIImage imageNamed:@"tabbar_chat_normal"]];
	[lblTab3 setTextColor:[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1.0]];
	
	[imvTab4 setImage:[UIImage imageNamed:@"tabbar_group_normal"]];
	[lblTab4 setTextColor:[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1.0]];
	
	[imvTab5 setImage:[UIImage imageNamed:@"tabbar_profile_normal"]];
	[lblTab5 setTextColor:[UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1.0]];
	
	if (index == 0)
	{
		[imvTab1 setImage:[UIImage imageNamed:@"tabbar_location_sel"]];
		[lblTab1 setTextColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0]];
	}
	else if (index == 1)
	{
		[imvTab2 setImage:[UIImage imageNamed:@"tabbar_search_sel"]];
		[lblTab2 setTextColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0]];
	}
	else if (index == 2)
	{
		[imvTab3 setImage:[UIImage imageNamed:@"tabbar_chat_sel"]];
		[lblTab3 setTextColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0]];
	}
	else if (index == 3)
	{
		[imvTab4 setImage:[UIImage imageNamed:@"tabbar_group_sel"]];
		[lblTab4 setTextColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0]];
	}
	else if (index == 4)
	{
		[imvTab5 setImage:[UIImage imageNamed:@"tabbar_profile_sel"]];
		[lblTab5 setTextColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0]];
	}
	
	[delegate DidTabbarClicked:index];
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
