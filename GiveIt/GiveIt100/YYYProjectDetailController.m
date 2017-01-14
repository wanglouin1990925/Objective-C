//
//  YYYProjectDetailController.m
//  GiveIt100
//
//  Created by Wang MeiHua on 2/1/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYProjectDetailController.h"
#import "YYYCommunication.h"
#import "MBProgressHUD.h"

@interface YYYProjectDetailController ()

@end

@implementation YYYProjectDetailController

@synthesize dict;

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
    
    [txtTitle setText:[dict objectForKey:@"title"]];
    btDelete.clipsToBounds = YES;
    btDelete.layer.cornerRadius = 3.0f;
    
    btSave.clipsToBounds = YES;
    btSave.layer.cornerRadius = 3.0f;
	// Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)btDeleteClick:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
        
        // Parse ;
        if( [ [ _responseObject objectForKey : @"success" ] isEqualToString : @"1" ] )
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SPROJECTREFRESH" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
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
    
    [[YYYCommunication sharedManager] deleteproject:[dict objectForKey:@"index"] successed:successed failure:failure];
}

-(IBAction)btSaveClick:(id)sender
{
    if (!txtTitle.text.length) {
        [self showAlert:@"Input Project Title!"];
        return;
    }
    
    NSString* strQuery = [NSString stringWithFormat:@"userid = \"%@\" , title = \"%@\"",[[YYYCommunication sharedManager].me objectForKey:@"index"],txtTitle.text];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
        
        // Parse ;
        if( [ [ _responseObject objectForKey : @"success" ] isEqualToString : @"1" ] )
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SPROJECTREFRESH" object:nil];
            dict = [_responseObject objectForKey:@"detail"];
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
    
    [[YYYCommunication sharedManager] updateproject:[dict objectForKey:@"index"] query:strQuery successed:successed failure:failure];
}

-(void)showAlert:(NSString*)_message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:_message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
