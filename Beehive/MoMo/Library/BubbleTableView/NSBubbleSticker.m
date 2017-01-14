//
//  NSBubbleSticker.m
//  PiformulaApp
//
//  Created by Wang MeiHua on 4/2/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "NSBubbleSticker.h"

@implementation NSBubbleSticker

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
	NSBubbleSticker *customView = [[[NSBundle mainBundle] loadNibNamed:@"NSBubbleSticker" owner:nil options:nil] lastObject];
    
    // make sure customView is not nil or the wrong class!
    if ([customView isKindOfClass:[NSBubbleSticker class]])
        return customView;
    else
        return nil;
}

-(void)initWithSticker:(NSString*)stickerid
{
	[imvSticker setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",stickerid]]];
}

@end
