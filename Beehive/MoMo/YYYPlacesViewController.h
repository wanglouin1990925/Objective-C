//
//  YYYPlacesViewController.h
//  MoMo
//
//  Created by King on 11/19/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlacesViewDelegate <NSObject>

-(void)DidPlaceSelected:(NSDictionary*)dictPlace;

@end

@interface YYYPlacesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
	IBOutlet UITableView *tblPlaces;
	NSMutableArray *lstPlaces;
	
	int nSelectedIndex;
}

-(IBAction)btBackClick:(id)sender;
-(IBAction)btDoneClick:(id)sender;

@property (nonatomic,retain) id<PlacesViewDelegate> delegate;

@end

