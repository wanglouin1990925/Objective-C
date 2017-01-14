//
//  YYYProfileViewController.m
//  MoMo
//
//  Created by Wang MeiHua on 11/5/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYProfileViewController.h"
#import "YYYCommunication.h"
#import "UIImageView+AFNetworking.h"
#import "YYYEditProfileViewController.h"
#import "UIButton+AFNetworking.h"
#import "MBProgressHUD.h"
#import "YYYSelfGroupProfileViewController.h"
#import "YYYGroupProfileViewController.h"
#import "YYYAppDelegate.h"
#import "MBProgressHUD.h"

@interface YYYProfileViewController ()

@end

@implementation YYYProfileViewController

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
	
    topRefresh = [[ODRefreshControl alloc] initInScrollView:scvContent];
    [topRefresh addTarget:self action:@selector(loadUserProfile) forControlEvents:UIControlEventValueChanged];
    
	// Do any additional setup after loading the view.
}

-(void)loadUserProfile
{
    void ( ^successed )( id _responseObject ) = ^( id _responseObject )
    {
        [topRefresh endRefreshing];
        if ([[_responseObject objectForKey:@"success"] isEqualToString:@"1"])
        {
            [YYYCommunication sharedManager].dictInfo	= [[NSMutableDictionary alloc] initWithDictionary:[_responseObject objectForKey:@"detail"]];
            [YYYCommunication sharedManager].lstPhoto	= [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"photoarray"]];
            [YYYCommunication sharedManager].lstGroup	= [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"grouparray"]];
            [YYYCommunication sharedManager].lstFriend	= [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"friendarray"]];
            [YYYCommunication sharedManager].lstBlock	= [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"blockarray"]];
            
            [self showProfile];
        }
        else
        {
            
        }
    } ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
    {
        [topRefresh endRefreshing];
    } ;
    
    if ([[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_facebookid"] isEqualToString:@""])
    {
        [[YYYCommunication sharedManager] Login:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_phone"]
                                       password:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_password"]
                                       latitude:[NSString stringWithFormat:@"%f",[YYYAppDelegate sharedDelegate].fLat]
                                      longitude:[NSString stringWithFormat:@"%f",[YYYAppDelegate sharedDelegate].fLng]
                                      successed:successed
                                        failure:failure];
    }
    else
    {
        [[YYYCommunication sharedManager] FBSignUp:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_facebookid"]
                                          username:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_username"]
                                              name:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_name"]
                                          birthday:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_birthday"]
                                            gender:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_gender"]
                                          latitude:[NSString stringWithFormat:@"%f",[YYYAppDelegate sharedDelegate].fLat]
                                         longitude:[NSString stringWithFormat:@"%f",[YYYAppDelegate sharedDelegate].fLng]
                                         successed:successed
                                           failure:failure];
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
	
    [self.navigationItem setTitle:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_username"]];
    
    NSString *avatarURL = [[YYYCommunication sharedManager].dictInfo objectForKey:@"user_avatar"];
    NSString *facebookID = [[YYYCommunication sharedManager].dictInfo objectForKey:@"user_facebookid"];
    
    if ([avatarURL isEqualToString:@""] && ![facebookID isEqualToString:@""])
    {
        avatarURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",facebookID];
    }
    else
    {
        avatarURL = [NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_avatar"]];
    }
    
    NSString *coverURL = [[YYYCommunication sharedManager].dictInfo objectForKey:@"user_coverphoto"];
    if ([coverURL isEqualToString:@""])
    {
        coverURL = avatarURL;
    }
    else
    {
        coverURL = [NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_coverphoto"]];
    }
    
	[imvAvatar	setImageWithURL:[NSURL URLWithString:avatarURL]];
	[imvCover	setImageWithURL:[NSURL URLWithString:coverURL]];
	
    [lblName	setText:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_name"]];
	[lblAboutme	setText:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_aboutme"]];
	[lblAge		setText:[self getAge:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_birthday"]]];
	[lblDistance setText:@"0.00km | 1m ago"];
	
	int nPos = 210;
	if ([lblAboutme text].length)
	{
		CGRect labelRect = [[lblAboutme text] boundingRectWithSize:CGSizeMake(300, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [lblAboutme font]} context:nil];
		
		CGRect rt = vwAboutMe.frame;
		rt.size.height = 45 + labelRect.size.height + 10 + 5;
		vwAboutMe.frame = rt;
		nPos = nPos +rt.size.height;
	}
	
	int nPhotoCount = (int)[[YYYCommunication sharedManager].lstPhoto count];
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
			[btPhoto setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[[[YYYCommunication sharedManager].lstPhoto objectAtIndex:i] objectForKey:@"photo"]]]];
			btPhoto.layer.cornerRadius = 10.0f;
			btPhoto.clipsToBounds = YES;
			btPhoto.tag = 1000 + i;
			[btPhoto addTarget:self action:@selector(btSinglePhotoClicked:) forControlEvents:UIControlEventTouchUpInside];
			[vwAlbum addSubview:btPhoto];
		}
	}
	
	int nGroupCount = (int)[[YYYCommunication sharedManager].lstGroup count];
	if (nGroupCount)
	{
		CGRect rt = vwGroup.frame;
		rt.origin.y = nPos;
		rt.size.height = nGroupCount * 44 + 37 + 1;
		vwGroup.frame = rt;
		nPos = nPos +rt.size.height;
		
		for (int i = 0; i < nGroupCount; i++)
		{
			NSDictionary *dictGroup = [[YYYCommunication sharedManager].lstGroup objectAtIndex:i];
			
			UIButton *btPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
			[btPhoto setFrame:CGRectMake(11 , 45 + 44 * i, 30, 30)];
			[btPhoto setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[dictGroup objectForKey:@"avatar"]]]];
			btPhoto.layer.cornerRadius = 5.0f;
			btPhoto.clipsToBounds = YES;
			btPhoto.tag = 200 + i;
			[btPhoto addTarget:self action:@selector(btGroupClick:) forControlEvents:UIControlEventTouchUpInside];
			[vwGroup addSubview:btPhoto];
			
			
			UIButton *btTitle = [UIButton buttonWithType:UIButtonTypeCustom];
			[btTitle  setFrame:CGRectMake(0, 45 + 44 * i, 320, 30)];
			[btTitle setTitle:[dictGroup objectForKey:@"title"] forState:UIControlStateNormal];
			[btTitle.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0]];
			btTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
			btTitle.contentEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
			[btTitle setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
			btTitle.tag = 100 + i;
			[btTitle addTarget:self action:@selector(btGroupClick:) forControlEvents:UIControlEventTouchUpInside];
			[vwGroup addSubview:btTitle];
			
			UIImageView *imvSeparateLine =[[UIImageView alloc] initWithFrame:CGRectMake(0, 37 + i * 44, 320, 1)];
			[imvSeparateLine setBackgroundColor:[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f]];
			[vwGroup addSubview:imvSeparateLine];
		}
	}
	
    //Company
    if ([[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_company"] length])
    {
        NSString *company = [[YYYCommunication sharedManager].dictInfo objectForKey:@"user_company"];
        
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
    if ([[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_university"] length])
    {
        NSString *company = [[YYYCommunication sharedManager].dictInfo objectForKey:@"user_university"];
        
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
    if ([[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_hometown"] length])
    {
        NSString *company = [[YYYCommunication sharedManager].dictInfo objectForKey:@"user_hometown"];
        
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
    if ([[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_hobbies"] length])
    {
        NSString *company = [[YYYCommunication sharedManager].dictInfo objectForKey:@"user_hobbies"];
        
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
    if ([[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_music"] length])
    {
        NSString *company = [[YYYCommunication sharedManager].dictInfo objectForKey:@"user_music"];
        
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
    if ([[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_books"] length])
    {
        NSString *company = [[YYYCommunication sharedManager].dictInfo objectForKey:@"user_books"];
        
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
    if ([[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_movies"] length])
    {
        NSString *company = [[YYYCommunication sharedManager].dictInfo objectForKey:@"user_movies"];
        
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
    if ([[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_looking"] length])
    {
        NSString *company = [[YYYCommunication sharedManager].dictInfo objectForKey:@"user_looking"];
        
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
	[view initWithData:[YYYCommunication sharedManager].lstPhoto];
	[view setCurrentPage:(int)[sender tag] - 1000];
	[[YYYAppDelegate sharedDelegate].window addSubview:view];
}

-(void)DidBackClick:(id)view
{
	[view removeFromSuperview];
}

-(IBAction)btGroupClick:(id)sender
{
	NSString *createrId = [[[YYYCommunication sharedManager].lstGroup objectAtIndex:[sender tag]%100] objectForKey:@"createrid"];
	NSString *groupId	= [[[YYYCommunication sharedManager].lstGroup objectAtIndex:[sender tag]%100] objectForKey:@"id"];
	
	[MBProgressHUD showHUDAddedTo:[YYYAppDelegate sharedDelegate].window animated:YES];
	
	void ( ^successed )( id _responseObject ) = ^( id _responseObject )
	{
		[MBProgressHUD hideAllHUDsForView:[YYYAppDelegate sharedDelegate].window animated:YES];
		
		if ([[_responseObject objectForKey:@"success"] isEqualToString:@"1"])
		{
//			if ([[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"] intValue] == [createrId intValue])
//			{
//				YYYSelfGroupProfileViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYSelfGroupProfileViewController"];
//				
//				viewcontroller.dictInfo		= [[NSMutableDictionary alloc] initWithDictionary:[_responseObject objectForKey:@"detail"]];
//				viewcontroller.lstUsers		= [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"userarray"]];
//				viewcontroller.lstPhotos	= [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"photoarray"]];
//				
//				[self.navigationController pushViewController:viewcontroller animated:YES];
//			}
//			else
//			{
				YYYGroupProfileViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYGroupProfileViewController"];
				
				viewcontroller.dictInfo		= [[NSMutableDictionary alloc] initWithDictionary:[_responseObject objectForKey:@"detail"]];
				viewcontroller.lstUsers		= [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"userarray"]];
				viewcontroller.lstPhotos	= [[NSMutableArray alloc] initWithArray:[_responseObject objectForKey:@"photoarray"]];
				
				[self.navigationController pushViewController:viewcontroller animated:YES];
//			}
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

-(IBAction)btEditAvatarClick:(id)sender
{
	bAvatar = YES;
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Choose a Avatar Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From Camera",@"From Library", nil];
	[sheet showInView:self.view];
}

-(IBAction)btEditCoverClick:(id)sender
{
	bAvatar = NO;
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Choose a Cover Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From Camera",@"From Library", nil];
	[sheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
		//Camera
		UIImagePickerController *picker = [[UIImagePickerController alloc] init];
		picker.delegate = self;
		picker.allowsEditing = YES;
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
		[self presentViewController:picker animated:YES completion:NULL];
	}
	else if (buttonIndex == 1)
	{
		//Library
		UIImagePickerController *picker = [[UIImagePickerController alloc] init];
		picker.delegate = self;
		picker.allowsEditing = YES;
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		[self presentViewController:picker animated:YES completion:NULL];
	}
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	void ( ^successed )( id _responseObject ) = ^( id _responseObject )
	{
		[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
		if ([[_responseObject objectForKey:@"success"] isEqualToString:@"1"])
		{
			[YYYCommunication sharedManager].dictInfo = [[NSMutableDictionary alloc] initWithDictionary:[_responseObject objectForKey:@"detail"]];
			[self showProfile];
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
    
	NSString *type = @"avatar";
	if (!bAvatar)
		type = @"cover";
	
	[[YYYCommunication sharedManager] EditAvatar:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"]
											type:type
										   photo:UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerEditedImage], 0.2f)
									   successed:successed
										 failure:failure];
		
	[picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)showAlert:(NSString*)title message:(NSString*)message
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
}

-(IBAction)btEditClick:(id)sender
{
	YYYEditProfileViewController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYEditProfileViewController"];
	[self.navigationController pushViewController:viewcontroller animated:YES];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
