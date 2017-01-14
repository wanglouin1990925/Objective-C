//
//  CustomNotifcationCell.m
//  DND
//
//  Created by Wang MeiHua on 10/10/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "CustomNotifcationCell.h"

@implementation CustomNotifcationCell

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
	
	UIImageView *imvProfileImageView = (UIImageView*)[self viewWithTag:100];
	imvProfileImageView.layer.cornerRadius = imvProfileImageView.frame.size.height/2.0f;
	imvProfileImageView.clipsToBounds = YES;
}

-(void)initWithData:(NSDictionary*)dict
{
	UILabel *lblContent = (UILabel*)[self viewWithTag:100];
	[lblContent setText:[dict objectForKey:@"not_content"]];
	
	UILabel *lblDate = (UILabel*)[self viewWithTag:101];
	[lblDate setText:[self getDiffString:[[dict objectForKey:@"timediff"] intValue]]];
}

-(NSString*)getDiffString:(int)diffSec
{
	if (diffSec < 60)
	{
		return [NSString stringWithFormat:@"%dsecs ago",diffSec];
	}
	else if (diffSec < 60*60)
	{
		return [NSString stringWithFormat:@"%dmins ago",diffSec/60];
	}
	else if (diffSec <  60*60*60)
	{
		return [NSString stringWithFormat:@"%dhours ago",diffSec/3600];
	}
	else if (diffSec <  60*60*60*60)
	{
		return [NSString stringWithFormat:@"%ddays ago",diffSec/216000];
	}
	else
	{
		return [NSString stringWithFormat:@"%dmonths ago",diffSec/12960000];
	}
	
	return @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
