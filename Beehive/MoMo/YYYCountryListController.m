//
//  YYYCountryListController.m
//  MoMo
//
//  Created by King on 11/18/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYCountryListController.h"

@interface YYYCountryListController ()

@end

@implementation YYYCountryListController

@synthesize delegate;

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
	
	NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countries" ofType:@"json"]];
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    
    if (localError != nil)
    {
        NSLog(@"%@", [localError userInfo]);
    }
	
    countriesList = (NSArray *)parsedObject;
	nSelected = -1;
	
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO];
}

-(IBAction)btBackClick:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btDoneClick:(id)sender
{
	if (nSelected ==-1 )
		return;
			
	[delegate DidCountrySelected:[[countriesList objectAtIndex:nSelected] objectForKey:@"name"] code:[[countriesList objectAtIndex:nSelected] objectForKey:@"dial_code"]];
	[self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [countriesList count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	
	UILabel *lblName = (UILabel*)[cell viewWithTag:100];
	[lblName setText:[[countriesList objectAtIndex:indexPath.row] objectForKey:@"name"]];
	
	UILabel *lblCode = (UILabel*)[cell viewWithTag:101];
	[lblCode setText:[[countriesList objectAtIndex:indexPath.row] objectForKey:@"dial_code"]];
	
	cell.accessoryType = UITableViewCellAccessoryNone;
	
	if (nSelected == indexPath.row)
	{
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	nSelected = (int)indexPath.row;
	[tblCountry reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
