//
//  CustomTabbarView.h
//  MoMo
//
//  Created by Wang MeiHua on 10/30/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBadge.h"

@protocol CustomTabbarViewDelegate <NSObject>

-(void)DidTabbarClicked:(int)index;

@end

@interface CustomTabbarView : UIView
{
	IBOutlet UIImageView *imvTab1;
	IBOutlet UIImageView *imvTab2;
	IBOutlet UIImageView *imvTab3;
	IBOutlet UIImageView *imvTab4;
	IBOutlet UIImageView *imvTab5;
	
	IBOutlet UILabel *lblTab1;
	IBOutlet UILabel *lblTab2;
	IBOutlet UILabel *lblTab3;
	IBOutlet UILabel *lblTab4;
	IBOutlet UILabel *lblTab5;
	
	CustomBadge *badgeChat;
	CustomBadge *badgeContact;
}

+ (id)sharedView;
-(void)setCurrentTab:(int)index;
-(void)initBadge;

-(IBAction)btTab1Click:(id)sender;
-(IBAction)btTab2Click:(id)sender;
-(IBAction)btTab3Click:(id)sender;
-(IBAction)btTab4Click:(id)sender;
-(IBAction)btTab5Click:(id)sender;

@property (nonatomic,retain) id<CustomTabbarViewDelegate> delegate;

@end
