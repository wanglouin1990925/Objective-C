//
//  CustomChatsCell.h
//  MoMo
//
//  Created by King on 12/12/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomChatsCellDelegate <NSObject>

-(void)DidAvatarClicked:(int)index :(int)type;

@end

@interface CustomChatsCell : UITableViewCell

@property int index;
@property int type;
@property (nonatomic,retain) id<CustomChatsCellDelegate> delegate;

@end
