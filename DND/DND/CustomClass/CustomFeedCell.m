//
//  FeedCell2.m
//  ADVFlatUI
//
//  Created by Tope on 03/06/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "CustomFeedCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation CustomFeedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)awakeFromNib{
    
    self.picImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.picImageView.clipsToBounds = YES;
    self.picImageView.layer.cornerRadius = 2.0f;
	
    self.picImageContainer.backgroundColor = [UIColor whiteColor];
    self.picImageContainer.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:0.6f].CGColor;
    self.picImageContainer.layer.borderWidth = 1.0f;
    self.picImageContainer.layer.cornerRadius = 2.0f;

    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2.0f;
	self.profileImageView.clipsToBounds = YES;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
