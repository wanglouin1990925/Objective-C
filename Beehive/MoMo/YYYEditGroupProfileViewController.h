//
//  YYYEditGroupProfileViewController.h
//  MoMo
//
//  Created by King on 11/20/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYYPlacesViewController.h"
#import "YYYEditGroupAlbumViewController.h"
#import "YYYGroupMemberViewController.h"
#import "SZTextView.h"

@protocol EditGroupProfileViewDelegate <NSObject>

-(void)DidGroupProfilUpdated:(NSMutableDictionary*)dictGroup :(NSMutableArray*)lstUser :(NSMutableArray*)lstPhoto;

@end

@interface YYYEditGroupProfileViewController : UITableViewController<PlacesViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,EditGroupAlbumViewDelegate,GroupMemberViewDelegate>
{
	IBOutlet UITextField	*txtGroupName;
	IBOutlet UILabel		*lblChoosePlace;
	IBOutlet UIButton		*btPhoto;
	IBOutlet SZTextView		*txtAbout;
	
	NSDictionary *dictPlace;
}

-(IBAction)btAlbumClick:(id)sender;
-(IBAction)btDeletGroupClick:(id)sender;
-(IBAction)btMembersClick:(id)sender;
-(IBAction)btChoosePlaceClick:(id)sender;
-(IBAction)btPhotoClick:(id)sender;

@property (nonatomic,retain) NSMutableDictionary	*dictGroup;
@property (nonatomic,retain) NSMutableArray			*lstUser;
@property (nonatomic,retain) NSMutableArray			*lstPhoto;

@property (nonatomic,retain) id<EditGroupProfileViewDelegate> delegate;

@end
