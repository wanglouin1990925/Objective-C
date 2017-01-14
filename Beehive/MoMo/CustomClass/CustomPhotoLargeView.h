//
//  CustomPhotoLargeView.h
//  DND
//
//  Created by Wang MeiHua on 10/21/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomPhotoLargeViewDelegate <NSObject>

-(void)DidBackClick:(id)view;

@end

@interface CustomPhotoLargeView : UIView<UIScrollViewDelegate>
{
	IBOutlet UIScrollView *scvLargePhoto;
	IBOutlet UILabel *lblTitle;
	int nPhotoCount;
}

-(IBAction)btBackClick:(id)sender;
-(IBAction)btNextClick:(id)sender;
-(IBAction)btPreClick:(id)sender;

+ (id)sharedView;
- (void)initWithData:(NSArray*)lstPhoto;
- (void)setCurrentPage:(int)nPage;

@property (nonatomic,retain) id<CustomPhotoLargeViewDelegate> delegate;

@end
