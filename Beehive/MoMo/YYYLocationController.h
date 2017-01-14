//
//  YYYLocationController.h
//  InstantMessenger
//
//  Created by Wang MeiHua on 2/28/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface YYYLocationController : UIViewController
{
	IBOutlet MKMapView *mapView;
}

@property float fLat;
@property float fLng;

-(IBAction)btBackClick:(id)sender;

@end
