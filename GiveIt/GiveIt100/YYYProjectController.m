//
//  YYYProfileController.m
//  GiveIt100
//
//  Created by Wang MeiHua on 1/10/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYProjectController.h"
#import "FeedCell.h"
#import "FeedHeader.h"
#import "YYYUserProfileController.h"
#import "YYYCommunication.h"
#import "MBProgressHUD.h"
#import "YYYCommentController.h"
#import "YYYHomeController.h"

@interface YYYProjectController ()

@end

@implementation YYYProjectController

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
    
    [tbl_project registerNib:[UINib nibWithNibName:@"FeedCell"
                                         bundle:[NSBundle mainBundle]]
   forCellReuseIdentifier:@"FeedCell"];
    
    strCurrentCategory = @"Recommended";
    
    [self loadProject];
    
    bFirst = TRUE;
    
    mArrDisplayCells = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadProject) name:@"PROJECTREFRESH" object:nil];
    
    [viewForCategory setHidden:YES];
	// Do any additional setup after loading the view.
}

-(void)loadProject
{
    void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
        
        // Parse ;
        if( [ [ _responseObject objectForKey : @"success" ] isEqualToString : @"1" ] )
        {
            lstProject = [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"detail"]];
            NSLog(@"%@",lstProject);
            [tbl_project reloadData];
        }
        else
        {
            [self loadProject];
        }
    } ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
        [self loadProject];
    } ;
    
    [[YYYCommunication sharedManager] loadproject:[[YYYCommunication sharedManager].me objectForKey:@"index"]
                                         category:strCurrentCategory.lowercaseString
                                        successed:successed
                                          failure:failure];
}

-(IBAction)btCategoryClick:(id)sender
{
    if (!btCategory.selected) {
        [viewForCategory setHidden:NO];
        [btCategory setSelected:YES];
    }
    else{
        [viewForCategory setHidden:YES];
        [btCategory setSelected:NO];
    }
}

-(IBAction)btCategoryItemClick:(id)sender
{
    [viewForCategory setHidden:YES];
    [btCategory setSelected:NO];
    
    NSString *strCategory = [(UIButton*)sender currentTitle];
    if ([strCategory isEqualToString:@"Art & Design"]) {
        strCategory = @"Art and Design";
    }
    
    strCurrentCategory = strCategory;
    
    [self loadProject];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 360.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[lstProject objectAtIndex:section] objectForKey:@"posts"] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [lstProject count];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FeedHeader *customView = [FeedHeader customView];
    customView.delegate = self;
    [customView initData:[lstProject objectAtIndex:section]:(int)section];
    return customView;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    [imgview setBackgroundColor:[UIColor grayColor]];
    return imgview;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"FeedCell";
    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *dict = [[[lstProject objectAtIndex:indexPath.section] objectForKey:@"posts"] objectAtIndex:indexPath.row];
    cell.delegate = self;
    [cell initwithData:dict : indexPath : [[lstProject objectAtIndex:indexPath.section] objectForKey:@"userid"]];
    
    if (bFirst && indexPath.row == 0) {
        [cell play];
        bFirst = FALSE;
    }
    
    return cell;
}

-(void)deleteaction:(NSDictionary *)_dict
{
    [self loadProject];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![mArrDisplayCells containsObject:cell]) {
        [mArrDisplayCells addObject:cell];
    }
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([mArrDisplayCells containsObject:cell]) {
        [mArrDisplayCells removeObject:cell];
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

-(void)userProfileAction:(int)nIndex
{
    if ([[[YYYCommunication sharedManager].me objectForKey:@"index"] isEqualToString:[[[lstProject objectAtIndex:nIndex] objectForKey:@"userinfo"] objectForKey:@"index"]])
    {
        return;
        
        YYYHomeController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYHomeController"];
        [self.navigationController pushViewController:viewcontroller animated:YES];
    }
    else
    {
        YYYUserProfileController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYUserProfileController"];
        viewcontroller.strUserID = [[[lstProject objectAtIndex:nIndex] objectForKey:@"userinfo"] objectForKey:@"index"];
        [self.navigationController pushViewController:viewcontroller animated:YES];
    }
}

-(void)projectAction:(int)nIndex
{
    if ([[[YYYCommunication sharedManager].me objectForKey:@"index"] isEqualToString:[[[lstProject objectAtIndex:nIndex] objectForKey:@"userinfo"] objectForKey:@"index"]])
    {
        return;
        
        YYYHomeController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYHomeController"];
        [self.navigationController pushViewController:viewcontroller animated:YES];
    }
    else
    {
        YYYUserProfileController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYUserProfileController"];
        viewcontroller.strUserID = [[[lstProject objectAtIndex:nIndex] objectForKey:@"userinfo"] objectForKey:@"index"];
        [self.navigationController pushViewController:viewcontroller animated:YES];
    }
}

- (void)likeAction:(NSIndexPath*)_indexpath :(BOOL)islike
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[[[lstProject objectAtIndex:_indexpath.section] objectForKey:@"posts"] objectAtIndex:_indexpath.row]];
    if (islike){
        [dict setObject:@"1" forKey:@"islike"];
        [dict setObject:[NSString stringWithFormat:@"%d",[[dict objectForKey:@"nums_like"] intValue] + 1] forKey:@"nums_like"];
    }
    else
    {
        [dict setObject:@"0" forKey:@"islike"];
        [dict setObject:[NSString stringWithFormat:@"%d",[[dict objectForKey:@"nums_like"] intValue] - 1] forKey:@"nums_like"];
    }
    
    NSMutableArray *arrayTemp = [[NSMutableArray alloc] initWithArray:[[lstProject objectAtIndex:_indexpath.section] objectForKey:@"posts"]];
    [arrayTemp replaceObjectAtIndex:_indexpath.row withObject:dict];
    
    NSMutableDictionary *dictTemp = [[NSMutableDictionary alloc] initWithDictionary:[lstProject objectAtIndex:_indexpath.section]];
    [dictTemp setObject:arrayTemp forKey:@"posts"];
    
    [lstProject replaceObjectAtIndex:_indexpath.section withObject:dictTemp];
    
    [tbl_project reloadData];
}


- (IBAction)commentAction:(NSIndexPath*)_indexpath
{
    NSDictionary *dict = [[[lstProject objectAtIndex:_indexpath.section] objectForKey:@"posts"] objectAtIndex:_indexpath.row];
    YYYCommentController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYCommentController"];
    viewcontroller.strPostID = [dict objectForKey:@"index"];
    viewcontroller.POSTMESSAGE = @"PROJECTREFRESH";
    [self.navigationController pushViewController:viewcontroller animated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
