//
//  YYYHomeController.m
//  GiveIt100
//
//  Created by Wang MeiHua on 1/10/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYUserProfileController.h"
#import "UserProfileCell.h"
#import "FeedCell.h"
#import "YYYEditProfileController.h"
#import "YYYPrListController.h"
#import "YYYCommunication.h"
#import "MBProgressHUD.h"
#import "YYYCommentController.h"

@interface YYYUserProfileController ()

@end

@implementation YYYUserProfileController

@synthesize strUserID;

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
    
    [tbl_profile registerNib:[UINib nibWithNibName:@"UserProfileCell"
                                            bundle:[NSBundle mainBundle]]
      forCellReuseIdentifier:@"UserProfileCell"];
    
    [tbl_profile registerNib:[UINib nibWithNibName:@"FeedCell"
                                            bundle:[NSBundle mainBundle]]
      forCellReuseIdentifier:@"FeedCell"];
    
    mArrDisplayCells = [[NSMutableArray alloc] init];
    
    [self loadProfile];
    
    bFirst = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadProfile) name:@"PROFILEREFRESH" object:nil];
    
    // Do any additional setup after loading the view.
}

-(void)loadProfile
{
    void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
        // Parse ;
        if( [ [ _responseObject objectForKey : @"success" ] isEqualToString : @"1" ] )
        {
            dictProfile = [[NSMutableDictionary alloc] initWithDictionary:_responseObject];
            [tbl_profile reloadData];
        }
        else
        {
            [self loadProfile];
        }
    } ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
        [self loadProfile];
    } ;
    
    [[YYYCommunication sharedManager] getprofile:strUserID me:[[YYYCommunication sharedManager].me objectForKey:@"index"] successed:successed failure:failure];
}

-(void)showAlert:(NSString*)_message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:_message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

-(void)loadController{
	
	[self.navigationController setNavigationBarHidden:FALSE];
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"img_menu"] style:UIBarButtonItemStyleBordered target:self action:@selector(onBtnMenu:)];
//    [self.navigationItem setLeftBarButtonItem:backButton];
    
}

-(IBAction)onBtnMenu:(id)sender
{
    [self.sideMenuViewController presentMenuViewController];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (![[[dictProfile objectForKey:@"detail"] objectForKey:@"user_bio"] length]) {
            return 180.0f;
        }
        return 270.0f;
    }else{
        return 360.0f;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0f;
    }
    return 50.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0f;
    }
    return 41.0f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[dictProfile objectForKey:@"project"] count] + 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
    {
        return [[[[dictProfile objectForKey:@"project"] objectAtIndex:section - 1] objectForKey:@"posts"] count];
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"UserProfileCell";
        UserProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.delegate = self;
        [cell initData : [dictProfile objectForKey:@"detail"] : [dictProfile objectForKey:@"follower"] : [dictProfile objectForKey:@"isfollowing"]];
        
        return cell;
    }else{
        static NSString *CellIdentifier = @"FeedCell";
        FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        NSDictionary *dict = [[[[dictProfile objectForKey:@"project"] objectAtIndex:indexPath.section - 1] objectForKey:@"posts"] objectAtIndex:indexPath.row];
        cell.delegate = self;
        [cell initwithData:dict : indexPath : strUserID];
        
        if (bFirst && indexPath.row == 0) {
            [cell play];
            bFirst = FALSE;
        }
        
        return cell;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *dict = [[dictProfile objectForKey:@"project"] objectAtIndex:section - 1];
    
    UIView *viewForHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [viewForHeader setBackgroundColor:[UIColor colorWithRed:250.0f/255 green:250.0f/255 blue:250.0f/255 alpha:1.0f]];
    
    UILabel *lbl = [[UILabel alloc] init];
    [lbl setText:[dict objectForKey:@"title"]];
    [lbl setFrame:CGRectMake(10, 0, 300, 50)];
    [lbl setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [lbl setNumberOfLines:2];
    [viewForHeader addSubview:lbl];
    
    return viewForHeader;
}

-(IBAction)btAddClick:(id)sender
{
    int nIndex = (int)[(UIButton*)sender tag] - 100;
    NSLog(@"%d Clicked",nIndex);
    
    YYYPrListController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYPrListController"];
    viewcontroller.lst_project = [dictProfile objectForKey:@"project"];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (void)likeAction:(NSIndexPath*)_indexpath :(BOOL)islike
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[[[[dictProfile objectForKey:@"project"] objectAtIndex:_indexpath.section - 1] objectForKey:@"posts"] objectAtIndex:_indexpath.row]];
    if (islike){
        [dict setObject:@"1" forKey:@"islike"];
        [dict setObject:[NSString stringWithFormat:@"%d",[[dict objectForKey:@"nums_like"] intValue] + 1] forKey:@"nums_like"];
    }
    else
    {
        [dict setObject:@"0" forKey:@"islike"];
        [dict setObject:[NSString stringWithFormat:@"%d",[[dict objectForKey:@"nums_like"] intValue] - 1] forKey:@"nums_like"];
    }
    
    NSMutableArray *arrayTemp = [[NSMutableArray alloc] initWithArray:[[[dictProfile objectForKey:@"project"] objectAtIndex:_indexpath.section - 1] objectForKey:@"posts"]];
    [arrayTemp replaceObjectAtIndex:_indexpath.row withObject:dict];
    
    NSMutableDictionary *dictTemp = [[NSMutableDictionary alloc] initWithDictionary:[[dictProfile objectForKey:@"project"] objectAtIndex:_indexpath.section - 1]];
    [dictTemp setObject:arrayTemp forKey:@"posts"];
    
    arrayTemp = [[NSMutableArray alloc] initWithArray:[dictProfile objectForKey:@"project"]];
    [arrayTemp replaceObjectAtIndex:_indexpath.section - 1 withObject:dictTemp];
    
    [dictProfile setObject:arrayTemp forKey:@"project"];
    
    [tbl_profile reloadData];
}

- (IBAction)commentAction:(NSIndexPath*)_indexpath
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[[[[dictProfile objectForKey:@"project"] objectAtIndex:_indexpath.section - 1] objectForKey:@"posts"] objectAtIndex:_indexpath.row]];
    
    YYYCommentController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYCommentController"];
    viewcontroller.strPostID = [dict objectForKey:@"index"];
    viewcontroller.POSTMESSAGE = @"PROFILEREFRESH";
    [self.navigationController pushViewController:viewcontroller animated:YES];
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        if (![mArrDisplayCells containsObject:cell]) {
            [mArrDisplayCells addObject:cell];
        }
    }
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        if ([mArrDisplayCells containsObject:cell]) {
            [mArrDisplayCells removeObject:cell];
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    for (int i = 0; i < [mArrDisplayCells count]; i++) {
        FeedCell *cell = (FeedCell*)[mArrDisplayCells objectAtIndex:i];
        float distance = scrollView.contentOffset.y + scrollView.frame.size.height / 2.0f - cell.frame.origin.y;
        
        if (0 < distance && distance < cell.frame.size.height) {
            if (![cell isPlaying]) {
                [cell play];
            }
        }
        else
        {
            [cell stop];
        }
    }
}

-(void)followAction
{
    void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
        // Parse ;
        if( [ [ _responseObject objectForKey : @"success" ] isEqualToString : @"1" ] )
        {
            [dictProfile setObject:[_responseObject objectForKey:@"detail"] forKey:@"isfollowing"];
            [dictProfile setObject:[_responseObject objectForKey:@"follower"] forKey:@"follower"];
            [tbl_profile reloadData];
        }
    } ;
    
    [[YYYCommunication sharedManager] follow:[[YYYCommunication sharedManager].me objectForKey:@"index"] useridto:strUserID action:[dictProfile objectForKey:@"isfollowing"] successed:successed failure:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
