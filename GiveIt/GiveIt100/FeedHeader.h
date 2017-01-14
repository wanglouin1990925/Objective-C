//
//  FeedHeader.h
//  GiveIt100
//
//  Created by Wang MeiHua on 1/13/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FeedHeaderDelegate < NSObject >

- (void)userProfileAction:(int)nIndex;
- (void)projectAction:(int)nIndex;

@end

@interface FeedHeader : UIView
{
    int nIndex;
}

@property (nonatomic, assign) id<FeedHeaderDelegate> delegate;

@property (nonatomic,retain) IBOutlet UIImageView *imgPhoto;
@property (nonatomic,retain) IBOutlet UILabel *lblName;
@property (nonatomic,retain) IBOutlet UILabel *lblTitle;

+ (id)customView;
- (void)initData:(NSDictionary*)_dict:(int)_nIndex;
@end
