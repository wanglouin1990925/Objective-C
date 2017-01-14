//
//  YYYTermsViewController.m
//  GiveIt100
//
//  Created by Wang MeiHua on 2/19/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYTermsViewController.h"

@interface YYYTermsViewController ()

@end

@implementation YYYTermsViewController

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
    
    UIColor* mainColor = [UIColor colorWithRed:50.0f/255 green:79.0f/255 blue:133.0f/255 alpha:1.0f];
    
    UIImage *imgForBack = [ self imageWithColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBackgroundImage:imgForBack forBarMetrics:UIBarMetricsDefault];
    
    //    [[UINavigationBar appearance] setBarTintColor:darkColor];
    
    NSString* boldFontName = @"Avenir-Black";
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:boldFontName size:25.0], NSFontAttributeName,
                                mainColor, NSForegroundColorAttributeName, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    
    [scvTerms setContentSize:CGSizeMake(320, 6700)];
	// Do any additional setup after loading the view.
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
	
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return image;
}

-(IBAction)btBackClick:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
