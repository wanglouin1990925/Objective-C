//
//  UIBubbleTableViewCell.m
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import <QuartzCore/QuartzCore.h>
#import "UIBubbleTableViewCell.h"
#import "NSBubbleData.h"
#import "UIImageView+AFNetworking.h"

#define AvatarHeight 45

@interface UIBubbleTableViewCell ()

@property (nonatomic, retain) UIView *customView;
@property (nonatomic, retain) UIImageView *bubbleImage;
@property (nonatomic, retain) UIImageView *avatarImage;

- (void) setupInternalData;

@end

@implementation UIBubbleTableViewCell

@synthesize data = _data;
@synthesize customView = _customView;
@synthesize bubbleImage = _bubbleImage;
@synthesize showAvatar = _showAvatar;
@synthesize avatarImage = _avatarImage;

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
	[self setupInternalData];
}

#if !__has_feature(objc_arc)
- (void) dealloc
{
    self.data = nil;
    self.customView = nil;
    self.bubbleImage = nil;
    self.avatarImage = nil;
    [super dealloc];
}
#endif

- (void)setDataInternal:(NSBubbleData *)value
{
	self.data = value;
	[self setupInternalData];
}

- (void) setupInternalData
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!self.bubbleImage)
    {
#if !__has_feature(objc_arc)
        self.bubbleImage = [[[UIImageView alloc] init] autorelease];
#else
        self.bubbleImage = [[UIImageView alloc] init];        
#endif
        [self addSubview:self.bubbleImage];
    }
    
	[self setBackgroundColor:[UIColor clearColor]];
	
    NSBubbleType type = self.data.type;
    
    CGFloat width = self.data.view.frame.size.width;
    CGFloat height = self.data.view.frame.size.height;

    CGFloat x = (type == BubbleTypeSomeoneElse) ? 0 : self.frame.size.width - width - self.data.insets.left - self.data.insets.right - AvatarHeight;
    CGFloat y = 0;
	
    // Adjusting the x coordinate for avatar
    if (self.showAvatar)
    {
        [self.avatarImage removeFromSuperview];
		
#if !__has_feature(objc_arc)
        self.avatarImage = [[[UIImageView alloc] init] autorelease];
        [self.avatarImage setImageWithURL:self.data.avatar_url placeholderImage:[UIImage imageNamed:@"anonymousUser.png"]];
#else
        self.avatarImage = [[UIImageView alloc] init];
        [self.avatarImage setImageWithURL:self.data.avatar_url placeholderImage:[UIImage imageNamed:@"anonymousUser.png"]];
#endif
		
        self.avatarImage.layer.masksToBounds = YES;
        self.avatarImage.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.2].CGColor;
//        self.avatarImage.layer.borderWidth = 1.0;
        self.avatarImage.contentMode = UIViewContentModeScaleAspectFill;
		
        CGFloat avatarX = (type == BubbleTypeSomeoneElse) ? 4 : self.frame.size.width - (AvatarHeight + 4);
        CGFloat avatarY = self.frame.size.height - AvatarHeight;
        
        self.avatarImage.frame = CGRectMake(avatarX, avatarY, AvatarHeight, AvatarHeight);
        
//		self.avatarImage.layer.cornerRadius = self.avatarImage.frame.size.height/2.0f;
		
		self.avatarImage.layer.cornerRadius = 10.0f;
		
//        if (type == BubbleTypeSomeoneElse) {
            [self addSubview:self.avatarImage];
//        }
        
        CGFloat delta = self.frame.size.height - (self.data.insets.top + self.data.insets.bottom + self.data.view.frame.size.height);
        if (delta > 0) y = delta ;
        
        if (type == BubbleTypeSomeoneElse) x += AvatarHeight + 4;
        if (type == BubbleTypeMine) x -= 4;
    }

    [self.customView removeFromSuperview];
    self.customView = self.data.view;
    self.customView.frame = CGRectMake(x + self.data.insets.left, y + self.data.insets.top, width, height);
    [self.contentView addSubview:self.customView];

    if (type == BubbleTypeSomeoneElse)
    {
        self.bubbleImage.image = [[UIImage imageNamed:@"bubbleSomeone.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14];

    }
    else {
        self.bubbleImage.image = [[UIImage imageNamed:@"bubbleMine.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:14];
    }
	
	self.bubbleImage.frame = CGRectMake(x, y, width + self.data.insets.left + self.data.insets.right, height + self.data.insets.top + self.data.insets.bottom);
}

@end
