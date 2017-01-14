//
//  CustomPendingCell.m
//  MoMo
//
//  Created by King on 12/12/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "CustomPendingCell.h"

@implementation CustomPendingCell

@synthesize index;
@synthesize delegate;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)btAcceptClick:(id)sender
{
	[delegate DidAcceptClicked:index];
}
-(IBAction)btDeclineClick:(id)sender
{
	[delegate DidDeclineClicked:index];
}

@end
