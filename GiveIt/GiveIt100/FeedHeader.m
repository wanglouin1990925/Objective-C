//
//  FeedHeader.m
//  GiveIt100
//
//  Created by Wang MeiHua on 1/13/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "FeedHeader.h"
#import "UIImageView+AFNetworking.h"
#import "YYYCommunication.h"

@implementation FeedHeader

@synthesize lblName;
@synthesize lblTitle;
@synthesize imgPhoto;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (id)customView
{
    FeedHeader *customView = [[[NSBundle mainBundle] loadNibNamed:@"FeedHeader" owner:nil options:nil] lastObject];
    
    // make sure customView is not nil or the wrong class!
    if ([customView isKindOfClass:[FeedHeader class]])
        return customView;
    else
        return nil;
}

- (void)initData:(NSDictionary*)_dict :(int)_nIndex;
{
    imgPhoto.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    imgPhoto.layer.borderWidth = 1.0f;
    imgPhoto.layer.cornerRadius = imgPhoto.frame.size.height/2.0f;
    imgPhoto.clipsToBounds = YES;
    
    [lblName sizeToFit];
    [lblTitle sizeToFit];
    
    nIndex = _nIndex;
    
    UITapGestureRecognizer *avatarGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClicked)];
    [self.imgPhoto addGestureRecognizer:avatarGesture];
    
    UITapGestureRecognizer *nameGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameClicked)];
    [self.lblName addGestureRecognizer:nameGesture];
    
    UITapGestureRecognizer *titleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(projectClicked)];
    [self.lblTitle addGestureRecognizer:titleGesture];
    
    [imgPhoto setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WEBAPI_URL,[[_dict objectForKey:@"userinfo"] objectForKey:@"user_avatar"]]]];
    [lblName setText:[[_dict objectForKey:@"userinfo"] objectForKey:@"user_username"]];
    [lblTitle setText:[_dict objectForKey:@"title"]];
}

-(void)photoClicked
{
    [self.delegate userProfileAction:nIndex];
}

-(void)nameClicked
{
    [self.delegate userProfileAction:nIndex];
}

-(void)projectClicked
{
    [self.delegate projectAction:nIndex];
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
