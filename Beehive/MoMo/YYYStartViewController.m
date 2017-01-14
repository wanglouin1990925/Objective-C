//
//  YYYStartViewController.m
//  MoMo
//
//  Created by Wang MeiHua on 11/13/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYStartViewController.h"
#import "YYYAppDelegate.h"
#import "MBProgressHUD.h"
#import "YYYCommunication.h"
#import "YYYTabbarViewController.h"
#import "YYYForgotViewController.h"
#import "YYYSignUpViewController.h"

@interface YYYStartViewController ()

@end

@implementation YYYStartViewController

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
	
	btLogin.layer.borderColor   = [[UIColor lightGrayColor] CGColor];
	btLogin.layer.borderWidth   = 0.5f;
	btLogin.layer.cornerRadius  = 0.0f;
	btLogin.clipsToBounds       = YES;
	
	btSignUp.layer.borderColor  = [[UIColor lightGrayColor] CGColor];
	btSignUp.layer.borderWidth  = 0.5f;
	btSignUp.layer.cornerRadius = 0.0f;
	btSignUp.clipsToBounds      = YES;
	
	UIColor *whiteColor             = [UIColor whiteColor];
	txtPass.attributedPlaceholder   = [[NSAttributedString alloc] initWithString:txtPass.placeholder    attributes:@{NSForegroundColorAttributeName: whiteColor}];
	txtPhone.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:txtPhone.placeholder   attributes:@{NSForegroundColorAttributeName: whiteColor}];
	
	[imvSeparate1 setFrame:CGRectMake(imvSeparate1.frame.origin.x, imvSeparate1.frame.origin.y, imvSeparate1.frame.size.width, 0.5)];
	[imvSeparate2 setFrame:CGRectMake(imvSeparate2.frame.origin.x, imvSeparate2.frame.origin.y, imvSeparate2.frame.size.width, 0.5)];   

	[txtPhone	setText:@""];
	[txtPass	setText:@""];
	
	[btCountryCode setTitle:@"+1" forState:UIControlStateNormal];
	
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:@"username"])
    {
        [btCountryCode  setTitle:[userDefault objectForKey:@"countrycode"] forState:UIControlStateNormal];
        [txtPhone       setText:[userDefault objectForKey:@"username"]];
        [txtPass        setText:[userDefault objectForKey:@"password"]];
    }
    
	btCountryCode.layer.borderColor = [[UIColor whiteColor] CGColor];
	btCountryCode.layer.borderWidth = 0.5f;
	
	btCountryCode.layer.cornerRadius = 5.0f;
	btCountryCode.clipsToBounds = YES;
	
	UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
	[self.view addGestureRecognizer:gesture];
	
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    // Do any additional setup after loading the view.
}

-(void) keyboardWillShow:(NSNotification *)notification
{
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    CGRect containerFrame = self.view.frame;
    containerFrame.origin.y = -130;
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    self.view.frame = containerFrame;
    
    // commit animations
    [UIView commitAnimations];
}

-(IBAction)btSignUpClick:(id)sender
{
    [self.view endEditing:NO];
    YYYSignUpViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYSignUpViewController"];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

-(void) keyboardWillHide:(NSNotification *)notification
{
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect containerFrame = self.view.frame;
    containerFrame.origin.y = 0;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    self.view.frame = containerFrame;
    
    // commit animations
    [UIView commitAnimations];
}

-(IBAction)btFacebookClick:(id)sender
{
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"public_profile", @"email",@"user_birthday", nil];
    
    [FBSession openActiveSessionWithReadPermissions:permissions allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error)
    {
       [MBProgressHUD hideAllHUDsForView:self.view animated:YES]; // Hide loading indicator
        
        if (!error)
        {
            [self fbLogedIn];
        }
        else
        {
            NSLog(@"%@",error.description);
        }
        
    }];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)fbLogedIn
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES]; // Show loading indicator until login is finished

    [[FBRequest requestForGraphPath:@"me?fields=id,name,email,gender,birthday"] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *result, NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
         // Did everything come back okay with no errors?
         if (!error && result)
         {
             NSString *name     = [result objectForKey:@"name"];
             NSString *email    = [result objectForKey:@"email"];
             NSString *fbid     = [result objectForKey:@"id"];
             NSString *gender   = @"Male";
             
             NSString *birthday = @"0000-00-00";
             
             if ([result objectForKey:@"birthday"])
             {
                 NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                 [formatter setDateFormat:@"MM/dd/yyyy"];
                 NSDate *birthdate =  [formatter dateFromString:[result objectForKey:@"birthday"]];
                 [formatter setDateFormat:@"yyyy-MM-dd"];
                 birthday = [formatter stringFromDate:birthdate];
             }
             
             if ([[result objectForKey:@"gender"] isEqualToString:@"female"])
             {
                 gender = @"Female";
             }
             
             [self CreateAccount:fbid email:email username:name gender:gender name:name birthdate:birthday];
         }
         else
         {
             NSLog(@"%@",error.description);
         }
     }];
}

-(void)CreateAccount:(NSString*)fbid email:(NSString*)email username:(NSString*)username gender:(NSString*)gender name:(NSString*)name birthdate:(NSString*)birthdate
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if ([[_responseObject objectForKey:@"success"] isEqualToString:@"1"])
        {
            [YYYCommunication sharedManager].dictInfo	= [[NSMutableDictionary alloc] initWithDictionary:[_responseObject objectForKey:@"detail"]];
            [YYYCommunication sharedManager].lstPhoto	= [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"photoarray"]];
            [YYYCommunication sharedManager].lstGroup	= [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"grouparray"]];
            [YYYCommunication sharedManager].lstFriend	= [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"friendarray"]];
            [YYYCommunication sharedManager].lstBlock	= [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"blockarray"]];

            YYYTabbarViewController *tabController = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYTabbarViewController"];
            [YYYAppDelegate sharedDelegate].window.rootViewController = tabController;
            
            [[YYYAppDelegate sharedDelegate] startTimer];
            
            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
            [currentInstallation setChannels:[[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"c%@",[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"]], nil]];
            [currentInstallation setObject: [[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"] forKey: @"owner"];
            [currentInstallation saveInBackground];
            
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            
            [userDefault setObject:@"+1"      forKey:@"countrycode"];
            [userDefault setObject:@""      forKey:@"username"];
            [userDefault setObject:@""      forKey:@"password"];
            
            [userDefault synchronize];
        }
        else
        {
            [self showAlert:@"Oops!" message:[_responseObject objectForKey:@"detail"]];
        }
    } ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
    {
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
    } ;
    
    [[YYYCommunication sharedManager] FBSignUp:fbid
                                      username:username
                                          name:name
                                      birthday:birthdate
                                        gender:gender
                                      latitude:[NSString stringWithFormat:@"%f",[YYYAppDelegate sharedDelegate].fLat]
                                     longitude:[NSString stringWithFormat:@"%f",[YYYAppDelegate sharedDelegate].fLng]
                                     successed:successed
                                       failure:failure];
}

-(IBAction)btForgotClick:(id)sender
{
    [self.view endEditing:NO];
    YYYForgotViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYForgotViewController"];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

-(void)handleTap
{
	[self.view endEditing:YES];
}

-(IBAction)btCountryCodeClick:(id)sender
{
    [self.view endEditing:NO];
	YYYCountryListController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYCountryListController"];
	viewcontroller.delegate = self;
	[self.navigationController pushViewController:viewcontroller animated:YES];
}

-(void)DidCountrySelected:(NSString *)country code:(NSString *)code
{
	[btCountryCode setTitle:code forState:UIControlStateNormal];
}

-(IBAction)btSiginInClick:(id)sender
{
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	void ( ^successed )( id _responseObject ) = ^( id _responseObject )
	{
		[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
		if ([[_responseObject objectForKey:@"success"] isEqualToString:@"1"])
		{
			[YYYCommunication sharedManager].dictInfo	= [[NSMutableDictionary alloc] initWithDictionary:[_responseObject objectForKey:@"detail"]];
			[YYYCommunication sharedManager].lstPhoto	= [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"photoarray"]];
			[YYYCommunication sharedManager].lstGroup	= [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"grouparray"]];
			[YYYCommunication sharedManager].lstFriend	= [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"friendarray"]];
			[YYYCommunication sharedManager].lstBlock	= [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"blockarray"]];
			
			YYYTabbarViewController *tabController = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYTabbarViewController"];
			[YYYAppDelegate sharedDelegate].window.rootViewController = tabController;
			
			[[YYYAppDelegate sharedDelegate] startTimer];
			
			PFInstallation *currentInstallation = [PFInstallation currentInstallation];
			[currentInstallation setChannels:[[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"c%@",[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"]], nil]];
			[currentInstallation setObject: [[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"] forKey: @"owner"];
			[currentInstallation saveInBackground];
            
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            
            [userDefault setObject:btCountryCode.currentTitle forKey:@"countrycode"];
            [userDefault setObject:txtPhone.text forKey:@"username"];
            [userDefault setObject:txtPass.text forKey:@"password"];
            
            [userDefault synchronize];
		}
		else
		{
			[self showAlert:@"Oops!" message:[_responseObject objectForKey:@"detail"]];
		}
	} ;
	
	void ( ^failure )( NSError* _error ) = ^( NSError* _error )
	{
		[self showAlert:@"Oops!" message:@"An unknown error occured"];
		[ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
	} ;
	
	NSString *phonenumber = [NSString stringWithFormat:@"%@%@",[[btCountryCode.currentTitle stringByReplacingOccurrencesOfString:@"+" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""],txtPhone.text];
	
	[[YYYCommunication sharedManager] Login:phonenumber
								   password:txtPass.text
                                   latitude:[NSString stringWithFormat:@"%f",[YYYAppDelegate sharedDelegate].fLat]
                                  longitude:[NSString stringWithFormat:@"%f",[YYYAppDelegate sharedDelegate].fLng]
								  successed:successed
									failure:failure];
}

-(void)showAlert:(NSString*)title message:(NSString*)message
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[pageCtl setCurrentPage:scvContent.contentOffset.x/320];
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
