//
//  YYYLocationController.m
//  InstantMessenger
//
//  Created by Wang MeiHua on 2/28/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYLocationController.h"
#import "YYYAppDelegate.h"
#import <MapKit/MapKit.h>

@interface YYYLocationController ()

@end

@implementation YYYLocationController

@synthesize fLng;
@synthesize fLat;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(fLat, fLng);
    MKCoordinateSpan span = MKCoordinateSpanMake(1, 1);
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
	
    [mapView setRegion:region animated:TRUE];
	
	// Do any additional setup after loading the view.
}

-(UIImage*)imageCapture:(CGRect)_frame
{
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGRect rect= _frame;
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([viewImage CGImage], rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    
    return image;
}

-(IBAction)btBackClick:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
