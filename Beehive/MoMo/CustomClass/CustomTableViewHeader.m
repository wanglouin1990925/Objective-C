//
//  CustomTableViewHeader.m
//  MoMo
//
//  Created by Wang MeiHua on 10/30/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "CustomTableViewHeader.h"

@implementation CustomTableViewHeader

+ (id)sharedView
{
	CustomTableViewHeader *customView = [[[NSBundle mainBundle] loadNibNamed:@"CustomTableViewHeader" owner:nil options:nil] lastObject];
    
	// make sure customView is not nil or the wrong class!
    if ([customView isKindOfClass:[CustomTableViewHeader class]])
        return customView;
    else
        return nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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
