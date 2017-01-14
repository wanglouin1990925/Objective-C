//
//  NSBubbleAudioPlayer.h
//  InstantMessenger
//
//  Created by Wang MeiHua on 3/1/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface NSBubbleAudioPlayer : UIView
{
	NSString *audioUrl;
	IBOutlet UIButton *btPlay;
	IBOutlet UIProgressView *prgAudio;
	
	NSTimer *timer;
}
+ (id)customView;
-(void)initWithUrl:(NSString*)url;

-(IBAction)btPlayClick:(id)sender;

@property (nonatomic,retain) AVPlayer *player;
@end
