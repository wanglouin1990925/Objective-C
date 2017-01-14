//
//  YYYSignUpController.m
//  GiveIt100
//
//  Created by Wang MeiHua on 1/10/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYSignUpController.h"
#import "YYYAppDelegate.h"
#import "MBProgressHUD.h"
#import "YYYCommunication.h"
#import "YYYTermsNavController.h"
#import "YYYPrivacyNavController.h"

@interface YYYSignUpController ()

@end

@implementation YYYSignUpController

@synthesize usernameField;
@synthesize passwordField;
@synthesize confirmField;
@synthesize emailField;

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
    [self.navigationController setNavigationBarHidden:FALSE];
    
    UIColor* darkColor = [UIColor colorWithRed:50.0f/255 green:79.0f/255 blue:133.0f/255 alpha:1.0f];
    
    NSString* fontName = @"Avenir-Book";
    NSString* boldFontName = @"Avenir-Black";
    
    self.emailField.backgroundColor = [UIColor whiteColor];
    self.emailField.placeholder = @"Email Address";
    self.emailField.font = [UIFont fontWithName:fontName size:16.0f];
    self.emailField.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.7].CGColor;
    self.emailField.layer.borderWidth = 1.0f;
    
    UIView* leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.emailField.leftViewMode = UITextFieldViewModeAlways;
    self.emailField.leftView = leftView;
    
    self.usernameField.backgroundColor = [UIColor whiteColor];
    self.usernameField.font = [UIFont fontWithName:fontName size:16.0f];
    self.usernameField.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.7].CGColor;
    self.usernameField.layer.borderWidth = 1.0f;
    
    UIView* leftView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.usernameField.leftViewMode = UITextFieldViewModeAlways;
    self.usernameField.leftView = leftView1;
    
    self.passwordField.backgroundColor = [UIColor whiteColor];
    self.passwordField.placeholder = @"Password";
    self.passwordField.font = [UIFont fontWithName:fontName size:16.0f];
    self.passwordField.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.7].CGColor;
    self.passwordField.layer.borderWidth = 1.0f;
    
    
    UIView* leftView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordField.leftView = leftView2;
    
    
    self.confirmField.backgroundColor = [UIColor whiteColor];
    self.confirmField.placeholder = @"Confirm";
    self.confirmField.font = [UIFont fontWithName:fontName size:16.0f];
    self.confirmField.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.7].CGColor;
    self.confirmField.layer.borderWidth = 1.0f;
    
    
    UIView* leftView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.confirmField.leftViewMode = UITextFieldViewModeAlways;
    self.confirmField.leftView = leftView3;
    
    self.signupButton.backgroundColor = darkColor;
    self.signupButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
    [self.signupButton setTitle:@"SIGN UP HERE" forState:UIControlStateNormal];
    [self.signupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.signupButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];

    self.infoLabel.textColor =  [UIColor darkGrayColor];
    self.infoLabel.font =  [UIFont fontWithName:boldFontName size:14.0f];
    
    self.infoView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    
    self.photoButton.imageView.image = [UIImage imageNamed:@"anonymousUser.png"];
    self.photoButton.contentMode = UIViewContentModeScaleAspectFill;
    self.photoButton.clipsToBounds = YES;
    self.photoButton.layer.cornerRadius = self.photoButton.frame.size.width/2.0f;
    self.photoButton.layer.borderWidth = 1.0f;
    self.photoButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
//    [usernameField becomeFirstResponder];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self.view addGestureRecognizer:tapGesture];
    
    [super viewDidLoad];
    
    NSMutableAttributedString *strAr = [[NSMutableAttributedString alloc] initWithString:@"By tapping to Next, you are indicatiing that you have read the Privacy Policy and agree to Terms of Use."];
    
    [strAr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:[strAr.string rangeOfString:@"Privacy Policy"]];
    [strAr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:[strAr.string rangeOfString:@"Privacy Policy"]];
    
    [strAr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:[strAr.string rangeOfString:@"Terms of Use"]];
    [strAr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:[strAr.string rangeOfString:@"Terms of Use"]];
    
    [lblTerms setUserInteractionEnabled:YES];
    [lblTerms setAttributedText:strAr];
    
    
//    UITapGestureRecognizer *termsClicked = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(termsClicked)];
//    [lblTerms addGestureRecognizer:termsClicked];
    
	// Do any additional setup after loading the view.
}

-(IBAction)btTermsClick:(id)sender
{
    YYYTermsNavController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYTermsNavController"];
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}

-(IBAction)btPrivacyClick:(id)sender
{
    YYYPrivacyNavController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYPrivacyNavController"];
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}

-(void)termsClicked
{
    YYYTermsNavController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYTermsNavController"];
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}

-(void)handleTap
{
    [self.view endEditing:YES];
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(IBAction)btNextClick:(id)sender
{
    if (!usernameField.text.length) {
        [self showAlert:@"Input Username."];
        return;
    }
    if (passwordField.text.length < 6) {
        [self showAlert:@"Password need to be more than 6 characters."];
        return;
    }
    
    if (![passwordField.text isEqualToString:confirmField.text]) {
        [self showAlert:@"Conform Password is wrong."];
        return;
    }
    
    if (![self NSStringIsValidEmail:emailField.text]) {
        [self showAlert:@"Input Valid Email Address."];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
        
        // Parse ;
        if( [ [ _responseObject objectForKey : @"success" ] isEqualToString : @"1" ] )
        {
            [YYYCommunication sharedManager].me = [_responseObject objectForKey:@"detail"];
            
            YYYAppDelegate *delegate = (YYYAppDelegate*)[UIApplication sharedApplication].delegate;
            [delegate userLoggedIn];
        }
        else
        {
            [ self  showAlert: [_responseObject objectForKey:@"detail"] ] ;
            return ;
        }
    } ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
        // Hide ;
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
        
        // Error ;
        [ self  showAlert: @"Internet Connection Error!" ] ;
    } ;

    [[YYYCommunication sharedManager] signup:usernameField.text
                                    password:passwordField.text
                                       email:emailField.text
                                       photo:UIImageJPEGRepresentation(self.photoButton.currentBackgroundImage, 1.0f)
                                   successed:successed
                                     failure:failure];
}

-(IBAction)btPhotoClick:(id)sender
{
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From Camera",@"From Gallery", nil];
    [actionsheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIImagePickerController* imageGallery = [ [ UIImagePickerController alloc ] init ] ;
        
        [ imageGallery setSourceType : UIImagePickerControllerSourceTypeCamera ] ;
        [ imageGallery setDelegate : self ] ;
        [ imageGallery setAllowsEditing : YES ] ;
        
        [ self.navigationController presentViewController : imageGallery animated : YES completion : NULL ] ;
    }else if(buttonIndex == 1)
    {
        UIImagePickerController* imageGallery = [ [ UIImagePickerController alloc ] init ] ;
        
        [ imageGallery setSourceType : UIImagePickerControllerSourceTypePhotoLibrary ] ;
        [ imageGallery setDelegate : self ] ;
        [ imageGallery setAllowsEditing : YES ] ;
        
        [ self.navigationController presentViewController : imageGallery animated : YES completion : NULL ] ;
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [self.photoButton setBackgroundImage:[ info objectForKey : UIImagePickerControllerEditedImage ] forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
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
