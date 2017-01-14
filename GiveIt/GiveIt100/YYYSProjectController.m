//
//  YYYSProjectController.m
//  GiveIt100
//
//  Created by Wang MeiHua on 1/11/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYSProjectController.h"
#import "MBProgressHUD.h"
#import "YYYCommunication.h"
#import "YYYProjectDetailController.h"

@interface YYYSProjectController ()

@end

@implementation YYYSProjectController

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
    
    [self getProjects];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getProjects) name:@"SPROJECTREFRESH" object:nil];
    // Do any additional setup after loading the view.
}

-(void)getProjects
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
        
        // Parse ;
        if( [ [ _responseObject objectForKey : @"success" ] isEqualToString : @"1" ] )
        {
            lstProjects = [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"detail"]];
            [tblProject reloadData];
        }
        else
        {
            [ self  showAlert: @"Connection Error" ] ;
            return ;
        }
    } ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
        // Hide ;
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
        
        // Error ;
        [ self  showAlert: @"Internet Connection Error!" ] ;
    } ;
    
    [[YYYCommunication sharedManager] getmyproject:[[YYYCommunication sharedManager].me objectForKey:@"index"] successed:successed failure:failure];
}

-(void)showAlert:(NSString*)_message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:_message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [lstProjects count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    [cell.textLabel setText:[NSString stringWithFormat:@"I'm %@ for 30days",[[lstProjects objectAtIndex:indexPath.row] objectForKey:@"title"]]];
    [cell.textLabel setNumberOfLines:0];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYYProjectDetailController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYProjectDetailController"];
    viewcontroller.dict = [lstProjects objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

-(IBAction)btAddClick:(id)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
