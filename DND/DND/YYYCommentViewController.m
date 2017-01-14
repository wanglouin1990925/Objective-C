//
//  YYYCommentViewController.m
//  DND
//
//  Created by Wang MeiHua on 11/6/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYCommentViewController.h"
#import "YYYAppDelegate.h"
#import "YYYCommunication.h"
#import "MBProgressHUD.h"

@interface YYYCommentViewController ()

@end

@implementation YYYCommentViewController

@synthesize lstComment;
@synthesize rateid;
@synthesize bMyProfile;
@synthesize facebookid;

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
	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
	
	UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
	[tblComment addGestureRecognizer:gesture];
	
	txtComment.delegate = self;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO];
}

-(void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	[self.navigationController setNavigationBarHidden:YES];
}

-(IBAction)btBackClick:(id)sender
{
	if (bMyProfile)
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMyProfile" object:nil userInfo:nil];
	}
	else
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshUserProfile" object:nil userInfo:nil];
	}
	
	[self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[txtComment resignFirstResponder];
	return YES;
}

-(void)handleTap
{
	[txtComment resignFirstResponder];
}

#pragma mark - Keyboard events

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = vwTextfield.frame;
        frame.origin.y -= kbSize.height;
        vwTextfield.frame = frame;
        
        frame = tblComment.frame;
        frame.size.height -= kbSize.height;
        tblComment.frame = frame;
		
    } completion:^(BOOL finished) {
		[self scrollToBottom:NO];
	}];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = vwTextfield.frame;
        frame.origin.y += kbSize.height;
        vwTextfield.frame = frame;
        
        frame = tblComment.frame;
        frame.size.height += kbSize.height;
        tblComment.frame = frame;
    } completion:^(BOOL finished) {
//		[self scrollToBottom:NO];
	}];
}

-(BOOL)valideString:(NSString*)string
{
	if ([string hasPrefix:@"http://"] || [string hasPrefix:@"https://"] || [string hasPrefix:@"ftp://"] || [string hasPrefix:@"mailto://"])
	{
		return NO;
	}
	
	return YES;
}

-(IBAction)btSendClick:(id)sender
{
	if (![self valideString:txtComment.text.lowercaseString])
	{
		[self showAlert:@"Oops!" message:@"Comment can't contain link or hyperlink."];
		return;
	}
	if (txtComment.text.length < 1)
	{
		return;
	}
	
	[MBProgressHUD showHUDAddedTo:[YYYAppDelegate sharedDelegate].window animated:YES];
	
	void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
		
		[ MBProgressHUD hideHUDForView : [YYYAppDelegate sharedDelegate].window animated : YES ] ;
		
		if( [ [ _responseObject objectForKey : @"success" ] isEqualToString : @"1" ] )
		{
			lstComment = [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"detail"]];
			[tblComment reloadData];
			
			[self scrollToBottom:YES];
			[txtComment setText:@""];
			
			NSString *note = [NSString stringWithFormat:@"You have new review"];
			[[YYYAppDelegate sharedDelegate] sendPushNotification:facebookid :note];
		}
		else
		{
			[ self  showAlert:@"Oops!" message:@"An unknown error occured" ] ;
			return ;
		}
	} ;
	
	void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
		// Hide ;
		[ MBProgressHUD hideHUDForView : [YYYAppDelegate sharedDelegate].window animated : YES ] ;
		
		// Error ;
		[ self  showAlert:@"Oops!" message:@"An unknown error occured" ] ;
	} ;
	
	[[ YYYCommunication sharedManager ] Comment:[[YYYCommunication sharedManager].me objectForKey:@"user_id"]
										 rateid:rateid
										comment:txtComment.text
									  successed:successed
										failure:failure];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [lstComment count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGRect labelRect = [[[lstComment objectAtIndex:indexPath.row] objectForKey:@"cmt_description"] boundingRectWithSize:CGSizeMake(290, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0]} context:nil];
	
	return 10 + labelRect.size.height + 50;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
	
	UILabel *lblComment = (UILabel*)[cell viewWithTag:100];
	[lblComment setText:[[lstComment objectAtIndex:indexPath.row] objectForKey:@"cmt_description"]];
	
	UILabel *lblDate = (UILabel*)[cell viewWithTag:101];
	[lblDate setText:[self getDiffString:[[[lstComment objectAtIndex:indexPath.row] objectForKey:@"timediff"] intValue]]];
	
	return cell;
}

-(NSString*)getDiffString:(int)diffSec
{
	if (diffSec < 60)
	{
		return [NSString stringWithFormat:@"%dsecs ago",diffSec];
	}
	else if (diffSec < 60*60)
	{
		return [NSString stringWithFormat:@"%dmins ago",diffSec/60];
	}
	else if (diffSec <  60*60*60)
	{
		return [NSString stringWithFormat:@"%dhours ago",diffSec/3600];
	}
	else if (diffSec <  60*60*60*60)
	{
		return [NSString stringWithFormat:@"%ddays ago",diffSec/216000];
	}
	else
	{
		return [NSString stringWithFormat:@"%dmonths ago",diffSec/12960000];
	}
	
	return @"";
}

-(void)scrollToBottom : (BOOL)_animated
{
	CGFloat yoffset = 0;
	if (tblComment.contentSize.height > tblComment.bounds.size.height) {
		yoffset = tblComment.contentSize.height - tblComment.bounds.size.height;
	}
	
	[tblComment setContentOffset:CGPointMake(0, yoffset) animated:_animated];
}

-(void)showAlert:(NSString*)title message:(NSString*)message
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
