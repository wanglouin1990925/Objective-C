//
//  YYYDateListController.m
//  GiveIt100
//
//  Created by Wang MeiHua on 1/13/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYDateListController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AddVideoCell.h"
#import "YYYCommunication.h"
#import "MBProgressHUD.h"

@interface YYYDateListController ()

@end

@implementation YYYDateListController

@synthesize dictProject;

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
    
    lstMissedList = [[NSMutableArray alloc] init];
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    if ([[dictProject objectForKey:@"posts"] count]) {
        
        lastDate = [formatter dateFromString:[[[[dictProject objectForKey:@"posts"] objectAtIndex:[[dictProject objectForKey:@"posts"] count] - 1] objectForKey:@"date"] substringToIndex:10]];
        
        NSDate *today = [formatter dateFromString:[[formatter stringFromDate:[NSDate date]] substringToIndex:10]];
        
        nDiff = [today timeIntervalSinceDate:lastDate] / 86400.0f;
        
        if (nDiff < 1) {
            bRecord = TRUE;
            daynumber = [NSString stringWithFormat:@"%d",[[[[dictProject objectForKey:@"posts"] objectAtIndex:[[dictProject objectForKey:@"posts"] count] - 1] objectForKey:@"daynumber"] intValue]];
        }else{
            bRecord = FALSE;
            daynumber = [NSString stringWithFormat:@"%d",[[[[dictProject objectForKey:@"posts"] objectAtIndex:[[dictProject objectForKey:@"posts"] count] - 1] objectForKey:@"daynumber"] intValue] + 1];
        }
    }
    
    else{
        daynumber = @"1";
        bRecord = FALSE;
    }
    
//        if (nDiff > 30) {
//            nDiff = 30;
//        }
//        
//        for (int i = 1; i < nDiff + 1; i++) {
//            [lstMissedList addObject:[NSString stringWithFormat:@"%d",i]];
//        }
//        
//        for (NSDictionary *dict in [dictProject objectForKey:@"posts"]) {
//            if ([lstMissedList containsObject:[dict objectForKey:@"daynumber"]]) {
//                [lstMissedList removeObject:[dict objectForKey:@"daynumber"]];
//            }
//        }
//    }
//    else
//    {
//        
//        [lstMissedList addObject:@"1"];
//        startDate = [formatter dateFromString:[[formatter stringFromDate:[NSDate date]] substringToIndex:10]];
//    }
    
    [tbl_date reloadData];
    
    // Do any additional setup after loading the view.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[dictProject objectForKey:@"posts"] count]) {
        return 1;
    }else{
        return 1;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([lstMissedList count]) {
//        
//        static NSString *strIdentifer = @"AddVideoCell";
//        AddVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:strIdentifer];
//        cell.delegate = self;
//        [cell initwithData:[NSString stringWithFormat:@"%@",[lstMissedList objectAtIndex:indexPath.row]] :[formatter stringFromDate:[startDate dateByAddingTimeInterval:([[lstMissedList objectAtIndex:indexPath.row] intValue] - 1)*86400]] :(int)indexPath.row];
//        
//        return cell;
//        
//    }else{
//        
//        static NSString *strIdentifer = @"Cell";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strIdentifer];
//        
//        [(UILabel*)[cell viewWithTag:100] setText:[NSString stringWithFormat:@"Day %d",nDiff]];
//        [(UILabel*)[cell viewWithTag:101] setText:@"Today"];
//        [(UIButton*)[cell viewWithTag:102] setTitle:@"Finished" forState:UIControlStateNormal];
//        [(UIButton*)[cell viewWithTag:102] setUserInteractionEnabled:NO];
//        
//        return cell;
//    }
    if (bRecord||[daynumber isEqualToString:@"31"]) {
        
        if ([daynumber isEqualToString:@"31"])
        {
            daynumber = @"30";
        }
        
        static NSString *strIdentifer = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strIdentifer];

        [(UILabel*)[cell viewWithTag:100] setText:[NSString stringWithFormat:@"Day %@",daynumber]];
        [(UILabel*)[cell viewWithTag:101] setText:[formatter stringFromDate:[NSDate date]]];
        [(UIButton*)[cell viewWithTag:102] setTitle:@"Finished" forState:UIControlStateNormal];
        [(UIButton*)[cell viewWithTag:102] setUserInteractionEnabled:NO];
        
        return cell;
    }else{
        static NSString *strIdentifer = @"AddVideoCell";
        AddVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:strIdentifer];
        cell.delegate = self;
        [cell initwithData:daynumber :[formatter stringFromDate:[NSDate date]] :(int)indexPath.row];

        return cell;
    }
}

- (void)addVideo:(NSString*)_daynumber : (NSString*)_date;
{
    date = _date;
    daynumber = _daynumber;
    
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From camera",@"From Gallery", nil];
    [actionsheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        picker.videoMaximumDuration = 10.0f;
        [self presentViewController:picker animated:YES completion:NULL];
        
    }else if(buttonIndex == 1){
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        picker.videoMaximumDuration = 10.0f;
        [self presentViewController:picker animated:YES completion:NULL];
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSURL *videoURL = (NSURL*)info[UIImagePickerControllerMediaURL];
    NSData *vData = [NSData dataWithContentsOfURL:videoURL];
    

    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
    UIImage *thumbImage = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
    NSData *pData = UIImageJPEGRepresentation( thumbImage, 0.5 ) ;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
        
        // Parse ;
        if( [ [ _responseObject objectForKey : @"success" ] isEqualToString : @"1" ] )
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HOMEREFRESH" object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            [ self  showAlert: @"Internet Connection Error!" ] ;
            return ;
        }
    } ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
        // Hide ;
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
        
        // Error ;
        [ self  showAlert: @"Internet Connection Error!" ] ;
    } ;
    
    [[YYYCommunication sharedManager] addpost:[dictProject objectForKey:@"index"]
                                    daynumber:daynumber
                                         date:date
                                        video:vData
                                        photo:pData
                                    successed:successed
                                      failure:failure];
}

-(void)showAlert:(NSString*)_message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:_message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
