//
//  CustomSearchCell.m
//  DND
//
//  Created by Wang MeiHua on 10/21/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "CustomSearchCell.h"
#import "UIImageView+AFNetworking.h"

@implementation CustomSearchCell

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
	UIImageView *imvPhoto = (UIImageView*)[self viewWithTag:100];
	imvPhoto.layer.cornerRadius = imvPhoto.frame.size.height/2.0f;
	imvPhoto.clipsToBounds = YES;
	imvPhoto.layer.borderColor = [[UIColor lightGrayColor] CGColor];
	imvPhoto.layer.borderWidth = 1.0f;
}

-(void)initData:(NSDictionary*)dict
{
	UIImageView *imvPhoto = (UIImageView*)[self viewWithTag:100];
	[imvPhoto setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=small",[dict objectForKey:@"id"]]]];
	
	UILabel *lblName = (UILabel*)[self viewWithTag:101];
	[lblName setText:[NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"first_name"],[dict objectForKey:@"last_name"]]];
	
	UILabel *lblRating = (UILabel*)[self viewWithTag:102];
	[lblRating setText:@"Rating : 0.0"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
