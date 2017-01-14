//
//  NSBubbleMap.h
//  InstantMessenger
//
//  Created by Wang MeiHua on 4/1/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol NSBubbleMapDelegate <NSObject>

-(void)mapTouched:(float)lat :(float)lng;

@end

@interface NSBubbleMap : UIView
{
	IBOutlet MKMapView *mapView;
	float latitude;
	float longitude;
}
+ (id)customView;
-(void)initWithLocation:(NSString*)location;

@property (nonatomic,retain) id<NSBubbleMapDelegate> delegate;
@end
