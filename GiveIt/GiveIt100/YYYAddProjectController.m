//
//  YYYAddProjectController.m
//  GiveIt100
//
//  Created by Wang MeiHua on 2/2/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYAddProjectController.h"
#import "YYYCommunication.h"
#import "MBProgressHUD.h"

@interface YYYAddProjectController ()

@end

@implementation YYYAddProjectController

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
    
    btAdd.clipsToBounds = YES;
    btAdd.layer.cornerRadius = 5.0f;
    btCategory.layer.borderColor = [[UIColor grayColor] CGColor];
    btCategory.layer.borderWidth = 1.0f;
    
    [viewForCategory setHidden:YES];
    
    txtTitle.delegate = self;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self.view addGestureRecognizer:tapGesture];
    
    lstCategory = [[NSMutableArray alloc] initWithObjects:@"Fitness",@"Music",@"Language",@"Art and Design",@"Engineering",@"Parents",@"Pets",@"Others", nil];
    
	// Do any additional setup after loading the view.
}

-(void)handleTap
{
    [txtTitle resignFirstResponder];
    [viewForCategory setHidden:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)btAddClick:(id)sender
{
    if (!txtTitle.text.length) {
        [self showAlert:@"Input Project Name"];
        return;
    }
    
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
    
	NSString *strCategory = btCategory.currentTitle;
	if ([strCategory isEqualToString:@"Choose Category"]) {
		strCategory = @"Others";
	}
	
    [[YYYCommunication sharedManager] addproject:[[YYYCommunication sharedManager].me objectForKey:@"index"] title:txtTitle.text category:strCategory.lowercaseString successed:successed failure:failure];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [lstCategory count];
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [lstCategory objectAtIndex:row];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)showAlert:(NSString*)_message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:_message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

-(IBAction)btChooseCategoryClick:(id)sender
{
    [viewForCategory setHidden:NO];
}

-(IBAction)btDoneClick:(id)sender
{
    [btCategory setTitle:[lstCategory objectAtIndex:[pickerView selectedRowInComponent:0]] forState:UIControlStateNormal];
    [viewForCategory setHidden:YES];
}

-(IBAction)btCancelClick:(id)sender
{
    [viewForCategory setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
