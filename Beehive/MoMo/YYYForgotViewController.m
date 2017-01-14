//
//  YYYForgotViewController.m
//  MoMo
//
//  Created by Wang MeiHua on 11/13/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYForgotViewController.h"
#import "YYYAppDelegate.h"
#import "MBProgressHUD.h"
#import "YYYCommunication.h"

@interface YYYForgotViewController ()

@end

@implementation YYYForgotViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//	[txtPhone becomeFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(IBAction)btBackClick:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btDoneClick:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[_responseObject objectForKey:@"success"] isEqualToString:@"1"])
        {
             NSString *_encrypt = [[YYYAppDelegate sharedDelegate] decryptString:[_responseObject objectForKey:@"detail"]];
            [self sendSMS:txtPhone.text :_encrypt];
        }
        else
        {
            [self showAlert:@"Oops!" message:@"Wrong Phone Number"];
        }
    } ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
    {
        [self showAlert:@"Oops!" message:@"An unknown error occured"];
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
    } ;
    
    [[YYYCommunication sharedManager] GetPassword:txtPhone.text
                                        successed:successed
                                          failure:failure];
}

-(void)sendSMS:(NSString*)_phone :(NSString*)_code
{
    NSString *kTwilioSID	= @"AC674ae67d28f73b7851f24f04a97126d5";
    NSString *kTwilioSecret = @"1be019a3822b7ead874a1dcd4cfcbb3f";
    NSString *kFromNumber	= @"+19012014523";
    
    NSString *kToNumber = _phone;
    NSString *kMessage = [NSString stringWithFormat:@"Beehive \n Your password is %@. From Beehive Support.",_code];
    
    // Build request
    NSString *urlString = [NSString stringWithFormat:@"https://%@:%@@api.twilio.com/2010-04-01/Accounts/%@/SMS/Messages", kTwilioSID, kTwilioSecret, kTwilioSID];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    
    // Set up the body
    NSString *bodyString = [NSString stringWithFormat:@"From=%@&To=%@&Body=%@", kFromNumber, kToNumber, kMessage];
    NSData *data = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSError *error;
    NSURLResponse *response;
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // Handle the received data
    if (error)
    {
        NSLog(@"Error: %@", error);
        //		[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
    else {
        NSString *receivedString = [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
        NSLog(@"Request sent. %@", receivedString);
        //		[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
}

-(void)showAlert:(NSString*)title message:(NSString*)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
