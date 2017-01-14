//
//  CustomRateMe.h
//  DND
//
//  Created by Wang MeiHua on 11/4/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DXStarRatingView.h"

@protocol CustomRateDelegate <NSObject>

-(void)DidCancelClicked:(id)view;
-(void)DidSendClicked:(float)star comment:(NSString*)comment nickname:(NSString*)nickname view:(id)view;

@end

@interface CustomRateMe : UIView<UITextViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate>
{
	IBOutlet UITextView *txtView;
	IBOutlet UIView *vwRate;
	IBOutlet UIScrollView *scvContent;
	IBOutlet UIButton *btNickname;
	
	IBOutlet UISlider *sldAtt;
	IBOutlet UISlider *sldPer;
	IBOutlet UISlider *sldAmb;
	IBOutlet UISlider *sldInt;
	IBOutlet UISlider *sldCre;
	IBOutlet UISlider *sldMan;
	IBOutlet UISlider *sldGoo;
	
	UIImage *imgStar1;
	UIImage *imgStar2;
	UIImage *imgStar3;
	UIImage *imgStar4;
	UIImage *imgStar5;
}

-(IBAction)btCancelClick:(id)sender;
-(IBAction)btSendClick:(id)sender;
+ (id)sharedView;
-(void)initUI;

@property (nonatomic,retain) id<CustomRateDelegate> delegate;

@property (weak, nonatomic) IBOutlet DXStarRatingView *starRatingView1;
@property (weak, nonatomic) IBOutlet DXStarRatingView *starRatingView2;
@property (weak, nonatomic) IBOutlet DXStarRatingView *starRatingView3;
@property (weak, nonatomic) IBOutlet DXStarRatingView *starRatingView4;
@property (weak, nonatomic) IBOutlet DXStarRatingView *starRatingView5;
@property (weak, nonatomic) IBOutlet DXStarRatingView *starRatingView6;
@property (weak, nonatomic) IBOutlet DXStarRatingView *starRatingView7;
@end
