//
//  YYYNotificationCell.h
//  GiveIt100
//
//  Created by Wang MeiHua on 1/17/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YYYNotificationCellDelegate < NSObject >

- (void)userProfileAction:(NSDictionary*)dict;
- (void)feedAction:(NSDictionary*)dict;

@end

@interface YYYNotificationCell : UITableViewCell
{
    NSDictionary *dict;
}
@property (nonatomic, assign) id<YYYNotificationCellDelegate> delegate;

@property (nonatomic,retain) IBOutlet UIImageView *profileImageView;
@property (nonatomic,retain) IBOutlet UIImageView *picImageView;
@property (nonatomic,retain) IBOutlet UILabel *contentLabel;
@property (nonatomic,retain) IBOutlet UILabel *dateLabel;

-(void)initwithData:(NSDictionary*)_dict;
@end