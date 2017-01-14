//
//  YYYStartViewController.h
//  MoMo
//
//  Created by Wang MeiHua on 11/13/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYYCountryListController.h"

@interface YYYStartViewController : UIViewController<UIScrollViewDelegate,CountryListDelegate>
{
	IBOutlet UIScrollView	*scvContent;
	IBOutlet UIButton		*btSignUp;
	IBOutlet UIButton		*btLogin;
	IBOutlet UIImageView	*imvSeparate1;
	IBOutlet UIImageView	*imvSeparate2;
	IBOutlet UITextField	*txtPhone;
	IBOutlet UITextField	*txtPass;
	
	IBOutlet UIPageControl	*pageCtl;
	IBOutlet UIButton		*btCountryCode;
}

-(IBAction)btForgotClick:(id)sender;
-(IBAction)btFacebookClick:(id)sender;


@end
