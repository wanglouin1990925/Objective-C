//
//  FeedCell.m
//  GiveIt100
//
//  Created by Wang MeiHua on 1/11/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "FeedCell.h"
#import "UIImageView+AFNetworking.h"
#import "YYYCommunication.h"
#import "MBProgressHUD.h"

@implementation FeedCell

@synthesize delegate;
@synthesize player;
@synthesize layer;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)initwithData:(NSDictionary*)_dict : (NSIndexPath*)_indexpath : (NSString*)_userid
{
    dictVideo = _dict;
    indexpath = _indexpath;
    
    [btLike addTarget:self action:@selector(btLikeClick:) forControlEvents:UIControlEventTouchUpInside];
    [btComment addTarget:self action:@selector(btCommentClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [btLike setSelected:[[_dict objectForKey:@"islike"] boolValue]];
    
    [imvThumb setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",WEBAPI_URL,[[_dict objectForKey:@"videourl"] stringByReplacingOccurrencesOfString:@".mp4" withString:@".jpg"]] stringByReplacingOccurrencesOfString:@"/video/video" withString:@"/thumb/thumb"]]];
    
    imvThumb.layer.borderColor = [[UIColor grayColor] CGColor];
    imvThumb.layer.borderWidth = 1.0f;
    [viewForPlay.layer addSublayer: imvThumb.layer];
    
    [lblDay setText:[NSString stringWithFormat:@"Day %@",[_dict objectForKey:@"daynumber"]]];
    [lblLikes setText:[NSString stringWithFormat:@"%@",[_dict objectForKey:@"nums_like"]]];
    [lblComments setText:[NSString stringWithFormat:@"%@",[_dict objectForKey:@"nums_comment"]]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachedEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];

    bPlaying    = FALSE;
    userid      = _userid;
}

-(IBAction)btLikeClick:(id)sender
{
    void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
        
        // Parse ;
        if( [ [ _responseObject objectForKey : @"success" ] isEqualToString : @"1" ] )
        {
            [btLike setSelected:![[dictVideo objectForKey:@"islike"] boolValue]];
            [self.delegate likeAction:indexpath :![[dictVideo objectForKey:@"islike"] boolValue]];
        }
    } ;
    
    [[YYYCommunication sharedManager] like:[[YYYCommunication sharedManager].me objectForKey:@"index"] postid:[dictVideo objectForKey:@"index"] action:[dictVideo objectForKey:@"islike"] successed:successed failure:nil];
    
}

-(IBAction)btCommentClick:(id)sender
{
    [self.delegate commentAction:indexpath];
}

-(IBAction)btMoreClick:(id)sender
{
    NSLog(@"%@",dictVideo);
    
    if ([userid isEqualToString:[[YYYCommunication sharedManager].me objectForKey:@"index"]]) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Remove Post" otherButtonTitles:nil];
        sheet.tag = 100;
        [sheet showInView:self];
    }else{
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Report Inappropriate" otherButtonTitles:nil];
        sheet.tag = 101;
        [sheet showInView:self];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if (actionSheet.tag == 100) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Confirm Delete" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No ", nil];
            [alert show];
        }else{
            [[YYYCommunication sharedManager] report:[NSString stringWithFormat:@"Inapproriate Report: \n %@",dictVideo] successed:nil failure:nil];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [MBProgressHUD showHUDAddedTo:self animated:YES];
        
        void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
            [ MBProgressHUD hideHUDForView : self animated : YES ] ;
            
            // Parse ;
            if( [ [ _responseObject objectForKey : @"success" ] isEqualToString : @"1" ] )
            {
                [self.delegate deleteaction:dictVideo];
            }
            else
            {
                [ self  showAlert: [_responseObject objectForKey:@"detail"] ] ;
                return ;
            }
        } ;
        
        void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
            // Hide ;
            [ MBProgressHUD hideHUDForView : self animated : YES ] ;
            
            // Error ;
            [ self  showAlert: @"Internet Connection Error!" ] ;
        } ;
        
        [[YYYCommunication sharedManager] deletepost:[dictVideo objectForKey:@"index"] successed:successed failure:failure];
    }
}

-(void)showAlert:(NSString*)_message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:_message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

-(void)playerItemDidReachedEnd:(NSNotification*)_notification
{
    AVPlayerItem *p = [_notification object];
    [p seekToTime:kCMTimeZero];
}

-(void)play
{
    if (self.player)
    {
        [layer removeFromSuperlayer];
        layer = nil;
    }
    
    self.player = [AVPlayer playerWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WEBAPI_URL,[dictVideo objectForKey:@"videourl"]]]];
    
    layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    layer.frame = CGRectMake(0, 0, 320, 320);
    [viewForPlay.layer addSublayer: layer];
    
    [self.player play];
    
    bPlaying = TRUE;
    
    playbackTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
}

-(void)timer:(NSTimer*)timer
{
   float total =  CMTimeGetSeconds(self.player.currentItem.asset.duration);
   float current = CMTimeGetSeconds(self.player.currentTime);

   prgview.progress = current/total;
}

-(BOOL)isPlaying
{
    return bPlaying;
}

-(void)stop
{
    [self.player pause];
    
    bPlaying = FALSE;
    
    [playbackTimer invalidate];
    playbackTimer = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
