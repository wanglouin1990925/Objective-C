//
//  NSBubbleMap.m
//  InstantMessenger
//
//  Created by Wang MeiHua on 4/1/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "NSBubbleMap.h"
#import "PlaceMark.h"
#import "Place.h"

@implementation NSBubbleMap

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (id)customView
{
    NSBubbleMap *customView = [[[NSBundle mainBundle] loadNibNamed:@"NSBubbleMap" owner:nil options:nil] lastObject];
    
    // make sure customView is not nil or the wrong class!
    if ([customView isKindOfClass:[NSBubbleMap class]])
        return customView;
    else
        return nil;
}

-(void)initWithLocation:(NSString*)location;
{
	latitude = [[[location componentsSeparatedByString:@","] objectAtIndex:0] floatValue];
	longitude = [[[location componentsSeparatedByString:@","] objectAtIndex:1] floatValue];
	
	CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(1, 1);
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
	
    [mapView setRegion:region animated:TRUE];
	
	Place *pt = [[Place alloc] init];
	pt.latitude		= latitude;
	pt.longitude	= longitude;
	
	PlaceMark *placemark = [[PlaceMark alloc] initWithPlace:pt];
	[mapView removeAnnotations:mapView.annotations];
	
	[mapView addAnnotation:placemark];
	
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleMap)];
	[mapView addGestureRecognizer:tapGesture];
}

-(void)handleMap
{
	[delegate mapTouched:latitude :longitude];
}

@end
