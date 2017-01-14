//
//  YYYNotificationController.m
//  GiveIt100
//
//  Created by Wang MeiHua on 1/11/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYNotificationController.h"
#import "RESideMenu.h"
#import "YYYNotificationCell.h"
#import "YYYUserProfileController.h"
#import "YYYFeedController.h"
#import "YYYCommunication.h"
#import "MBProgressHUD.h"

@interface YYYNotificationController ()

@end

@implementation YYYNotificationController

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
    [self loadController];
    
    lstNewContent = [[NSMutableArray alloc] init];
    
    [self loadNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNotification) name:@"NOTIFICATIONREFRESH" object:nil];
    
	// Do any additional setup after loading the view.
}

-(void)loadNotification
{
    void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
        
        // Parse ;
        if( [ [ _responseObject objectForKey : @"success" ] isEqualToString : @"1" ] )
        {
            [lstNewContent removeAllObjects];
            
            for (NSDictionary *dict in [_responseObject objectForKey:@"detail"]) {
                NSMutableDictionary *dictContent = [[NSMutableDictionary alloc] init];
                
                [dictContent setObject:[NSString stringWithFormat:@"%@%@",WEBAPI_URL,[dict objectForKey:@"user_avatar"]] forKey:@"avatar"];
                [dictContent setObject:[NSString stringWithFormat:@"%@ started following you",[dict objectForKey:@"username"]] forKey:@"content"];
                [dictContent setObject:[self strDiff:[[dict objectForKey:@"diff"] intValue]] forKey:@"diff"];
                [dictContent setObject:[dict objectForKey:@"date"] forKey:@"date"];
                [dictContent setObject:[dict objectForKey:@"useridfrom"] forKey:@"userid"];
                [dictContent setObject:@"" forKey:@"item"];
                [dictContent setObject:@"" forKey:@"postid"];
                
                [lstNewContent addObject:dictContent];
            }
            
            for (NSDictionary *dict in [_responseObject objectForKey:@"like"]) {
                NSMutableDictionary *dictContent = [[NSMutableDictionary alloc] init];
                
                [dictContent setObject:[NSString stringWithFormat:@"%@%@",WEBAPI_URL,[dict objectForKey:@"user_avatar"]] forKey:@"avatar"];
                [dictContent setObject:[NSString stringWithFormat:@"%@ liked your photo",[dict objectForKey:@"username"]] forKey:@"content"];
                [dictContent setObject:[self strDiff:[[dict objectForKey:@"diff"] intValue]] forKey:@"diff"];
                [dictContent setObject:[dict objectForKey:@"date"] forKey:@"date"];
                [dictContent setObject:[NSString stringWithFormat:@"%@%@",WEBAPI_URL,[[[dict objectForKey:@"videourl"] stringByReplacingOccurrencesOfString:@"video/video_" withString:@"thumb/thumb_"] stringByReplacingOccurrencesOfString:@".mp4" withString:@".jpg"]] forKey:@"item"];
                [dictContent setObject:[dict objectForKey:@"userid"] forKey:@"userid"];
                [dictContent setObject:[dict objectForKey:@"postid"] forKey:@"postid"];
                
                [lstNewContent addObject:dictContent];
            }
        
            NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
            [lstNewContent sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
        
            [tbl_notification reloadData];
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
    
    [[YYYCommunication sharedManager] getnotifications:[[YYYCommunication sharedManager].me objectForKey:@"index"] successed:successed failure:failure];
}

-(NSString*)strDiff:(int)nDiff
{
    NSString *strReturn = @"";
    if (nDiff < 60) {
        strReturn = [NSString stringWithFormat:@"%d seconds ago",nDiff];
    }else if(nDiff < 3600){
        strReturn = [NSString stringWithFormat:@"%d mins ago",nDiff/60];
    }else if(nDiff < 86400){
        strReturn = [NSString stringWithFormat:@"%d hours ago",nDiff/3600];
    }else if(nDiff < 2592000){
        strReturn = [NSString stringWithFormat:@"%d days ago",nDiff/86400];
    }else if(nDiff < 31104000){
        strReturn = [NSString stringWithFormat:@"%d months ago",nDiff/2592000];
    }else{
        strReturn = [NSString stringWithFormat:@"%d years ago",nDiff/31104000];
    }
    return strReturn;
}

-(void)showAlert:(NSString*)_message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:_message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

-(void)loadController{
	
	[self.navigationController setNavigationBarHidden:FALSE];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"img_menu"] style:UIBarButtonItemStyleBordered target:self action:@selector(onBtnMenu:)];
    [self.navigationItem setLeftBarButtonItem:backButton];
    
}

-(IBAction)onBtnMenu:(id)sender
{
    [self.sideMenuViewController presentMenuViewController];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [lstNewContent count];;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [lstNewContent objectAtIndex:indexPath.row];
    if ([[dict objectForKey:@"item"] isEqualToString:@""])
    {
        YYYNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellFollow"];
        cell.delegate = self;
        [cell initwithData:dict];
        
        return cell;
    }
    else
    {
        YYYNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellLike"];
        cell.delegate = self;
        [cell initwithData:dict];
        
        return cell;
    }
}

- (void)userProfileAction:(NSDictionary*)_dict
{
    if ([[[YYYCommunication sharedManager].me objectForKey:@"index"] isEqualToString:[_dict objectForKey:@"userid"]]) {
        return;
    }
    
    YYYUserProfileController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYUserProfileController"];
    viewcontroller.strUserID = [_dict objectForKey:@"userid"];
    [self.navigationController pushViewController:viewcontroller animated:TRUE];
}

- (void)feedAction:(NSDictionary*)_dict
{
    YYYFeedController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYFeedController"];
    viewcontroller.strPostID = [_dict objectForKey:@"postid"];
    [self.navigationController pushViewController:viewcontroller animated:TRUE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
