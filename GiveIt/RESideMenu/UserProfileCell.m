//
//  UserProfileCell.m
//  GiveIt100
//
//  Created by Wang MeiHua on 1/13/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "UserProfileCell.h"
#import "UIImageView+AFNetworking.h"
#import "YYYCommunication.h"

@implementation UserProfileCell

@synthesize imgPhoto;
@synthesize lblName;
@synthesize lblBio;
@synthesize lblFollowers;
@synthesize btFollow;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initData:(NSDictionary*)dict : (NSString*)follower : (NSString*)isfollowing;
{
    if (!dict) {
        return;
    }
    
    self.imgPhoto.contentMode = UIViewContentModeScaleAspectFill;
    self.imgPhoto.clipsToBounds = YES;
    self.imgPhoto.layer.cornerRadius = self.imgPhoto.frame.size.width/2.0f;
    self.imgPhoto.layer.borderWidth = 2.0f;
    self.imgPhoto.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    btFollow.clipsToBounds = YES;
    btFollow.layer.cornerRadius = 3.0f;
    [btFollow addTarget:self.delegate action:@selector(followAction) forControlEvents:UIControlEventTouchUpInside];
    
    if ([isfollowing intValue]) {
        [btFollow setTitle:@"Following" forState:UIControlStateNormal];
        [btFollow setBackgroundColor:[UIColor colorWithRed:40/255.0f green:150/255.0f blue:30/255.0f alpha:1.0f]];
    }
    else
    {
        [btFollow setTitle:@"Follow" forState:UIControlStateNormal];
        [btFollow setBackgroundColor:[UIColor colorWithRed:50/255.0f green:150/255.0f blue:150/255.0f alpha:1.0f]];
    }
    
    [self.imgPhoto setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WEBAPI_URL,[dict objectForKey:@"user_avatar"]]]];
    [self.lblName setText:[dict objectForKey:@"user_username"]];
    [self.lblFollowers setText:[NSString stringWithFormat:@"%@ Follower",follower]];
    [self.lblBio setText:[dict objectForKey:@"user_bio"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
