//
//  YYYSettingTableController.m
//  GiveIt100
//
//  Created by Wang MeiHua on 1/11/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYSettingTableController.h"
#import "RESideMenu.h"
#import "YYYAppDelegate.h"
#import "YYYTermsNavController.h"
#import "YYYPrivacyNavController.h"

@interface YYYSettingTableController ()

@end

@implementation YYYSettingTableController

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

    [self loadController];
    
    UITapGestureRecognizer *tapContactus = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contactus)];
    [lblContact addGestureRecognizer:tapContactus];
    
    UITapGestureRecognizer *tapLogout = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logout)];
    [lblLogout addGestureRecognizer:tapLogout];
    
	// Do any additional setup after loading the view.
}

-(void)loadController{
	
	[self.navigationController setNavigationBarHidden:FALSE];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"img_menu"] style:UIBarButtonItemStyleBordered target:self action:@selector(onBtnMenu:)];
    [self.navigationItem setLeftBarButtonItem:backButton];
    
}

-(IBAction)btTermsClick:(id)sender
{
    YYYTermsNavController *navcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYTermsNavController"];
    [self.navigationController presentViewController:navcontroller animated:YES completion:nil];
}

-(IBAction)btPrivacyClick:(id)sender
{
    YYYPrivacyNavController *navcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYPrivacyNavController"];
    [self.navigationController presentViewController:navcontroller animated:YES completion:nil];
}

-(IBAction)onBtnMenu:(id)sender
{
    [self.sideMenuViewController presentMenuViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)logout
{
    YYYAppDelegate *appdelegate = (YYYAppDelegate*)[UIApplication sharedApplication].delegate;
    [appdelegate userLogedOut];
}

-(void)contactus
{
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController* mailer = [[MFMailComposeViewController alloc] init];
        NSString* to = @"ChrBaudry@gmail.com";
        [mailer setToRecipients:[NSArray arrayWithObject:to]];
        [mailer setSubject:@"Feedback"];
		[mailer setMessageBody:@"Write down your feedback here" isHTML:YES];
		mailer.mailComposeDelegate = self;
        
        [self presentViewController:mailer animated:TRUE completion:nil];
    }
    else
    {
        NSLog(@"Can't send mail");
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:TRUE completion:nil];
    
    NSString* message = nil;
    switch(result)
    {
        case MFMailComposeResultCancelled:
            message = @"Not sent at user request.";
            break;
        case MFMailComposeResultSaved:
            message = @"Saved";
            break;
        case MFMailComposeResultSent:
            message = @"Sent";
            break;
        case MFMailComposeResultFailed:
            message = @"Error";
    }
    NSLog(@"%s %@", __PRETTY_FUNCTION__, message);
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    return 4;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 1;
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
