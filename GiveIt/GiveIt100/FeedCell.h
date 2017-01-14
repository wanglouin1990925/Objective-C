//
//  FeedCell.h
//  GiveIt100
//
//  Created by Wang MeiHua on 1/11/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol FeedCellDelegate < NSObject >

- (void)likeAction:(NSIndexPath*)_indexpath :(BOOL)islike;
- (IBAction)commentAction:(NSIndexPath*)_indexpath;
- (void)deleteaction:(NSDictionary*)_dict;

@end

@interface FeedCell : UITableViewCell<UIActionSheetDelegate,UIAlertViewDelegate>
{
    IBOutlet UIButton *btLike;
    IBOutlet UIButton *btComment;
    IBOutlet UILabel *lblDay;
    IBOutlet UILabel *lblLikes;
    IBOutlet UILabel *lblComments;
    IBOutlet UIImageView *imvThumb;
    
    IBOutlet UIProgressView *prgview;
    
    IBOutlet UIView *viewForPlay;
    
    NSDictionary *dictVideo;
    NSIndexPath *indexpath;
    
    BOOL bPlaying;
    
    NSTimer *playbackTimer;
    
    NSString *userid;
}
@property (nonatomic, assign) id<FeedCellDelegate> delegate;
@property (nonatomic) AVPlayer *player;
@property (nonatomic) AVPlayerLayer *layer;

-(IBAction)btMoreClick:(id)sender;

-(void)initwithData:(NSDictionary*)_dict : (NSIndexPath*)_indexpath : (NSString*)_userid;
-(void)play;
-(BOOL)isPlaying;
-(void)stop;
@end
