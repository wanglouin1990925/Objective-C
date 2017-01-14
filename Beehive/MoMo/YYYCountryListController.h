//
//  YYYCountryListController.h
//  MoMo
//
//  Created by King on 11/18/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CountryListDelegate <NSObject>

-(void)DidCountrySelected:(NSString*)country code:(NSString*)code;

@end

@interface YYYCountryListController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
	IBOutlet UITableView *tblCountry;
	NSArray *countriesList;
	
	int nSelected;
}

-(IBAction)btBackClick:(id)sender;
-(IBAction)btDoneClick:(id)sender;

@property (nonatomic,retain) id<CountryListDelegate> delegate;

@end
