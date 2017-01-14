//
//  ProfileCell.h
//  GiveIt100
//
//  Created by Wang MeiHua on 1/13/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProfileCellDelegate < NSObject >

- (IBAction)editProfileAction:(id)sender;

@end

@interface ProfileCell : UITableViewCell

@property (nonatomic, assign) id<ProfileCellDelegate> delegate;

@property (nonatomic,retain) IBOutlet UIImageView *imgPhoto;
@property (nonatomic,retain) IBOutlet UILabel *lblName;
@property (nonatomic,retain) IBOutlet UILabel *lblFollowers;
@property (nonatomic,retain) IBOutlet UILabel *lblBio;
@property (nonatomic,retain) IBOutlet UIButton *btEditProfile;

- (void)initData:(NSDictionary*)dict : (NSString*)follower;
@end
