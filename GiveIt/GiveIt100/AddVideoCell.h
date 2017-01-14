//
//  AddVideoCell.h
//  GiveIt100
//
//  Created by Wang MeiHua on 1/30/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddVideoCellDelegate < NSObject >

- (void)addVideo:(NSString*)_daynumber : (NSString*)_date;

@end

@interface AddVideoCell : UITableViewCell
{
    IBOutlet UIButton *btAddVideo;
    IBOutlet UILabel *lblDayNumber;
    IBOutlet UILabel *lblDate;
    
    NSString *dayNumber;
    NSString *date;
}
@property (nonatomic, assign) id<AddVideoCellDelegate> delegate;
-(void)initwithData:(NSString*)_daynumber : (NSString*)_date :(int)nIndex;
@end
