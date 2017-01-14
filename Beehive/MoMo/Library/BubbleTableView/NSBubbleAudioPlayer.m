//
//  NSBubbleAudioPlayer.m
//  InstantMessenger
//
//  Created by Wang MeiHua on 3/1/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "NSBubbleAudioPlayer.h"

@implementation NSBubbleAudioPlayer

@synthesize player;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (id)customView
{
    NSBubbleAudioPlayer *customView = [[[NSBundle mainBundle] loadNibNamed:@"NSBubbleAudioPlayer" owner:nil options:nil] lastObject];
    
    // make sure customView is not nil or the wrong class!
    if ([customView isKindOfClass:[NSBubbleAudioPlayer class]])
        return customView;
    else
        return nil;
}

-(void)initWithUrl:(NSString*)url
{
	audioUrl = url;
	self.player = [[AVPlayer alloc] init];
	AVPlayerItem * currentItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:audioUrl]];
	[self.player replaceCurrentItemWithPlayerItem:currentItem];
	
	prgAudio.progress = 0;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachedEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];
}

-(void)playerItemDidReachedEnd:(NSNotification*)_notification
{
	[btPlay setSelected:NO];
	prgAudio.progress = 0;
	[self.player seekToTime:CMTimeMakeWithSeconds(0 , 1)];
	[self.player pause];
	[timer invalidate];
}

-(IBAction)btPlayClick:(id)sender
{
	if (btPlay.selected)
	{
		[self.player pause];
		[btPlay setSelected:NO];
		[timer invalidate];
	}
	else
	{
		[self.player play];
		[btPlay setSelected:YES];
		timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
	}
}

-(void)timer:(NSTimer*)timer
{
	float total =  CMTimeGetSeconds(self.player.currentItem.asset.duration);
	float current = CMTimeGetSeconds(self.player.currentTime);
	
	prgAudio.progress = current/total;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
