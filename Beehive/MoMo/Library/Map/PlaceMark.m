//
//  PlaceMark.m
//
//  Created by kadir pekel on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PlaceMark.h"
#import "Place.h"

@implementation PlaceMark

@synthesize coordinate;
@synthesize place;

-(id) initWithPlace: (Place*) p
{
	self = [super init];
	if (self != nil) {
		coordinate.latitude = p.latitude;
		coordinate.longitude = p.longitude;
		self.place = p;
	}
	return self;
}
- (NSString *)title
{
	return self.place.name;
}
- (NSString *)subtitle
{
    return self.place.desription;
}
@end

