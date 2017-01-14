//
//  NSBubbleVideoPlayer.h
//  InstantMessenger
//
//  Created by Wang MeiHua on 3/1/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface NSBubbleVideoPlayer : UIView
{
	NSString *videoUrl;
	IBOutlet UIButton *btPlay;
	IBOutlet UIView *vwPlay;
	IBOutlet UIProgressView *prgVideo;
	IBOutlet UIButton *btStop;
	NSTimer *timer;
}
+ (id)customView;
-(void)initWithUrl:(NSString*)url;

-(IBAction)btPlayClick:(id)sender;
-(IBAction)btStopClick:(id)sender;

@property (nonatomic) AVPlayer *player;
@property (nonatomic) AVPlayerLayer *layer;
@end
