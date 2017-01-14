//
//  ProfileCell.m
//  GiveIt100
//
//  Created by Wang MeiHua on 1/13/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "ProfileCell.h"
#import "YYYCommunication.h"
#import "UIImageView+AFNetworking.h"

@implementation ProfileCell

@synthesize imgPhoto;
@synthesize lblName;
@synthesize lblBio;
@synthesize lblFollowers;
@synthesize delegate;
@synthesize btEditProfile;

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

- (void)initData:(NSDictionary*)dict : (NSString*)_follower;
{
    if (!dict) {
        return;
    }
    self.imgPhoto.contentMode = UIViewContentModeScaleAspectFill;
    self.imgPhoto.clipsToBounds = YES;
    self.imgPhoto.layer.cornerRadius = self.imgPhoto.frame.size.width/2.0f;
    self.imgPhoto.layer.borderWidth = 2.0f;
    self.imgPhoto.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [btEditProfile addTarget:self.delegate action:@selector(editProfileAction:) forControlEvents:UIControlEventTouchUpInside];

    //
    [self.imgPhoto setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WEBAPI_URL,[dict objectForKey:@"user_avatar"]]]];
    [self.lblName setText:[dict objectForKey:@"user_username"]];
    [self.lblFollowers setText:[NSString stringWithFormat:@"%@ Follower",_follower]];
    [self.lblBio setText:[dict objectForKey:@"user_bio"]];

}

@end
