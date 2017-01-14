//
//  YYYProfileViewController.m
//  MoMo
//
//  Created by Wang MeiHua on 11/5/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYUserProfileViewController.h"
#import "YYYCommunication.h"
#import "UIImageView+AFNetworking.h"
#import "YYYEditProfileViewController.h"
#import "UIButton+AFNetworking.h"
#import "MBProgressHUD.h"
#import <CoreLocation/CoreLocation.h>
#import "YYYAppDelegate.h"
#import "YYYMessageViewController.h"
#import "YYYGroupProfileViewController.h"

@interface YYYUserProfileViewController ()

@end

@implementation YYYUserProfileViewController

@synthesize dictInfo;
@synthesize lstGroup;
@synthesize lstPhoto;

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
	
	imvAvatar.layer.borderWidth = 2.0f;
	imvAvatar.layer.borderColor = [[UIColor whiteColor] CGColor];
	imvAvatar.layer.cornerRadius = imvAvatar.frame.size.height/2.0f;
	imvAvatar.clipsToBounds = YES;
	
	vwInfoContainer.layer.cornerRadius = 2.0f;
	vwInfoContainer.clipsToBounds = YES;
	
	CGRect rt = vwAboutMe.frame;
	rt.size.height = 0;
	vwAboutMe.frame = rt;
	
	rt = vwAlbum.frame;
	rt.size.height = 0;
	vwAlbum.frame = rt;
	
	rt = vwGroup.frame;
	rt.size.height = 0;
	vwGroup.frame = rt;
	
	[scvContent setContentSize:CGSizeMake(320, 210)];
	
	[self showData];
	// Do any additional setup after loading the view.
}

-(void)showData
{
	[vwFriend setHidden:YES];
	[vwNormal setHidden:YES];
	[vwBlock setHidden:YES];
	
	if ([[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"] intValue] == [[dictInfo objectForKey:@"user_id"] intValue])
		return;
	
	NSMutableArray *lstFriendID = [[NSMutableArray alloc] init];
	for (NSDictionary *dict in [YYYCommunication sharedManager].lstFriend)
	{
		[lstFriendID addObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"user_id"]]];
	}
	
	NSMutableArray *lstBlockID = [[NSMutableArray alloc] init];
	for (NSDictionary *dict in [YYYCommunication sharedManager].lstBlock)
	{
		[lstBlockID addObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"user_id"]]];
	}
	
	if ([lstFriendID containsObject:[dictInfo objectForKey:@"user_id"]])
	{
		[vwFriend setHidden:NO];
		
	}
	else if ([lstBlockID containsObject:[dictInfo objectForKey:@"user_id"]])
	{
		[vwBlock setHidden:NO];
		
	}
	else
	{
		[vwNormal setHidden:NO];
	}
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self showProfile];
}

-(void)showProfile
{
	for (UIView *vw in vwAlbum.subviews)
	{
		if ([vw isKindOfClass:[UIButton class]])
		{
			[vw removeFromSuperview];
		}
	}
	
	for (UIView *vw in vwGroup.subviews)
	{
		if ([vw isKindOfClass:[UIButton class]] || [vw isKindOfClass:[UIImageView class]])
		{
			[vw removeFromSuperview];
		}
	}
	
	[self.navigationItem setTitle:[dictInfo objectForKey:@"user_username"]];
    
    NSString *avatarURL = [dictInfo objectForKey:@"user_avatar"];
    NSString *facebookID = [dictInfo objectForKey:@"user_facebookid"];
    
    if ([avatarURL isEqualToString:@""] && ![facebookID isEqualToString:@""])
    {
        avatarURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",facebookID];
    }
    else
    {
        avatarURL = [NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[dictInfo objectForKey:@"user_avatar"]];
    }
    
    NSString *coverURL = [dictInfo objectForKey:@"user_coverphoto"];
    if ([coverURL isEqualToString:@""])
    {
        coverURL = avatarURL;
    }
    else
    {
        coverURL = [NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[dictInfo objectForKey:@"user_coverphoto"]];
    }
    
    [imvAvatar	setImageWithURL:[NSURL URLWithString:avatarURL]];
    [imvCover	setImageWithURL:[NSURL URLWithString:coverURL]];
    
	[lblName	setText:[dictInfo objectForKey:@"user_name"]];
	[lblAboutme	setText:[dictInfo objectForKey:@"user_aboutme"]];
	[lblAge		setText:[self getAge:[dictInfo objectForKey:@"user_birthday"]]];
	[lblDistance setText:@"0.00km | 1m ago"];
	
	//Distance
	CLLocation *location1 = [[CLLocation alloc] initWithLatitude:[YYYAppDelegate sharedDelegate].fLat longitude:[YYYAppDelegate sharedDelegate].fLng];
	CLLocation *location2 = [[CLLocation alloc] initWithLatitude:[[dictInfo objectForKey:@"user_latitude"] floatValue] longitude:[[dictInfo objectForKey:@"user_longitude"] floatValue]];
	float fDistance = [location1 distanceFromLocation:location2]/1000;
	
	[lblDistance setText:[NSString stringWithFormat:@"%.2fkm | %@",fDistance,[self getDiffString:[[dictInfo objectForKey:@"lastlogin"] intValue]]]];
	
	int nPos = 210;
	if ([lblAboutme text].length)
	{
		CGRect labelRect = [[lblAboutme text] boundingRectWithSize:CGSizeMake(300, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [lblAboutme font]} context:nil];
		
		CGRect rt = vwAboutMe.frame;
		rt.size.height = 45 + labelRect.size.height + 10 + 5;
		vwAboutMe.frame = rt;
		nPos = nPos +rt.size.height;
	}
	
	int nPhotoCount = (int)[lstPhoto count];
	if (nPhotoCount)
	{
		CGRect rt = vwAlbum.frame;
		rt.origin.y = nPos;
		rt.size.height = (int)((nPhotoCount/4.0) + 0.75) * 78 + 45;
		vwAlbum.frame = rt;
		nPos = nPos +rt.size.height;
		
		for (int i = 0; i < nPhotoCount; i++)
		{
			UIButton *btPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
			[btPhoto setFrame:CGRectMake(8 + 78 * (i%4), 45 + 78 * (i/4), 70, 70)];
			[btPhoto setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[[lstPhoto objectAtIndex:i] objectForKey:@"photo"]]]];
			btPhoto.layer.cornerRadius = 10.0f;
			btPhoto.clipsToBounds = YES;
			btPhoto.tag = 1000 + i;
			[btPhoto addTarget:self action:@selector(btSinglePhotoClicked:) forControlEvents:UIControlEventTouchUpInside];
			[vwAlbum addSubview:btPhoto];
		}
	}
	
	int nGroupCount = (int)[lstGroup count];
	if (nGroupCount)
	{
		CGRect rt = vwGroup.frame;
		rt.origin.y = nPos;
		rt.size.height = nGroupCount * 44 + 37;
		vwGroup.frame = rt;
		nPos = nPos +rt.size.height;
		
		for (int i = 0; i < nGroupCount; i++)
		{
			NSDictionary *dictGroup = [lstGroup objectAtIndex:i];
			
			UIButton *btPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
			[btPhoto setFrame:CGRectMake(11 , 45 + 44 * i, 30, 30)];
			[btPhoto setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[dictGroup objectForKey:@"avatar"]]]];
			btPhoto.layer.cornerRadius = 5.0f;
			btPhoto.clipsToBounds = YES;
			btPhoto.tag = 100 + i;
			[btPhoto addTarget:self action:@selector(btGroupClick:) forControlEvents:UIControlEventTouchUpInside];
			[vwGroup addSubview:btPhoto];
			
			UIButton *btTitle = [UIButton buttonWithType:UIButtonTypeCustom];
			[btTitle  setFrame:CGRectMake(0, 45 + 44 * i, 320, 30)];
			[btTitle setTitle:[dictGroup objectForKey:@"title"] forState:UIControlStateNormal];
			[btTitle.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0]];
			btTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
			btTitle.contentEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
			[btTitle setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
			[btTitle addTarget:self action:@selector(btGroupClick:) forControlEvents:UIControlEventTouchUpInside];
			btTitle.tag = 200 + i;
			[vwGroup addSubview:btTitle];
			
			UIImageView *imvSeparateLine =[[UIImageView alloc] initWithFrame:CGRectMake(0, 37 + i * 44, 320, 1)];
			[imvSeparateLine setBackgroundColor:[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f]];
			[vwGroup addSubview:imvSeparateLine];
		}
	}
    
    //Company
    if ([[dictInfo objectForKey:@"user_company"] length])
    {
        NSString *company = [dictInfo objectForKey:@"user_company"];
        
        CGRect labelRect = [company boundingRectWithSize:CGSizeMake(300, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [lblAboutme font]} context:nil];
        
        UIView *vwCompany = [[UIView alloc] initWithFrame:CGRectMake(0, nPos, 320, 45 + labelRect.size.height + 10 + 5)];
        [vwCompany setBackgroundColor:[UIColor whiteColor]];
        nPos = nPos + vwCompany.frame.size.height;
        
        UILabel *lblCompany = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 300, labelRect.size.height + 10)];
        [lblCompany setFont:[lblAboutme font]];
        [lblCompany setText:company];
        [vwCompany addSubview:lblCompany];
        
        UILabel *lblSubTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 37)];
        [lblSubTitle setText:@"   COMPANY"];
        [lblSubTitle setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:17.0]];
        [lblSubTitle setTextColor:[UIColor darkGrayColor]];
        [lblSubTitle setBackgroundColor:[UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0f]];
        [vwCompany addSubview:lblSubTitle];
        
        UIImageView *imvSeparateLine =[[UIImageView alloc] initWithFrame:CGRectMake(0, 37, 320, 1)];
        [imvSeparateLine setBackgroundColor:[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f]];
        [vwCompany addSubview:imvSeparateLine];
        
        [scvContent addSubview:vwCompany];
    }
    
    //University
    if ([[dictInfo objectForKey:@"user_university"] length])
    {
        NSString *company = [dictInfo objectForKey:@"user_university"];
        
        CGRect labelRect = [company boundingRectWithSize:CGSizeMake(300, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [lblAboutme font]} context:nil];
        
        UIView *vwCompany = [[UIView alloc] initWithFrame:CGRectMake(0, nPos, 320, 45 + labelRect.size.height + 10 + 5)];
        [vwCompany setBackgroundColor:[UIColor whiteColor]];
        nPos = nPos + vwCompany.frame.size.height;
        
        UILabel *lblCompany = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 300, labelRect.size.height + 10)];
        [lblCompany setFont:[lblAboutme font]];
        [lblCompany setText:company];
        [vwCompany addSubview:lblCompany];
        
        UILabel *lblSubTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 37)];
        [lblSubTitle setText:@"   UNIVERSITY"];
        [lblSubTitle setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:17.0]];
        [lblSubTitle setTextColor:[UIColor darkGrayColor]];
        [lblSubTitle setBackgroundColor:[UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0f]];
        [vwCompany addSubview:lblSubTitle];
        
        UIImageView *imvSeparateLine =[[UIImageView alloc] initWithFrame:CGRectMake(0, 37, 320, 1)];
        [imvSeparateLine setBackgroundColor:[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f]];
        [vwCompany addSubview:imvSeparateLine];
        
        [scvContent addSubview:vwCompany];
    }
    
    //Home Town
    if ([[dictInfo objectForKey:@"user_hometown"] length])
    {
        NSString *company = [dictInfo objectForKey:@"user_hometown"];
        
        CGRect labelRect = [company boundingRectWithSize:CGSizeMake(300, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [lblAboutme font]} context:nil];
        
        UIView *vwCompany = [[UIView alloc] initWithFrame:CGRectMake(0, nPos, 320, 45 + labelRect.size.height + 10 + 5)];
        [vwCompany setBackgroundColor:[UIColor whiteColor]];
        nPos = nPos + vwCompany.frame.size.height;
        
        UILabel *lblCompany = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 300, labelRect.size.height + 10)];
        [lblCompany setFont:[lblAboutme font]];
        [lblCompany setText:company];
        [vwCompany addSubview:lblCompany];
        
        UILabel *lblSubTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 37)];
        [lblSubTitle setText:@"   HOMETOWN"];
        [lblSubTitle setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:17.0]];
        [lblSubTitle setTextColor:[UIColor darkGrayColor]];
        [lblSubTitle setBackgroundColor:[UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0f]];
        [vwCompany addSubview:lblSubTitle];
        
        UIImageView *imvSeparateLine =[[UIImageView alloc] initWithFrame:CGRectMake(0, 37, 320, 1)];
        [imvSeparateLine setBackgroundColor:[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f]];
        [vwCompany addSubview:imvSeparateLine];
        
        [scvContent addSubview:vwCompany];
    }
    
    //Hobbies
    if ([[dictInfo objectForKey:@"user_hobbies"] length])
    {
        NSString *company = [dictInfo objectForKey:@"user_hobbies"];
        
        CGRect labelRect = [company boundingRectWithSize:CGSizeMake(300, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [lblAboutme font]} context:nil];
        
        UIView *vwCompany = [[UIView alloc] initWithFrame:CGRectMake(0, nPos, 320, 45 + labelRect.size.height + 10 + 5)];
        [vwCompany setBackgroundColor:[UIColor whiteColor]];
        nPos = nPos + vwCompany.frame.size.height;
        
        UILabel *lblCompany = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 300, labelRect.size.height + 10)];
        [lblCompany setFont:[lblAboutme font]];
        [lblCompany setText:company];
        [vwCompany addSubview:lblCompany];
        
        UILabel *lblSubTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 37)];
        [lblSubTitle setText:@"   HOBBIES"];
        [lblSubTitle setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:17.0]];
        [lblSubTitle setTextColor:[UIColor darkGrayColor]];
        [lblSubTitle setBackgroundColor:[UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0f]];
        [vwCompany addSubview:lblSubTitle];
        
        UIImageView *imvSeparateLine =[[UIImageView alloc] initWithFrame:CGRectMake(0, 37, 320, 1)];
        [imvSeparateLine setBackgroundColor:[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f]];
        [vwCompany addSubview:imvSeparateLine];
        
        [scvContent addSubview:vwCompany];
    }
    
    //Favorite Music
    if ([[dictInfo objectForKey:@"user_music"] length])
    {
        NSString *company = [dictInfo objectForKey:@"user_music"];
        
        CGRect labelRect = [company boundingRectWithSize:CGSizeMake(300, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [lblAboutme font]} context:nil];
        
        UIView *vwCompany = [[UIView alloc] initWithFrame:CGRectMake(0, nPos, 320, 45 + labelRect.size.height + 10 + 5)];
        [vwCompany setBackgroundColor:[UIColor whiteColor]];
        nPos = nPos + vwCompany.frame.size.height;
        
        UILabel *lblCompany = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 300, labelRect.size.height + 10)];
        [lblCompany setFont:[lblAboutme font]];
        [lblCompany setText:company];
        [vwCompany addSubview:lblCompany];
        
        UILabel *lblSubTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 37)];
        [lblSubTitle setText:@"   FAVORITE MUSIC"];
        [lblSubTitle setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:17.0]];
        [lblSubTitle setTextColor:[UIColor darkGrayColor]];
        [lblSubTitle setBackgroundColor:[UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0f]];
        [vwCompany addSubview:lblSubTitle];
        
        UIImageView *imvSeparateLine =[[UIImageView alloc] initWithFrame:CGRectMake(0, 37, 320, 1)];
        [imvSeparateLine setBackgroundColor:[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f]];
        [vwCompany addSubview:imvSeparateLine];
        
        [scvContent addSubview:vwCompany];
    }
    
    //Favorite Books
    if ([[dictInfo objectForKey:@"user_books"] length])
    {
        NSString *company = [dictInfo objectForKey:@"user_books"];
        
        CGRect labelRect = [company boundingRectWithSize:CGSizeMake(300, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [lblAboutme font]} context:nil];
        
        UIView *vwCompany = [[UIView alloc] initWithFrame:CGRectMake(0, nPos, 320, 45 + labelRect.size.height + 10 + 5)];
        [vwCompany setBackgroundColor:[UIColor whiteColor]];
        nPos = nPos + vwCompany.frame.size.height;
        
        UILabel *lblCompany = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 300, labelRect.size.height + 10)];
        [lblCompany setFont:[lblAboutme font]];
        [lblCompany setText:company];
        [vwCompany addSubview:lblCompany];
        
        UILabel *lblSubTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 37)];
        [lblSubTitle setText:@"   FAVORITE BOOKS"];
        [lblSubTitle setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:17.0]];
        [lblSubTitle setTextColor:[UIColor darkGrayColor]];
        [lblSubTitle setBackgroundColor:[UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0f]];
        [vwCompany addSubview:lblSubTitle];
        
        UIImageView *imvSeparateLine =[[UIImageView alloc] initWithFrame:CGRectMake(0, 37, 320, 1)];
        [imvSeparateLine setBackgroundColor:[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f]];
        [vwCompany addSubview:imvSeparateLine];
        
        [scvContent addSubview:vwCompany];
    }
    
    //Favorite Movies and TV Shows
    if ([[dictInfo objectForKey:@"user_movies"] length])
    {
        NSString *company = [dictInfo objectForKey:@"user_movies"];
        
        CGRect labelRect = [company boundingRectWithSize:CGSizeMake(300, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [lblAboutme font]} context:nil];
        
        UIView *vwCompany = [[UIView alloc] initWithFrame:CGRectMake(0, nPos, 320, 45 + labelRect.size.height + 10 + 5)];
        [vwCompany setBackgroundColor:[UIColor whiteColor]];
        nPos = nPos + vwCompany.frame.size.height;
        
        UILabel *lblCompany = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 300, labelRect.size.height + 10)];
        [lblCompany setFont:[lblAboutme font]];
        [lblCompany setText:company];
        [vwCompany addSubview:lblCompany];
        
        UILabel *lblSubTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 37)];
        [lblSubTitle setText:@"   FAVORITE MOVIES AND TV SHOWS"];
        [lblSubTitle setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:17.0]];
        [lblSubTitle setTextColor:[UIColor darkGrayColor]];
        [lblSubTitle setBackgroundColor:[UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0f]];
        [vwCompany addSubview:lblSubTitle];
        
        UIImageView *imvSeparateLine =[[UIImageView alloc] initWithFrame:CGRectMake(0, 37, 320, 1)];
        [imvSeparateLine setBackgroundColor:[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f]];
        [vwCompany addSubview:imvSeparateLine];
        
        [scvContent addSubview:vwCompany];
    }
    
    //LOOKING TO MET
    if ([[dictInfo objectForKey:@"user_looking"] length])
    {
        NSString *company = [dictInfo objectForKey:@"user_looking"];
        
        CGRect labelRect = [company boundingRectWithSize:CGSizeMake(300, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [lblAboutme font]} context:nil];
        
        UIView *vwCompany = [[UIView alloc] initWithFrame:CGRectMake(0, nPos, 320, 45 + labelRect.size.height + 10 + 5)];
        [vwCompany setBackgroundColor:[UIColor whiteColor]];
        nPos = nPos + vwCompany.frame.size.height;
        
        UILabel *lblCompany = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 300, labelRect.size.height + 10)];
        [lblCompany setFont:[lblAboutme font]];
        [lblCompany setText:company];
        [vwCompany addSubview:lblCompany];
        
        UILabel *lblSubTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 37)];
        [lblSubTitle setText:@"   LOOKING TO MEET"];
        [lblSubTitle setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:17.0]];
        [lblSubTitle setTextColor:[UIColor darkGrayColor]];
        [lblSubTitle setBackgroundColor:[UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0f]];
        [vwCompany addSubview:lblSubTitle];
        
        UIImageView *imvSeparateLine =[[UIImageView alloc] initWithFrame:CGRectMake(0, 37, 320, 1)];
        [imvSeparateLine setBackgroundColor:[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f]];
        [vwCompany addSubview:imvSeparateLine];
        
        [scvContent addSubview:vwCompany];
    }
	
	if (nPos < scvContent.frame.size.height)
	{
		nPos = scvContent.frame.size.height + 20;
	}
	
	[scvContent setContentSize:CGSizeMake(320, nPos)];
}

-(IBAction)btSinglePhotoClicked:(id)sender
{
	CustomPhotoLargeView *view = [CustomPhotoLargeView sharedView];
	[view setFrame:[YYYAppDelegate sharedDelegate].window.frame];
	view.delegate = self;
	[view initWithData:lstPhoto];
	[view setCurrentPage:(int)[sender tag] - 1000];
	[[YYYAppDelegate sharedDelegate].window addSubview:view];
}

-(void)DidBackClick:(id)view
{
	[view removeFromSuperview];
}

-(IBAction)btGroupClick:(id)sender
{
	NSString *groupId	= [[lstGroup objectAtIndex:[sender tag]%100] objectForKey:@"id"];
	
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
	
	[[YYYCommunication sharedManager] LoadGroupProfile:groupId
											 successed:successed
											   failure:failure];
	
}

-(void)showAlert:(NSString*)title message:(NSString*)message
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
}

-(NSString *)getAge:(NSString *)pstrDate
{
    NSArray *arrayDateData = [pstrDate componentsSeparatedByString:@"-"];
    NSString *strAge = @"";
    if([arrayDateData count]>=2){
        
        NSDate *currentDate = [NSDate date];
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate]; // Get necessary date components
        
        int nAge = (int)[components year] - [[arrayDateData objectAtIndex:0] intValue];
        
        strAge = [NSString stringWithFormat:@"%d",nAge - 1];
    }else{
        strAge = @"";
    }
    
    if ([strAge intValue] > 100)
    {
        return @"--";
    }
	
    return strAge;
}

-(NSString*)getDiffString:(int)diffSec
{
    if (diffSec < 60)
    {
        return [NSString stringWithFormat:@"%ds ago",diffSec];
    }
    else if (diffSec < 60*60)
    {
        return [NSString stringWithFormat:@"%dm ago",diffSec/60];
    }
    else if (diffSec <  60*60*24)
    {
        return [NSString stringWithFormat:@"%dh ago",diffSec/3600];
    }
    else if (diffSec <  60*60*24*30)
    {
        return [NSString stringWithFormat:@"%dd ago",diffSec/86400];
    }
    else
    {
        return [NSString stringWithFormat:@"%dM ago",diffSec/2592000];
    }
    
    return @"";
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (scrollView.contentOffset.y >= 0)
	{
		[vwProfile setFrame:CGRectMake(0, 0, 320, 180)];
	}
	else
	{
		[vwProfile setFrame:CGRectMake(0, scrollView.contentOffset.y, 320, 180 - scrollView.contentOffset.y)];
	}
}

-(IBAction)btBackClick:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btChatClick:(id)sender
{
	YYYMessageViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYMessageViewController"];
	viewcontroller.dictUser = dictInfo;
	[self.navigationController pushViewController:viewcontroller animated:YES];
}

-(IBAction)btAddClick:(id)sender
{
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	void ( ^successed )( id _responseObject ) = ^( id _responseObject )
	{
		[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
		if ([[_responseObject objectForKey:@"success"] isEqualToString:@"1"])
		{
			[[YYYCommunication sharedManager].lstFriend addObject:[_responseObject objectForKey:@"detail"]];
			[self showData];
		}
		else
		{
			[self showAlert:@"Oops!" message:[_responseObject objectForKey:@"detail"]];
		}
	} ;
	
	void ( ^failure )( NSError* _error ) = ^( NSError* _error )
	{
		[self showAlert:@"Oops!" message:@"An unknown error occured"];
		[ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
	} ;
	
	[[YYYCommunication sharedManager] AddFriend:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"] useridto:[dictInfo objectForKey:@"user_id"] successed:successed failure:failure];
}

-(IBAction)btBlockClick:(id)sender
{
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	void ( ^successed )( id _responseObject ) = ^( id _responseObject )
	{
		[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
		if ([[_responseObject objectForKey:@"success"] isEqualToString:@"1"])
		{
			[[YYYCommunication sharedManager].lstFriend removeObject:[_responseObject objectForKey:@"detail"]];
			[[YYYCommunication sharedManager].lstBlock addObject:[_responseObject objectForKey:@"detail"]];
			[self showData];
		}
		else
		{
			[self showAlert:@"Oops!" message:[_responseObject objectForKey:@"detail"]];
		}
	} ;
	
	void ( ^failure )( NSError* _error ) = ^( NSError* _error )
	{
		[self showAlert:@"Oops!" message:@"An unknown error occured"];
		[ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
	} ;
	
	[[YYYCommunication sharedManager] BlockFriend:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"] useridto:[dictInfo objectForKey:@"user_id"] successed:successed failure:failure];
}

-(IBAction)btUnFriendClick:(id)sender
{
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	void ( ^successed )( id _responseObject ) = ^( id _responseObject )
	{
		[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
		if ([[_responseObject objectForKey:@"success"] isEqualToString:@"1"])
		{
			[[YYYCommunication sharedManager].lstFriend removeObject:[_responseObject objectForKey:@"detail"]];
			[self showData];
		}
		else
		{
			[self showAlert:@"Oops!" message:[_responseObject objectForKey:@"detail"]];
		}
	} ;
	
	void ( ^failure )( NSError* _error ) = ^( NSError* _error )
	{
		[self showAlert:@"Oops!" message:@"An unknown error occured"];
		[ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
	} ;
	
	[[YYYCommunication sharedManager] UnFriend:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"] useridto:[dictInfo objectForKey:@"user_id"] successed:successed failure:failure];
}

-(IBAction)btUnBlockClick:(id)sender
{
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	void ( ^successed )( id _responseObject ) = ^( id _responseObject )
	{
		[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
		if ([[_responseObject objectForKey:@"success"] isEqualToString:@"1"])
		{
			[[YYYCommunication sharedManager].lstBlock removeObject:[_responseObject objectForKey:@"detail"]];
			[self showData];
		}
		else
		{
			[self showAlert:@"Oops!" message:[_responseObject objectForKey:@"detail"]];
		}
	} ;
	
	void ( ^failure )( NSError* _error ) = ^( NSError* _error )
	{
		[self showAlert:@"Oops!" message:@"An unknown error occured"];
		[ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
	} ;
	
	[[YYYCommunication sharedManager] UnBlockFriend:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"] useridto:[dictInfo objectForKey:@"user_id"] successed:successed failure:failure];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
