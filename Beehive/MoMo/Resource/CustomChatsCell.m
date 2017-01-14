//
//  CustomChatsCell.m
//  MoMo
//
//  Created by King on 12/12/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "CustomChatsCell.h"

@implementation CustomChatsCell

@synthesize delegate;
@synthesize index;
@synthesize type;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)btAvatarClick:(id)sender
{
	[delegate DidAvatarClicked:index :type];
}

@end
