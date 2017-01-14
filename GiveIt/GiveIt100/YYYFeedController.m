//
//  YYYFeedController.m
//  GiveIt100
//
//  Created by Wang MeiHua on 1/17/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYFeedController.h"
#import "YYYUserProfileController.h"
#import "FeedCell.h"
#import "YYYCommunication.h"
#import "MBProgressHUD.h"
#import "YYYCommentController.h"

@interface YYYFeedController ()

@end

@implementation YYYFeedController

@synthesize strPostID;

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
    
    [tbl_project registerNib:[UINib nibWithNibName:@"FeedCell"
                                            bundle:[NSBundle mainBundle]]
      forCellReuseIdentifier:@"FeedCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPost) name:@"FEEDREFRESH" object:nil];
    
    [self getPost];
    
    
	// Do any additional setup after loading the view.
}

-(void)getPost
{
    void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
        
        // Parse ;
        if( [ [ _responseObject objectForKey : @"success" ] isEqualToString : @"1" ] )
        {
            dict = [[NSMutableDictionary alloc] initWithDictionary:[_responseObject objectForKey:@"detail"]];
            strUserID = [_responseObject objectForKey:@"userid"];
            [tbl_project reloadData];
        }
        else
        {
            [ self  showAlert:  @"Internet Connection Error!" ] ;
            return ;
        }
    } ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
        // Hide ;
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
        
        // Error ;
        [ self  showAlert: @"Internet Connection Error!" ] ;
    } ;
    
    [[YYYCommunication sharedManager] getpost:[[YYYCommunication sharedManager].me objectForKey:@"index"] postid:strPostID successed:successed failure:failure];
}

-(void)showAlert:(NSString*)_message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:_message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 360.0f;
}

-(void)deleteaction:(NSDictionary *)_dict
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATIONREFRESH" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 60.0f;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dict) {
        return 1;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    FeedHeader *customView = [FeedHeader customView];
//    customView.delegate = self;
//    [customView initData:nil:0];
//    return customView;
//}

//-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
//    [imgview setBackgroundColor:[UIColor grayColor]];
//    return imgview;
//}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FeedCell";
    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.delegate = self;
    [cell initwithData:dict : indexPath :strUserID];
    [cell play];
    
    return cell;
}

-(void)userProfileAction:(int)_nIndex
{
//    YYYUserProfileController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYUserProfileController"];
//    [self.navigationController pushViewController:viewcontroller animated:YES];
}

-(void)projectAction:(int)_nIndex
{
//    YYYUserProfileController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYUserProfileController"];
//    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (void)likeAction:(NSIndexPath*)_indexpath :(BOOL)islike
{
    if (islike){
        [dict setObject:@"1" forKey:@"islike"];
        [dict setObject:[NSString stringWithFormat:@"%d",[[dict objectForKey:@"nums_like"] intValue] + 1] forKey:@"nums_like"];
    }
    else
    {
        [dict setObject:@"0" forKey:@"islike"];
        [dict setObject:[NSString stringWithFormat:@"%d",[[dict objectForKey:@"nums_like"] intValue] - 1] forKey:@"nums_like"];
    }
    
    [tbl_project reloadData];
}

- (IBAction)commentAction:(NSIndexPath*)_indexpath
{
    YYYCommentController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYCommentController"];
    viewcontroller.strPostID = [dict objectForKey:@"index"];
    viewcontroller.POSTMESSAGE = @"FEEDREFRESH";
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
