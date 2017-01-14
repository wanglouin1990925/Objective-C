//
//  CustomTabbar.m
//  Blender
//
//  Created by Wang MeiHua on 5/16/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "CustomTabbar.h"

@implementation CustomTabbar

@synthesize delegate;

+ (id)sharedView
{
	CustomTabbar *customView = [[[NSBundle mainBundle] loadNibNamed:@"CustomTabbar" owner:nil options:nil] lastObject];
    
	// make sure customView is not nil or the wrong class!
    if ([customView isKindOfClass:[CustomTabbar class]])
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

-(void)initWithIndex:(int)index
{
	
}

-(IBAction)button1Click:(id)sender
{
	[delegate tabbarItemClicked:0];
}

-(IBAction)button2Click:(id)sender
{
	[delegate tabbarItemClicked:1];
}

-(IBAction)button3Click:(id)sender
{
	[delegate tabbarItemClicked:2];
}

@end
