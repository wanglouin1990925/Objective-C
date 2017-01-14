//
//  YYYEditProfileController.m
//  GiveIt100
//
//  Created by Wang MeiHua on 1/13/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYEditProfileController.h"
#import "YYYCommunication.h"
#import "MBProgressHUD.h"
#import "UIImageView+AFNetworking.h"

@interface YYYEditProfileController ()

@end

@implementation YYYEditProfileController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self showProfile];
}

-(void)showProfile
{
    bPhoto = FALSE;
    [txtUsername setText:[[YYYCommunication sharedManager].me objectForKey:@"user_username"]];
    [txtLocation setText:[[YYYCommunication sharedManager].me objectForKey:@"user_location"]];
    [txtBio setText:[[YYYCommunication sharedManager].me objectForKey:@"user_bio"]];
    [txtEmail setText:[[YYYCommunication sharedManager].me objectForKey:@"user_email"]];
    [imvPhoto setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WEBAPI_URL,[[YYYCommunication sharedManager].me objectForKey:@"user_avatar"]]]];
}

-(IBAction)btSaveClick:(id)sender
{
    if (!txtUsername.text.length) {
        [self showAlert:@"Input Username"];
        return;
    }
    
    NSString *strQuery = @"";
    
    strQuery = [NSString stringWithFormat:@"user_username = \"%@\" , user_location = \"%@\" , user_email = \"%@\" , user_bio = \"%@\"",txtUsername.text,txtLocation.text,txtEmail.text,txtBio.text];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
        
        // Parse ;
        if( [ [ _responseObject objectForKey : @"success" ] isEqualToString : @"1" ] )
        {
            [YYYCommunication sharedManager].me = [_responseObject objectForKey:@"detail"];
            [self showProfile];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HOMEREFRESH" object:nil];
        }
        else
        {
            [self showProfile];
            [ self  showAlert: @"Internet Connection Error!" ] ;
            return ;
        }
    } ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
        // Hide ;
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
        
        
        [self showProfile];
        // Error ;
        [ self  showAlert: @"Internet Connection Error!" ] ;
    } ;
    
    if (bPhoto)
    {
        [[YYYCommunication sharedManager] editprofile:[[YYYCommunication sharedManager].me objectForKey:@"index"] query:strQuery pdata:UIImageJPEGRepresentation(imvPhoto.image, 0.5f) successed:successed failure:failure];
    }
    else
    {
        [[YYYCommunication sharedManager] editprofile:[[YYYCommunication sharedManager].me objectForKey:@"index"] query:strQuery pdata:nil successed:successed failure:failure];
    }
}

-(IBAction)btPhotoClick:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From Camera",@"From Gallery", nil];
    [sheet showInView:self.view];
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
    
    [imvPhoto setImage:[ info objectForKey : UIImagePickerControllerEditedImage ]];
    bPhoto = TRUE;
    
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

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}
//
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
