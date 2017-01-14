//
//  CustomTabbar.h
//  Blender
//
//  Created by Wang MeiHua on 5/16/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  CustomTabbarDelegate <NSObject>

-(void)tabbarItemClicked:(int)index;

@end

@interface CustomTabbar : UIView
{

}

-(IBAction)button1Click:(id)sender;
-(IBAction)button2Click:(id)sender;
-(IBAction)button3Click:(id)sender;

+ (id)sharedView;
-(void)initWithIndex:(int)index;

@property (nonatomic,retain) id<CustomTabbarDelegate> delegate;

@end
