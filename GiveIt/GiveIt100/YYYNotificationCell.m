//
//  YYYNotificationCell.m
//  GiveIt100
//
//  Created by Wang MeiHua on 1/17/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYNotificationCell.h"
#import "UIImageView+AFNetworking.h"

@implementation YYYNotificationCell

@synthesize delegate;
@synthesize dateLabel;
@synthesize contentLabel;
@synthesize picImageView;
@synthesize profileImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)initwithData:(NSDictionary*)_dict
{
    dict = _dict;
    
    UITapGestureRecognizer *avatarGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileClicked)];
    [self.profileImageView addGestureRecognizer:avatarGesture];
    
    UITapGestureRecognizer *nameGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(feedClicked)];
    [self.picImageView addGestureRecognizer:nameGesture];
    
//    [dictContent setObject:[NSString stringWithFormat:@"%@%@",WEBAPI_URL,[dict objectForKey:@"user_avatar"]] forKey:@"avatar"];
//    [dictContent setObject:[NSString stringWithFormat:@"%@ started following you",[dict objectForKey:@"username"]] forKey:@"content"];
//    [dictContent setObject:[self strDiff:[[dict objectForKey:@"diff"] intValue]] forKey:@"diff"];
//    [dictContent setObject:[dict objectForKey:@"date"] forKey:@"date"];
//    [dictContent setObject:[dict objectForKey:@"useridfrom"] forKey:@"userid"];
//    [dictContent setObject:@"" forKey:@"item"];
//    [dictContent setObject:@"" forKey:@"postid"];
    
    [dateLabel setText:[_dict objectForKey:@"diff"]];
    [contentLabel setText:[_dict objectForKey:@"content"]];
    [profileImageView setImageWithURL:[NSURL URLWithString:[_dict objectForKey:@"avatar"]]];
    [picImageView setImageWithURL:[NSURL URLWithString:[_dict objectForKey:@"item"]]];
}

-(void)profileClicked
{
    [self.delegate userProfileAction:dict];
}

-(void)feedClicked
{
    [self.delegate feedAction:dict];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
