//
//  YYYChatsViewController.m
//  MoMo
//
//  Created by Wang MeiHua on 10/30/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYChatsViewController.h"
#import "YYYMessageViewController.h"
#import "UIImageView+AFNetworking.h"
#import "YYYCommunication.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIButton+AFNetworking.h"
#import "MBProgressHUD.h"
#import "YYYUserProfileViewController.h"
#import "YYYAppDelegate.h"
#import "YYYGroupProfileViewController.h"
#import "YYYGroupMessageViewController.h"

#define PHOTOBOUND		@"!@#!xyz!@#!"
#define MAPBOUND		@"!@!#xyz!@#!"
#define VIDEOBOUND		@"!@!x#yz!@#!"
#define VOICEBOUND		@"!@!xy#z!@#!"
#define STICKERBOUND	@"!@!xyz#!@#!"

@interface YYYChatsViewController ()

@end

@implementation YYYChatsViewController

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
	
//	refreshControl = [[UIRefreshControl alloc] init];
//	[tableView addSubview:refreshControl];
//	[refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
	
    indexPathForEdit = [NSIndexPath indexPathForRow:-1 inSection:-1];
    
	lstChat		= [[NSMutableArray alloc] init];
	lstGChat	= [[NSMutableArray alloc] init];
	lstInCome	= [[NSMutableArray alloc] init];
	lstGInCome	= [[NSMutableArray alloc] init];
	lstInbound	= [[NSMutableArray alloc] init];
    lstTemp     = [[NSMutableArray alloc] init];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData:) name:@"INCOMEMESSAGE" object:nil];
    // Do any additional setup after loading the view.
}

-(void)loadData:(NSNotification*)notif
{
//    2015-01-09 11:54:15
    indexPathForEdit = nil;
    
    for (int i = 0; i < [lstChat count]; i++)
    {
        if([(UITableViewCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] editingStyle] == UITableViewCellEditingStyleDelete)
        {
            indexPathForEdit = [NSIndexPath indexPathForRow:i inSection:0];
            break;
        }
    }
    
    for (int i = 0; i < [lstGChat count]; i++)
    {
        if([(UITableViewCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]] editingStyle] == UITableViewCellEditingStyleDelete)
        {
            indexPathForEdit = [NSIndexPath indexPathForRow:i inSection:1];
            break;
        }
    }
    
    for (int i = 0; i < [lstInbound count]; i++)
    {
        if([(UITableViewCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:2]] editingStyle] == UITableViewCellEditingStyleDelete)
        {
            indexPathForEdit = [NSIndexPath indexPathForRow:i inSection:2];
            break;
        }
    }
    
	if (![[[lstTemp lastObject] objectForKey:@"date"] isEqualToString:[[[notif.userInfo objectForKey:@"chats"] lastObject] objectForKey:@"date"]])
	{
        [lstTemp removeAllObjects];
		[lstChat removeAllObjects];
		[lstInbound removeAllObjects];
		
		for (NSDictionary *dict in [notif.userInfo objectForKey:@"chats"])
		{
            [lstTemp addObject:dict];
            
			if ([[dict objectForKey:@"sent"] boolValue])
			{
				[lstChat addObject:dict];
			}
			else
			{
				[lstInbound addObject:dict];
			}
		}
        
        if ([[notif.userInfo objectForKey:@"chats"] count])
        {
            [tableView reloadData];
        }		
	}
	if ([[notif.userInfo objectForKey:@"gchats"] count] && ![[[lstGChat lastObject] objectForKey:@"date"] isEqualToString:[[[notif.userInfo objectForKey:@"gchats"] lastObject] objectForKey:@"date"]])
	{
		lstGChat = [[NSMutableArray alloc] initWithArray:[notif.userInfo objectForKey:@"gchats"]];
		[tableView reloadData];
	}
	if ([lstInCome count] != [[notif.userInfo objectForKey:@"income"] count])
	{
		lstInCome = [[NSMutableArray alloc] initWithArray:[notif.userInfo objectForKey:@"income"]];
		[tableView reloadData];
	}
	if ([lstGInCome count] != [[notif.userInfo objectForKey:@"gincome"] count])
	{
		lstGInCome = [[NSMutableArray alloc] initWithArray:[notif.userInfo objectForKey:@"gincome"]];
		[tableView reloadData];
	}
}

-(NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0)
	{
		return [lstChat count];
	}
	else if (section == 1)
	{
		return [lstGChat count];
	}
	else if (section == 2)
	{
		return [lstInbound count];
	}
	else
	{
		return 0;
	}
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)_tableView
{
	if ([lstInbound count])
	{
		return 3;
	}
	
	return 2;
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPathForEdit == indexPath)
//    {
//        return UITableViewCellEditingStyleDelete;
//    }
//    else
//    {
//        return UITableViewCellEditingStyleDelete;
//    }
//}

-(UITableViewCell*)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0)
	{
		//Individual
		
		static NSString *identifer = @"CustomChatsCell";
		CustomChatsCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifer];
		cell.index		= (int)[lstChat count] - (int)indexPath.row - 1;
		cell.type		= 0;
		cell.delegate	= self;
		
        NSDictionary *dictMsg = [lstChat objectAtIndex:[lstChat count] - indexPath.row - 1 ];
		
		int nNewMsgCount = 0;
		for (NSDictionary *dict in lstInCome)
		{
			if ([[dict objectForKey:@"useridfrom"] intValue] == [[[dictMsg objectForKey:@"userinfo"] objectForKey:@"user_id"] intValue])
			{
				nNewMsgCount++;
			}
		}
		
		UILabel *lblNewMsgMark = (UILabel*)[cell viewWithTag:105];
		[lblNewMsgMark setHidden:YES];
		if (nNewMsgCount > 0)
		{
			[lblNewMsgMark setHidden:NO];
		}
		
		UIButton *imvAvatar = (UIButton*)[cell viewWithTag:100];
		imvAvatar.layer.cornerRadius = 10.0f;
		imvAvatar.clipsToBounds = YES;
        
        [[imvAvatar imageView] setContentMode:UIViewContentModeScaleAspectFill];
        
        NSString *avatarURL = [[dictMsg objectForKey:@"userinfo"] objectForKey:@"user_avatar"];
        NSString *facebookID = [[dictMsg objectForKey:@"userinfo"] objectForKey:@"user_facebookid"];
        
        if ([avatarURL isEqualToString:@""])
        {
            avatarURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",facebookID];
        }
        else
        {
            avatarURL = [NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[[dictMsg objectForKey:@"userinfo"] objectForKey:@"user_avatar"]];
        }
        
		[imvAvatar setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:avatarURL] placeholderImage:[UIImage imageNamed:@"user_defaul.png"]];
		
		UILabel *lblName = (UILabel*)[cell viewWithTag:101];
		[lblName setText:[[dictMsg objectForKey:@"userinfo"] objectForKey:@"user_name"]];
		
		UILabel *lblDate = (UILabel*)[cell viewWithTag:102];
		[lblDate setText:[self getDate:[[dictMsg objectForKey:@"diff"] intValue]]];
		
		//Message
		UILabel *lblMsg = (UILabel*)[cell viewWithTag:103];
		
		NSString *msg = [dictMsg objectForKey:@"message"];
		if ([msg rangeOfString:PHOTOBOUND].location == 0)
		{
			msg = @"#Photo";
		}
		if ([msg rangeOfString:VIDEOBOUND].location == 0)
		{
			msg = @"#Video";
		}
		if ([msg rangeOfString:VOICEBOUND].location == 0)
		{
			msg = @"#Audio";
		}
		if ([msg rangeOfString:MAPBOUND].location == 0)
		{
			msg = @"#Location";
		}
		if ([msg rangeOfString:STICKERBOUND].location == 0)
		{
			msg = @"#Sticker";
		}
		[lblMsg setText:msg];
		
		//Direction
		UIImageView *imvDirection = (UIImageView*)[cell viewWithTag:104];
		
		if ([[dictMsg objectForKey:@"direction"] intValue] == 1)
			[imvDirection setImage:[UIImage imageNamed:@"right.png"]];
		else if ([[dictMsg objectForKey:@"direction"] intValue] == 2)
			[imvDirection setImage:[UIImage imageNamed:@"left.png"]];
		
        if ([indexPath isEqual:indexPathForEdit])
        {
            cell.editing = YES;
        }
        
		return cell;
	}
	else if (indexPath.section == 1)
	{
		//Group
		
		static NSString *identifer = @"CustomChatsCell";
		CustomChatsCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifer];
		cell.index		= (int)[lstGChat count] - (int)indexPath.row - 1;
		cell.type		= 1;
		cell.delegate	= self;
		
		NSDictionary *dictMsg = [lstGChat objectAtIndex:[lstGChat count] - indexPath.row - 1 ];
		
		int nNewMsgCount = 0;
		for (NSDictionary *dict in lstGInCome)
		{
			if ([[dict objectForKey:@"groupid"] intValue] == [[[dictMsg objectForKey:@"groupinfo"] objectForKey:@"id"] intValue])
			{
				nNewMsgCount++;
			}
		}
		
		UILabel *lblNewMsgMark = (UILabel*)[cell viewWithTag:105];
		[lblNewMsgMark setHidden:YES];
		if (nNewMsgCount > 0)
		{
			[lblNewMsgMark setHidden:NO];
		}
		
		UIButton *imvAvatar = (UIButton*)[cell viewWithTag:100];
		imvAvatar.layer.cornerRadius = 10.0f;
		imvAvatar.clipsToBounds = YES;
		[imvAvatar setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[[dictMsg objectForKey:@"groupinfo"] objectForKey:@"avatar"]]] placeholderImage:[UIImage imageNamed:@"user_defaul.png"]];
        [[imvAvatar imageView] setContentMode:UIViewContentModeScaleAspectFill];
		
		UILabel *lblName = (UILabel*)[cell viewWithTag:101];
		[lblName setText:[[dictMsg objectForKey:@"groupinfo"] objectForKey:@"title"]];
		
		UILabel *lblDate = (UILabel*)[cell viewWithTag:102];
		[lblDate setText:[self getDate:[[dictMsg objectForKey:@"diff"] intValue]]];
		
		//Message
		UILabel *lblMsg = (UILabel*)[cell viewWithTag:103];
		
		NSString *msg = [dictMsg objectForKey:@"message"];
		if ([msg rangeOfString:PHOTOBOUND].location == 0)
		{
			msg = @"#Photo";
		}
		if ([msg rangeOfString:VIDEOBOUND].location == 0)
		{
			msg = @"#Video";
		}
		if ([msg rangeOfString:VOICEBOUND].location == 0)
		{
			msg = @"#Audio";
		}
		if ([msg rangeOfString:MAPBOUND].location == 0)
		{
			msg = @"#Location";
		}
		if ([msg rangeOfString:STICKERBOUND].location == 0)
		{
			msg = @"#Sticker";
		}
		[lblMsg setText:msg];
		
		//Direction
		UIImageView *imvDirection = (UIImageView*)[cell viewWithTag:104];
		
		if ([[dictMsg objectForKey:@"userid"] intValue] == [[dictMsg objectForKey:@"useridfrom"] intValue])
			[imvDirection setImage:[UIImage imageNamed:@"right.png"]];
		else
			[imvDirection setImage:[UIImage imageNamed:@"left.png"]];
		
        if ([indexPath isEqual:indexPathForEdit])
        {
            cell.editing = YES;
        }
        
		return cell;
	}
	else if (indexPath.section == 2)
	{
		//Inbound
		
		static NSString *identifer = @"CustomChatsCell";
		CustomChatsCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifer];
		cell.index		= (int)[lstInbound count] - (int)indexPath.row - 1;
		cell.type		= 2;
		cell.delegate	= self;
		
		NSDictionary *dictMsg = [lstInbound objectAtIndex:[lstInbound count] - indexPath.row - 1 ];
		
		int nNewMsgCount = 0;
		for (NSDictionary *dict in lstInCome)
		{
			if ([[dict objectForKey:@"useridfrom"] intValue] == [[[dictMsg objectForKey:@"userinfo"] objectForKey:@"user_id"] intValue])
			{
				nNewMsgCount++;
			}
		}
		
		UILabel *lblNewMsgMark = (UILabel*)[cell viewWithTag:105];
		[lblNewMsgMark setHidden:YES];
		if (nNewMsgCount > 0)
		{
			[lblNewMsgMark setHidden:NO];
		}
		
		UIButton *imvAvatar = (UIButton*)[cell viewWithTag:100];
		imvAvatar.layer.cornerRadius = 10.0f;
		imvAvatar.clipsToBounds = YES;
        
        NSString *avatarURL = [[dictMsg objectForKey:@"userinfo"] objectForKey:@"user_avatar"];
        NSString *facebookID = [[dictMsg objectForKey:@"userinfo"] objectForKey:@"user_facebookid"];
        
        if ([avatarURL isEqualToString:@""])
        {
            avatarURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",facebookID];
        }
        else
        {
            avatarURL = [NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[[dictMsg objectForKey:@"userinfo"] objectForKey:@"user_avatar"]];
        }
        
		[imvAvatar setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:avatarURL] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
		[[imvAvatar imageView] setContentMode:UIViewContentModeScaleAspectFill];
        
		UILabel *lblName = (UILabel*)[cell viewWithTag:101];
		[lblName setText:[[dictMsg objectForKey:@"userinfo"] objectForKey:@"user_name"]];
		
		UILabel *lblDate = (UILabel*)[cell viewWithTag:102];
		[lblDate setText:[self getDate:[[dictMsg objectForKey:@"diff"] intValue]]];
		
		//Message
		UILabel *lblMsg = (UILabel*)[cell viewWithTag:103];
		
		NSString *msg = [dictMsg objectForKey:@"message"];
		if ([msg rangeOfString:PHOTOBOUND].location == 0)
		{
			msg = @"#Photo";
		}
		if ([msg rangeOfString:VIDEOBOUND].location == 0)
		{
			msg = @"#Video";
		}
		if ([msg rangeOfString:VOICEBOUND].location == 0)
		{
			msg = @"#Audio";
		}
		if ([msg rangeOfString:MAPBOUND].location == 0)
		{
			msg = @"#Location";
		}
		if ([msg rangeOfString:STICKERBOUND].location == 0)
		{
			msg = @"#Sticker";
		}
		[lblMsg setText:msg];
		
		//Direction
		UIImageView *imvDirection = (UIImageView*)[cell viewWithTag:104];
		
		if ([[dictMsg objectForKey:@"direction"] intValue] == 1)
			[imvDirection setImage:[UIImage imageNamed:@"right.png"]];
		else if ([[dictMsg objectForKey:@"direction"] intValue] == 2)
			[imvDirection setImage:[UIImage imageNamed:@"left.png"]];
        
        if ([indexPath isEqual:indexPathForEdit])
        {
            cell.editing = YES;
        }
        
		return cell;
	}
	else
	{
		return nil;
	}
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	CustomTableViewHeader *header = [CustomTableViewHeader sharedView];
	
	UILabel *lblTitle = (UILabel*)[header viewWithTag:100];
	
	if (section == 0)
	{
		[lblTitle setText:@"Individual Messages"];
	}
	else if (section == 1)
	{
		[lblTitle setText:@"Group Messages"];
	}
	else if (section == 2)
	{
		[lblTitle setText:@"Inbound Messages"];
	}
	
	
	return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if (section == 0)
	{
		return 0;
	}
	else if (section == 1)
	{
		return 0;
	}
	else if (section == 2)
	{
		return 30;
	}
	else
	{
		return 0;
	}
}

-(BOOL)tableView:(UITableView *)_tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

-(void)tableView:(UITableView *)_tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
        NSString *lstmsgId	= @"";
		NSString *glstmsgId	= @"";
		
		if (indexPath.section == 0 || indexPath.section == 2)
		{
            if (indexPath.section == 0)
            {
                lstmsgId = [[lstChat objectAtIndex:[lstChat count] - indexPath.row - 1] objectForKey:@"id"];
            }
			else
            {
                lstmsgId = [[lstInbound objectAtIndex:[lstInbound count] - indexPath.row - 1] objectForKey:@"id"];
            }
		}
		else if (indexPath.section == 1)
		{
			glstmsgId = [[lstGChat objectAtIndex:[lstGChat count] - indexPath.row - 1] objectForKey:@"id"];
		}
        else
        {
            return;
        }
		
		[MBProgressHUD showHUDAddedTo:[YYYAppDelegate sharedDelegate].window animated:YES];
		
		void ( ^successed )( id _responseObject ) = ^( id _responseObject )
		{
			[MBProgressHUD hideAllHUDsForView:[YYYAppDelegate sharedDelegate].window animated:YES];
			
			if ([[_responseObject objectForKey:@"success"] isEqualToString:@"1"])
			{
				if (indexPath.section == 0)
				{
					[lstChat removeObjectAtIndex:[lstChat count] - indexPath.row - 1];
					
				}
				else if (indexPath.section == 1)
				{
					[lstGChat removeObjectAtIndex:[lstGChat count] - indexPath.row - 1];
				}
                else if (indexPath.section == 2)
                {
                    [lstInbound removeObjectAtIndex:[lstInbound count] - indexPath.row - 1];
                }
				
                indexPathForEdit = nil;
				[tableView reloadData];
			}
			else
			{
				NSLog(@"%@",_responseObject);
			}
		} ;
		
		void ( ^failure )( NSError* _error ) = ^( NSError* _error )
		{
			[MBProgressHUD hideAllHUDsForView:[YYYAppDelegate sharedDelegate].window animated:YES];
		} ;
		
		[[YYYCommunication sharedManager] DeleteChatsHistory:lstmsgId glstmsgid:glstmsgId successed:successed failure:failure];
	}
}

-(void)DidAvatarClicked:(int)index :(int)type
{
	if (type == 0)
	{
		[self gotoUserProfile:[[[lstChat objectAtIndex:index] objectForKey:@"userinfo"] objectForKey:@"user_id"]];
	}
	else if (type == 1)
	{
		[self gotoGroupProfile:[[[lstGChat objectAtIndex:index] objectForKey:@"groupinfo"] objectForKey:@"id"]];
	}
	else if (type == 2)
	{
		[self gotoUserProfile:[[[lstInbound objectAtIndex:index] objectForKey:@"userinfo"] objectForKey:@"user_id"]];
	}
}

-(void)gotoUserProfile:(NSString*)userID
{
	[MBProgressHUD showHUDAddedTo:[YYYAppDelegate sharedDelegate].window animated:YES];
	
	void ( ^successed )( id _responseObject ) = ^( id _responseObject )
	{
		[MBProgressHUD hideAllHUDsForView:[YYYAppDelegate sharedDelegate].window animated:YES];
		
		if ([[_responseObject objectForKey:@"success"] isEqualToString:@"1"])
		{
			YYYUserProfileViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYUserProfileViewController"];
			
			viewcontroller.dictInfo = [[NSDictionary alloc] initWithDictionary:[_responseObject objectForKey:@"detail"]];
			viewcontroller.lstPhoto = [[NSArray alloc] initWithArray:[_responseObject objectForKey:@"photoarray"]];
			viewcontroller.lstGroup = [[NSArray alloc] initWithArray:[_responseObject objectForKey:@"grouparray"]];
			
			[self.navigationController pushViewController:viewcontroller animated:YES];
		}
		else
		{
			
		}
	} ;
	
	void ( ^failure )( NSError* _error ) = ^( NSError* _error )
	{
		[MBProgressHUD hideAllHUDsForView:[YYYAppDelegate sharedDelegate].window animated:YES];
	} ;
	
	[[YYYCommunication sharedManager] LoadUserProfile:userID
											successed:successed
											  failure:failure];
}

-(void)gotoGroupProfile:(NSString*)groupID
{
	[MBProgressHUD showHUDAddedTo:[YYYAppDelegate sharedDelegate].window animated:YES];
	
	void ( ^successed )( id _responseObject ) = ^( id _responseObject )
	{
		[MBProgressHUD hideAllHUDsForView:[YYYAppDelegate sharedDelegate].window animated:YES];
		
		if ([[_responseObject objectForKey:@"success"] isEqualToString:@"1"])
		{
			YYYGroupProfileViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYGroupProfileViewController"];
			
			viewcontroller.dictInfo		= [[NSMutableDictionary alloc] initWithDictionary:[_responseObject objectForKey:@"detail"]];
			viewcontroller.lstUsers		= [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"userarray"]];
			viewcontroller.lstPhotos	= [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"photoarray"]];
			
			[self.navigationController pushViewController:viewcontroller animated:YES];
		}
		else
		{
			
		}
	} ;
	
	void ( ^failure )( NSError* _error ) = ^( NSError* _error )
	{
		[MBProgressHUD hideAllHUDsForView:[YYYAppDelegate sharedDelegate].window animated:YES];
	} ;
	
	[[YYYCommunication sharedManager] LoadGroupProfile:groupID
											 successed:successed
											   failure:failure];
}

-(NSString*)getDate : (int)diff
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:-diff];
	
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([[[date description] substringToIndex:10] isEqualToString:[[[NSDate date] description] substringToIndex:10]]) {
        formatter.timeStyle = NSDateFormatterShortStyle;
    }else{
        formatter.dateStyle = NSDateFormatterShortStyle;
    }
    return [formatter stringFromDate:date];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0)
	{
		YYYMessageViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYMessageViewController"];
		viewcontroller.dictUser = [[lstChat objectAtIndex:[lstChat count] - indexPath.row - 1] objectForKey:@"userinfo"];
		[self.navigationController pushViewController:viewcontroller animated:YES];
	}
	else if (indexPath.section == 1)
	{
		YYYGroupMessageViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYGroupMessageViewController"];
		viewcontroller.dictGroup	= [[lstGChat objectAtIndex:[lstGChat count] - indexPath.row - 1] objectForKey:@"groupinfo"];
		viewcontroller.lstMembers	= [[NSMutableArray alloc] initWithArray:[[lstGChat objectAtIndex:[lstGChat count] - indexPath.row - 1] objectForKey:@"groupusers"]];
		[self.navigationController pushViewController:viewcontroller animated:YES];
	}
	else if (indexPath.section == 2)
	{
		YYYMessageViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYMessageViewController"];
		viewcontroller.dictUser = [[lstInbound objectAtIndex:[lstInbound count] - indexPath.row - 1] objectForKey:@"userinfo"];
		[self.navigationController pushViewController:viewcontroller animated:YES];
	}
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
