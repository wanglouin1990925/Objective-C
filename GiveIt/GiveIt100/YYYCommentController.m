//
//  YYYCommentController.m
//  GiveIt100
//
//  Created by Wang MeiHua on 1/31/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYCommentController.h"
#import "YYYCommunication.h"
#import "UIImageView+AFNetworking.h"
#import "YYYUserProfileController.h"

@interface YYYCommentController ()

@end

@implementation YYYCommentController

@synthesize strPostID;
@synthesize POSTMESSAGE;

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
    
    btComment.layer.cornerRadius = 5.0f;
    
    [self getComments];
    
    [self showView:YES];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self.view addGestureRecognizer:tapGesture];
    
    // Do any additional setup after loading the view.
}

-(void)handleTap
{
    [self.view endEditing:YES];
}

-(void)showView : (BOOL)_animated
{
    [UIView animateWithDuration:0.2f
                     animations:^
     {
         CGRect rt = viewForComment.frame;
         [viewForComment setFrame:CGRectMake(0, self.view.frame.size.height - 216 - 44, rt.size.width, rt.size.height)];
         [txtComment becomeFirstResponder];
         
          [tbl_comment setFrame:CGRectMake(0, 0, tbl_comment.frame.size.width, self.view.frame.size.height - 216 - 44)];
     }
                     completion:^(BOOL finished)
     {
         [self scrollToBottom:NO];
     }
     ];
}

-(void)scrollToBottom : (BOOL)_animated
{
	CGFloat yoffset = -64;
	if (tbl_comment.contentSize.height > tbl_comment.bounds.size.height) {
		yoffset = tbl_comment.contentSize.height - tbl_comment.bounds.size.height;
	}
	
	[tbl_comment setContentOffset:CGPointMake(0, yoffset) animated:_animated];
}

-(void)hideView : (BOOL)_animated
{
    
    [UIView animateWithDuration:0.2f
                     animations:^
     {
         CGRect rt = viewForComment.frame;
         [viewForComment setFrame:CGRectMake(0, self.view.frame.size.height - 44, rt.size.width, rt.size.height)];
         
         [tbl_comment setFrame:CGRectMake(0, 0, tbl_comment.frame.size.width, self.view.frame.size.height)];
         [txtComment resignFirstResponder];
     }
                     completion:^(BOOL finished)
     {
         [self scrollToBottom:NO];
     }
     ];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:POSTMESSAGE object:nil];
}

-(void)getComments
{
    void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
        // Parse ;
        if( [ [ _responseObject objectForKey : @"success" ] isEqualToString : @"1" ] )
        {
            lst_comment = [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"detail"]];
            [tbl_comment reloadData];
        }
        else
        {
            [self getComments];
        }
    } ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
        [self getComments];
    } ;
    
    [[YYYCommunication sharedManager] getcomment:strPostID successed:successed failure:failure];
}

-(IBAction)btCommentClick:(id)sender
{
    void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
        // Parse ;
        if( [ [ _responseObject objectForKey : @"success" ] isEqualToString : @"1" ] )
        {
            lst_comment = [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"detail"]];
            [tbl_comment reloadData];
            
            [txtComment setText:@""];
            [self scrollToBottom:YES];
        }
    } ;
    
    [[YYYCommunication sharedManager] addcomment:strPostID userid:[[YYYCommunication sharedManager].me objectForKey:@"index"] comment:txtComment.text successed:successed failure:nil];
}

-(int)heightLabel:(NSString*)strText : (int)_nWidth : (UIFont*)_font{
    if ([strText isEqualToString:@""]) {
        return 0;
    }
    NSAttributedString *atrText = [[NSAttributedString alloc] initWithString:strText attributes:@{NSFontAttributeName:_font}];
    CGRect rect = [atrText boundingRectWithSize:CGSizeMake(_nWidth, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    return rect.size.height;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [lst_comment count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strIdentifier];
    
    UIImageView *imvUser = (UIImageView*)[cell viewWithTag:100];
    imvUser.layer.cornerRadius = imvUser.frame.size.height/2.0f;
    imvUser.layer.borderColor = [[UIColor whiteColor] CGColor];
    imvUser.layer.borderWidth = 2.0f;
    imvUser.clipsToBounds = YES;
    
    NSDictionary *dict = [lst_comment objectAtIndex:indexPath.row];
    [imvUser setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WEBAPI_URL,[dict objectForKey:@"user_avatar"]]]];
    
    [(UILabel*)[cell viewWithTag:101] setText:[dict objectForKey:@"username"]];
    
    UILabel *lblComment = (UILabel*)[cell viewWithTag:102];
    [lblComment setText:[dict objectForKey:@"comment"]];
    
    CGRect rt = lblComment.frame;
    rt.size.height = [self heightLabel:[dict objectForKey:@"comment"] :lblComment.frame.size.width :lblComment.font] + 5;
    lblComment.frame = rt;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[YYYCommunication sharedManager].me objectForKey:@"index"] isEqualToString:[[lst_comment objectAtIndex:indexPath.row] objectForKey:@"userid"]]) {
        return;
    }
    YYYUserProfileController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYUserProfileController"];
    viewcontroller.strUserID = [[lst_comment objectAtIndex:indexPath.row] objectForKey:@"userid"];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [lst_comment objectAtIndex:indexPath.row];
    return 50 + [self heightLabel:[dict objectForKey:@"comment"] :230.0f :[UIFont systemFontOfSize:15.0f]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
