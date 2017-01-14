//
//  CustomPendingCell.h
//  MoMo
//
//  Created by King on 12/12/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomPendingCellDelegate <NSObject>

-(void)DidAcceptClicked:(int)index;
-(void)DidDeclineClicked:(int)index;

@end

@interface CustomPendingCell : UITableViewCell

@property int index;
@property (nonatomic,retain) id<CustomPendingCellDelegate> delegate;

-(IBAction)btAcceptClick:(id)sender;
-(IBAction)btDeclineClick:(id)sender;

@end
