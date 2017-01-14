//
//  CustomRateCell.m
//  DND
//
//  Created by Wang MeiHua on 11/4/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "CustomRateCell.h"

@implementation CustomRateCell

@synthesize delegate;
@synthesize cellIndex;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)btUpVoteClick:(id)sender
{
	[delegate DidUpvoteClicked:cellIndex];
}

-(IBAction)btDownVoteClick:(id)sender
{
	[delegate DidDownvoteClicked:cellIndex];
}

-(IBAction)btReportClick:(id)sender
{
	[delegate DidReportClicked:cellIndex];
}

-(IBAction)btCommentClick:(id)sender
{
	[delegate DidCommentClicked:cellIndex];
}

@end
