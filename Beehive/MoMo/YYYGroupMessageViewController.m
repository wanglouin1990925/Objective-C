//
//  YYYMessageViewController.m
//  MoMo
//
//  Created by Wang MeiHua on 11/6/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYGroupMessageViewController.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"
#import "YYYCommunication.h"
#import "YYYAppDelegate.h"
#import "YYYLocationController.h"

#define BUTTON_FONT_SIZE 32
#define EMOJICOL			7
#define EMOJIROW			3
#define BUTTON_WIDTH 45
#define BUTTON_HEIGHT 37

#define PHOTOBOUND		@"!@#!xyz!@#!"
#define MAPBOUND		@"!@!#xyz!@#!"
#define VIDEOBOUND		@"!@!x#yz!@#!"
#define VOICEBOUND		@"!@!xy#z!@#!"
#define STICKERBOUND	@"!@!xyz#!@#!"

@interface YYYGroupMessageViewController ()

@end

@implementation YYYGroupMessageViewController

@synthesize emojis;
@synthesize dictGroup;
@synthesize lstMembers;

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
	
    bubbleData = [[NSMutableArray alloc] init];
    bubbleTable.bubbleDataSource = self;
    
	bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
    bubbleTable.showAvatars = YES;
    [bubbleTable reloadData];
    
	UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture)];
	[bubbleTable addGestureRecognizer:gesture];
	
	//Read Emoji
	NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"EmojisList" ofType:@"plist"];
    emojis = [[NSDictionary dictionaryWithContentsOfFile:plistPath] copy];
	[self makeEmoji:0];
	
    lstMsgId = [[NSMutableArray alloc] init];
    
	//Make Sticker
	[self initSticker];
	
	[self outputSoundSpeaker];
	[self initRecorder];
	
	[self.navigationItem setTitle:[dictGroup objectForKey:@"title"]];
	
	nLastMsgIndex = -1;
	
	[vwBottom setHidden:YES];
	[vwBlock1 setHidden:YES];
	[vwBlock2 setHidden:YES];
	
	[self loadMessageHistory];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:)   name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:)  name:UIKeyboardWillChangeFrameNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadIncoming:)        name:@"INCOMEMESSAGE" object:nil];

	keyboardHeight = 253;

    [self initGrowingTextView];
	[vwBottom setHidden:YES];
    
    btSend.layer.cornerRadius = 20.0f;
    btSend.clipsToBounds = YES;
    btSend.backgroundColor = [UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1.0f];
    btSend.titleLabel.textColor = [UIColor blackColor];
	
	// Do any additional setup after loading the view.
}

-(void)initGrowingTextView
{
    textField = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(40, 7, 205, 36)];
    textField.isScrollable = YES;
    textField.contentInset = UIEdgeInsetsMake(0, 5, 0, 25);
    
    //	textView.minNumberOfLines = 1;
    //	textView.maxNumberOfLines = 6;
    // you can also set the maximum height in points with maxHeight
    textField.maxHeight = 120.0f;
    textField.returnKeyType = UIReturnKeyDefault; //just as an example
    textField.font = [UIFont systemFontOfSize:16.0f];
    textField.delegate = self;
    textField.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textField.backgroundColor = [UIColor whiteColor];
    textField.placeholder = @"Reply...";
    textField.animateHeightChange = NO;
    
    textField.layer.borderColor = [[UIColor grayColor] CGColor];
    textField.layer.borderWidth = 0.5;
    textField.layer.cornerRadius = 20.0f;
    textField.clipsToBounds = YES;
    
    [textInputView addSubview:textField];
    [textInputView sendSubviewToBack:textField];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = textInputView.frame;
    r.size.height -= diff;
    //    r.origin.y += diff;
    textInputView.frame = r;
    
    r = vwBottom.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    vwBottom.frame = r;
}

-(void)outputSoundSpeaker
{
	AVAudioSession* audioSession = [AVAudioSession sharedInstance];
	
	UInt32 doChangeDefaultRoute = 1;
	NSError* error4 = nil;
	
	OSStatus status = AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof (doChangeDefaultRoute), &doChangeDefaultRoute);
	if (status != kAudioSessionNoError) {
		NSLog(@"AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers) failed: %d", (int)status);
	}
	
	// Activate the audio session
	error4 = nil;
	if (![audioSession setActive:YES error:&error4]) {
		NSLog(@"AVAudioSession setActive:YES failed: %@", [error4 localizedDescription]);
	}
}

-(void)initRecorder
{
	NSArray *pathComponents = [NSArray arrayWithObjects:
							   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
							   @"MyAudioMemo.m4a",
							   nil];
	audioURL = [NSURL fileURLWithPathComponents:pathComponents];
	
	// Setup audio session
	AVAudioSession *session = [AVAudioSession sharedInstance];
	[session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
	
	// Define the recorder setting
	NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
	
	[recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
	[recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
	[recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
	
	// Initiate and prepare the recorder
	recorder = [[AVAudioRecorder alloc] initWithURL:audioURL settings:recordSetting error:NULL];
	recorder.delegate = self;
	recorder.meteringEnabled = YES;
	[recorder prepareToRecord];
}

-(void)initSticker
{
	lstSticker = [[NSMutableArray alloc] init];
	
	NSMutableArray *lstStickerCount = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:40],[NSNumber numberWithInt:16],[NSNumber numberWithInt:40],[NSNumber numberWithInt:40],[NSNumber numberWithInt:40], nil];
	
	for (int i = 0; i < 5; i++)
	{
		NSMutableArray *lstSubTemp = [[NSMutableArray alloc] init];
		for (int j = 0; j < [[lstStickerCount objectAtIndex:i] intValue]; j++)
		{
			[lstSubTemp addObject:[NSString stringWithFormat:@"%d_%d",i+1,j+1]];
		}
		
		[lstSticker addObject:lstSubTemp];
	}
	
    [lstSticker removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 3)]];
	
	//Add to View
	for (int i = 0; i < [lstSticker count]; i++)
	{
		UIButton *btStickerType = [UIButton buttonWithType:UIButtonTypeCustom];
		[btStickerType setFrame:CGRectMake(i * 44, 0, 44, 44)];
		[btStickerType setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d_1.png",i+1]] forState:UIControlStateNormal];
		[btStickerType addTarget:self action:@selector(btStickerTypeClick:) forControlEvents:UIControlEventTouchUpInside];
		btStickerType.tag = 100 + i;
		btStickerType.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
		[scvStickerTop addSubview:btStickerType];
		
		UIImageView *imvSeparate = [[UIImageView alloc] initWithFrame:CGRectMake((i + 1)*44, 0, 1, 44)];
		[imvSeparate setBackgroundColor:[UIColor lightGrayColor]];
		[scvStickerTop addSubview:imvSeparate];
	}
	
	nStickerType = 0;
	[scvStickerTop setContentSize:CGSizeMake(44 * [lstSticker count], scvStickerTop.frame.size.height)];
	
	[self addStiker:0];
}

-(void)addStiker:(int)index
{
	for (int i = 0; i < [lstSticker count]; i++)
	{
		UIButton *bt = (UIButton*)[scvStickerTop viewWithTag:100 + i];
		[bt setBackgroundColor:[UIColor clearColor]];
	}
	
	UIButton *bt = (UIButton*)[scvStickerTop viewWithTag:100 + index];
	[bt setBackgroundColor:[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1.0]];
	
	for (UIView *vw in scvSticker.subviews)
	{
		if ([vw isKindOfClass:[UIButton class]])
		{
			[vw removeFromSuperview];
		}
	}
	
	[scvSticker setContentOffset:CGPointMake(0, 0)];
	[pageCtlSticker setCurrentPage:0];
	
	
	for (int j = 0; j < [[lstSticker objectAtIndex:index] count]; j++)
	{
		UIButton *btStickerItem = [UIButton buttonWithType:UIButtonTypeCustom];
		[btStickerItem setFrame:CGRectMake(10 + (j/2) * 80, 10 + (j%2)*70, 60, 60)];
		[btStickerItem setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d_%d.png",index+1,j+1]] forState:UIControlStateNormal];
		[btStickerItem addTarget:self action:@selector(btStickerItemClick:) forControlEvents:UIControlEventTouchUpInside];
		btStickerItem.tag = 1000 + j;
		[scvSticker addSubview:btStickerItem];
	}
	
	int nPage = 0;
	if ([[lstSticker objectAtIndex:index] count]%8 > 0)
		nPage = (int)[[lstSticker objectAtIndex:index] count]/8 + 1;
	else
		nPage = (int)[[lstSticker objectAtIndex:index] count]/8;
	
	[pageCtlSticker setNumberOfPages:nPage];
	[scvSticker setContentSize:CGSizeMake(320 * nPage, scvSticker.frame.size.height)];
}

-(IBAction)btStickerTypeClick:(id)sender
{
	nStickerType = (int)[sender tag] - 100;
	[self addStiker:nStickerType];
}

-(IBAction)btStickerItemClick:(id)sender
{
	[self sendMessage:nil Photo:nil Video:nil Voice:nil Location:nil Sticker:[NSString stringWithFormat:@"%@%d_%d",STICKERBOUND,nStickerType + 1,(int)[sender tag] - 1000 + 1]];
}

-(IBAction)btMoreClick:(id)sender
{
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Friend",@"Block", nil];
	[sheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	
}

- (void)keyboardWillShown:(NSNotification*)aNotification
{
    keyboardHeight = [[aNotification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [self moveUpView];
}

- (void)keyboardWillChange:(NSNotification*)aNotification
{
    int newHeight = [[aNotification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    if (newHeight != keyboardHeight)
    {
        keyboardHeight = newHeight;
        [self moveUpView];
    }
}

-(void)loadIncoming:(NSNotification*)notif
{
	int nMsgCount = 0;
	
	for (NSDictionary *dict in  [notif.userInfo objectForKey:@"gincome"])
	{
		if([[dict objectForKey:@"groupid"] intValue] != [[dictGroup objectForKey:@"id"] intValue])
			continue;
		
        if ([lstMsgId containsObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]]])
            continue;
        else
        {
            [lstMsgId addObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]]];
        }
        
		if (nLastMsgIndex < [[dict objectForKey:@"id"] intValue])
		{
			nLastMsgIndex = [[dict objectForKey:@"id"] intValue];
			
			int nDiff = -[[dict objectForKey:@"diff"] intValue];
			NSString *message = [dict objectForKey:@"message"];
			
			NSString *strAvatar = @"";
			for (NSDictionary *dictMember in lstMembers)
			{
				if ([[dictMember objectForKey:@"user_id"] intValue] == [[dict objectForKey:@"useridfrom"] intValue])
				{
					strAvatar = [NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[dictMember objectForKey:@"user_avatar"]];
					break;
				}
			}
			
			if ([message rangeOfString:PHOTOBOUND].location == 0)
			{
				NSBubbleData *sayBubble = [NSBubbleData dataWithImage:[NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[message substringFromIndex:PHOTOBOUND.length]] date:[NSDate dateWithTimeIntervalSinceNow:nDiff] type:BubbleTypeSomeoneElse];
				sayBubble.avatar_url = [NSURL URLWithString:strAvatar];
				[bubbleData addObject:sayBubble];
			}
			else if ([message rangeOfString:VIDEOBOUND].location == 0)
			{
				NSBubbleData *sayBubble = [NSBubbleData dataWithVideo:[NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[message substringFromIndex:VIDEOBOUND.length]] date:[NSDate dateWithTimeIntervalSinceNow:nDiff] type:BubbleTypeSomeoneElse];
				sayBubble.avatar_url = [NSURL URLWithString:strAvatar];
				[bubbleData addObject:sayBubble];
			}
			else if ([message rangeOfString:VOICEBOUND].location == 0)
			{
				NSBubbleData *sayBubble = [NSBubbleData dataWithAudio:[NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[message substringFromIndex:VOICEBOUND.length]] date:[NSDate dateWithTimeIntervalSinceNow:nDiff] type:BubbleTypeSomeoneElse];
				sayBubble.avatar_url = [NSURL URLWithString:strAvatar];
				[bubbleData addObject:sayBubble];
			}
			else if ([message rangeOfString:MAPBOUND].location == 0)
			{
				NSBubbleData *sayBubble = [NSBubbleData dataWithMap:[message substringFromIndex:MAPBOUND.length] date:[NSDate dateWithTimeIntervalSinceNow:nDiff] type:BubbleTypeSomeoneElse];
				sayBubble.avatar_url = [NSURL URLWithString:strAvatar];
				sayBubble.delegate = self;
				[bubbleData addObject:sayBubble];
			}
			else if ([message rangeOfString:STICKERBOUND].location == 0)
			{
				NSBubbleData *sayBubble = [NSBubbleData dataWithSticker:[message substringFromIndex:STICKERBOUND.length] date:[NSDate dateWithTimeIntervalSinceNow:nDiff] type:BubbleTypeSomeoneElse];
				sayBubble.avatar_url = [NSURL URLWithString:strAvatar];
				[bubbleData addObject:sayBubble];
			}
			else
			{
				NSBubbleData *sayBubble = [NSBubbleData dataWithText:message date:[NSDate dateWithTimeIntervalSinceNow:nDiff] type:BubbleTypeSomeoneElse];
				sayBubble.avatar_url = [NSURL URLWithString:strAvatar];
				[bubbleData addObject:sayBubble];
			}
			
			nMsgCount++;
		}
	}
	
	if (nMsgCount)
	{
		[bubbleTable reloadData];
		[self scrollToBottom:YES];
		
		[[YYYCommunication sharedManager] ReadGMessage:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"] groupid:[dictGroup objectForKey:@"id"] successed:nil failure:nil];
	}
}

-(void)loadMessageHistory
{
	void ( ^successed )( id _responseObject ) = ^( id _responseObject )
	{
		if ([[_responseObject objectForKey:@"success"] isEqualToString:@"1"])
		{
			NSMutableArray *lstGroupID = [[NSMutableArray alloc] init];
			for (NSDictionary *dict in [YYYCommunication sharedManager].lstGroup)
			{
				[lstGroupID addObject:[dict objectForKey:@"id"]];
			}
			
			if ([lstGroupID containsObject:[dictGroup objectForKey:@"id"]])
			{
				[vwBottom setHidden:NO];
			}
			
			for (NSDictionary *dict in [_responseObject objectForKey:@"detail"])
			{
				//Receive
				int nDiff = -[[dict objectForKey:@"diff"] intValue];
				NSString *message = [dict objectForKey:@"message"];
				
				int nBubbleType = 1;
				NSString *strAvatar = @"";
				
				if ([[dict objectForKey:@"useridfrom"] intValue] == [[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"] intValue])
				{
					nBubbleType = 0;
					strAvatar = [NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_avatar"]];
				}
				else
				{
					for (NSDictionary *dictMember in lstMembers)
					{
						if ([[dictMember objectForKey:@"user_id"] intValue] == [[dict objectForKey:@"useridfrom"] intValue])
						{
							strAvatar = [NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[dictMember objectForKey:@"user_avatar"]];
							break;
						}
					}
				}
                
                if ([bubbleData containsObject:dict])
                    continue;
                
                if ([lstMsgId containsObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]]])
                    continue;
                else
                {
                    [lstMsgId addObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]]];
                }
				
				if ([message rangeOfString:PHOTOBOUND].location == 0)
				{
					NSBubbleData *sayBubble = [NSBubbleData dataWithImage:[NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[message substringFromIndex:PHOTOBOUND.length]] date:[NSDate dateWithTimeIntervalSinceNow:nDiff] type:nBubbleType];
					sayBubble.avatar_url = [NSURL URLWithString:strAvatar];
					[bubbleData addObject:sayBubble];
				}
				else if ([message rangeOfString:VIDEOBOUND].location == 0)
				{
					NSBubbleData *sayBubble = [NSBubbleData dataWithVideo:[NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[message substringFromIndex:VIDEOBOUND.length]] date:[NSDate dateWithTimeIntervalSinceNow:nDiff] type:nBubbleType];
					sayBubble.avatar_url = [NSURL URLWithString:strAvatar];
					[bubbleData addObject:sayBubble];
				}
				else if ([message rangeOfString:VOICEBOUND].location == 0)
				{
					NSBubbleData *sayBubble = [NSBubbleData dataWithAudio:[NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[message substringFromIndex:VOICEBOUND.length]] date:[NSDate dateWithTimeIntervalSinceNow:nDiff] type:nBubbleType];
					sayBubble.avatar_url = [NSURL URLWithString:strAvatar];
					[bubbleData addObject:sayBubble];
				}
				else if ([message rangeOfString:MAPBOUND].location == 0)
				{
					NSBubbleData *sayBubble = [NSBubbleData dataWithMap:[message substringFromIndex:MAPBOUND.length] date:[NSDate dateWithTimeIntervalSinceNow:nDiff] type:nBubbleType];
					sayBubble.avatar_url = [NSURL URLWithString:strAvatar];
					sayBubble.delegate = self;
					[bubbleData addObject:sayBubble];
				}
				else if ([message rangeOfString:STICKERBOUND].location == 0)
				{
					NSBubbleData *sayBubble = [NSBubbleData dataWithSticker:[message substringFromIndex:STICKERBOUND.length] date:[NSDate dateWithTimeIntervalSinceNow:nDiff] type:nBubbleType];
					sayBubble.avatar_url = [NSURL URLWithString:strAvatar];
					[bubbleData addObject:sayBubble];
				}
				else{
					NSBubbleData *sayBubble = [NSBubbleData dataWithText:message date:[NSDate dateWithTimeIntervalSinceNow:nDiff] type:nBubbleType];
					sayBubble.avatar_url = [NSURL URLWithString:strAvatar];
					[bubbleData addObject:sayBubble];
				}
				
				if (nLastMsgIndex < [[dict objectForKey:@"id"] intValue])
					nLastMsgIndex = [[dict objectForKey:@"id"] intValue];
			}
			
			[bubbleTable reloadData];
			[self scrollToBottom:NO];
		}
		else
		{

		}
	} ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error )
	{

    } ;
    
	[[YYYCommunication sharedManager] LoadGMessageHistory:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"]
												  groupid:[dictGroup objectForKey:@"id"]
												successed:successed
												  failure:failure];
}

//-------Emoji
-(void)makeEmoji:(int)nIndex
{
	[btEmoji1 setSelected:NO];
	[btEmoji2 setSelected:NO];
	[btEmoji3 setSelected:NO];
	[btEmoji4 setSelected:NO];
	
	if (nIndex == 0) {
		[btEmoji1 setSelected:YES];
	}else if (nIndex == 1){
		[btEmoji2 setSelected:YES];
	}else if (nIndex == 2){
		[btEmoji3 setSelected:YES];
	}else if (nIndex == 3){
		[btEmoji4 setSelected:YES];
	}
	
	for (UIView *view in scvEmoticon.subviews) {
		if ([view isKindOfClass:[UIButton class]]) {
			[view removeFromSuperview];
		}
	}
	
	NSArray *lstArray = [NSArray arrayWithObjects:@"People",@"Nature",@"Places",@"Objects", nil];
	NSArray *lstEmojis = [emojis objectForKey:[lstArray objectAtIndex:nIndex]];
	
	
	for (int i = 0; i < [lstEmojis count]; i++) {
		UIButton *btEmoji = [UIButton buttonWithType:UIButtonTypeCustom];
		[btEmoji setTitle:[lstEmojis objectAtIndex:i] forState:UIControlStateNormal];
		btEmoji.titleLabel.font = [UIFont fontWithName:@"Apple color emoji" size:BUTTON_FONT_SIZE];
		btEmoji.frame = CGRectIntegral(CGRectMake([self XMarginForButtonInColumn:i/3],
												  [self YMarginForButtonInRow:i%3] + 10,
												  BUTTON_WIDTH,
												  BUTTON_HEIGHT));
		[btEmoji addTarget:self action:@selector(btEmojiItemClick:) forControlEvents:UIControlEventTouchUpInside];
		[scvEmoticon addSubview:btEmoji];
	}
	
	int nPageCount = (int)[lstEmojis count] / (EMOJIROW*EMOJICOL);
	
	if ([lstEmojis count] % (EMOJIROW*EMOJICOL) != 0) {
		nPageCount = nPageCount + 1;
	}
	
	scvEmoticon.delegate = self;
	[pageCtl setNumberOfPages:nPageCount];
	[scvEmoticon setContentSize:CGSizeMake(320 * nPageCount, scvEmoticon.frame.size.height)];
}

-(IBAction)btEmojiItemClick:(id)sender
{
	[textField setText:[NSString stringWithFormat:@"%@%@",textField.text,[(UIButton*)sender currentTitle]]];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (scrollView == scvEmoticon)
	{
		[pageCtl setCurrentPage:scrollView.contentOffset.x / 320];
	}
	else if (scrollView == scvSticker)
	{
		[pageCtlSticker setCurrentPage:scrollView.contentOffset.x / 300];
	}
}

- (CGFloat)XMarginForButtonInColumn:(NSInteger)column {
	CGFloat padding = ((CGRectGetWidth(scvEmoticon.bounds) - EMOJICOL * BUTTON_WIDTH) / EMOJICOL);
	return (padding / 2 + column * (padding + BUTTON_WIDTH));
}

- (CGFloat)YMarginForButtonInRow:(NSInteger)rowNumber {
	CGFloat padding = ((CGRectGetHeight(scvEmoticon.bounds) - 30 - EMOJIROW * BUTTON_WIDTH) / EMOJIROW);
	return (padding / 2 + rowNumber * (padding + BUTTON_WIDTH));
}

-(IBAction)btPeopleClick:(id)sender
{
	[self makeEmoji:0];
}

-(IBAction)btNatureClick:(id)sender
{
	[self makeEmoji:1];
}

-(IBAction)btPlaceClick:(id)sender
{
	[self makeEmoji:2];
}

-(IBAction)btObjectClick:(id)sender
{
	[self makeEmoji:3];
}

-(IBAction)btPhotoClick:(id)sender
{
	isVideo = NO;
	
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.allowsEditing = YES;
	picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	[self presentViewController:picker animated:YES completion:NULL];
}

-(IBAction)btCameraClick:(id)sender
{
	isVideo = NO;
	
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.allowsEditing = YES;
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	[self presentViewController:picker animated:YES completion:NULL];
}

-(IBAction)btVideoClick:(id)sender
{
	isVideo = YES;
	
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.allowsEditing = YES;
	picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
	[self presentViewController:picker animated:YES completion:NULL];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
	
	if (isVideo)
	{
		NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
		NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
		[self sendMessage:nil Photo:nil Video:videoData Voice:nil Location:nil Sticker:nil];
	}
	else
	{
		[self sendMessage:nil Photo:UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerEditedImage],0.2f) Video:nil Voice:nil Location:nil Sticker:nil];
	}
	
	[picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker dismissViewControllerAnimated:YES completion:NULL];
}

-(IBAction)btVoiceClick:(id)sender
{
	[vwBottom bringSubviewToFront:vwVoice];
}

-(IBAction)btRecordSend:(id)sender
{
	[recorder stop];
	
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	[audioSession setActive:NO error:nil];
	
	[timer invalidate];
	[lblRecord setText:@"00:00"];
	
	if (nVoiceSec > 2)
	{
		[self sendMessage:nil Photo:nil Video:nil Voice:[NSData dataWithContentsOfURL:audioURL] Location:nil Sticker:nil];
		nVoiceSec = 0;
	}
	else
	{
		nVoiceSec = 0;
	}
}

-(IBAction)btRecordCancel:(id)sender
{
	[recorder stop];
	
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	[audioSession setActive:NO error:nil];
	
	[timer invalidate];
	[lblRecord setText:@"00:00"];
	nVoiceSec = 0;
}

-(IBAction)btRecordStart:(id)sender
{
	AVAudioSession *session = [AVAudioSession sharedInstance];
	[session setActive:YES error:nil];
	
	// Start recording
	[recorder record];
	
	timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer) userInfo:nil repeats:YES];
	[lblRecord setText:@"00:00"];
}

-(void)timer
{
	nVoiceSec++;
	[lblRecord setText:[NSString stringWithFormat:@"%.2d:%.2d",nVoiceSec/60,nVoiceSec%60]];
}

-(IBAction)btLocationClick:(id)sender
{
	[self sendMessage:nil Photo:nil Video:nil Voice:nil Location:[NSString stringWithFormat:@"%@%f,%f",MAPBOUND,[YYYAppDelegate sharedDelegate].fLat,[YYYAppDelegate sharedDelegate].fLng] Sticker:nil];
}

-(IBAction)btStickerClick:(id)sender
{
//	[vwBottom bringSubviewToFront:vwSticker];
}

//---------------
-(void)handleTapGesture
{
	[self.view endEditing:YES];
	[self moveDownView];
}

#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [bubbleData objectAtIndex:row];
}

#pragma mark - Keyboard events

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = textInputView.frame;
        frame.origin.y -= kbSize.height;
        textInputView.frame = frame;
        
        frame = bubbleTable.frame;
        frame.size.height -= kbSize.height;
        bubbleTable.frame = frame;
		
    } completion:^(BOOL finished) {
		[self scrollToBottom:NO];
	}];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = textInputView.frame;
        frame.origin.y += kbSize.height;
        textInputView.frame = frame;
        
        frame = bubbleTable.frame;
        frame.size.height += kbSize.height;
        bubbleTable.frame = frame;
    }];
}

-(IBAction)btEmoticonClick:(id)sender
{
	[self.view endEditing:YES];
	[self moveUpView];
	
	[vwBottom bringSubviewToFront:vwEmoticon];
}

-(IBAction)btOtherClick:(id)sender
{
	[self.view endEditing:YES];
	[self moveUpView];
	
	[vwBottom bringSubviewToFront:vwMore];
}

-(void)mapTouched:(float)latitude :(float)longitude
{
	YYYLocationController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYLocationController"];
	viewcontroller.fLat = latitude;
	viewcontroller.fLng = longitude;
	[self.navigationController pushViewController:viewcontroller animated:YES];
}

#pragma mark - Actions

- (IBAction)sayPressed:(id)sender
{
	if (textField.text.length)
	{
		[self sendMessage:textField.text Photo:nil Video:nil Voice:nil Location:nil Sticker:nil];
	}
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
//	[self moveUpView];
}

-(BOOL)textFieldShouldReturn:(UITextField *)_textField
{
//	[_textField resignFirstResponder];
	return YES;
}

-(void)moveUpView
{
    [bubbleTable setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - textInputView.frame.size.height - keyboardHeight)];
    [vwBottom setFrame:CGRectMake(0, self.view.frame.size.height - textInputView.frame.size.height - keyboardHeight, 320, vwBottom.frame.size.height)];
    [self scrollToBottom:NO];
}

-(void)moveDownView
{
    [vwBottom setFrame:CGRectMake(0, self.view.frame.size.height - textInputView.frame.size.height , 320, vwBottom.frame.size.height)];
    [bubbleTable setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - textInputView.frame.size.height)];
}

-(void)scrollToBottom : (BOOL)_animated
{
	CGFloat yoffset = 0;
	if (bubbleTable.contentSize.height > bubbleTable.bounds.size.height) {
		yoffset = bubbleTable.contentSize.height - bubbleTable.bounds.size.height + 10;
	}
	
	[bubbleTable setContentOffset:CGPointMake(0, yoffset) animated:_animated];
}

-(IBAction)btBackClick:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sendMessage :(NSString*)text Photo:(NSData*)photo Video:(NSData*)video Voice:(NSData*)voice Location:(NSString*)location Sticker:(NSString*)sticker
{
	void ( ^successed )( id _responseObject ) = ^( id _responseObject )
	{
		[btSend setUserInteractionEnabled:YES];
		if ([[_responseObject objectForKey:@"success"] isEqualToString:@"1"])
		{
			if (nLastMsgIndex < [[[_responseObject objectForKey:@"detail"] objectForKey:@"id"] intValue])
				nLastMsgIndex = [[[_responseObject objectForKey:@"detail"] objectForKey:@"id"] intValue];
			
			NSString* message = [[_responseObject objectForKey:@"detail"] objectForKey:@"message"];
			
			if ([message rangeOfString:PHOTOBOUND].location == 0)
			{
				NSBubbleData *sayBubble = [NSBubbleData dataWithImage:[NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[message substringFromIndex:PHOTOBOUND.length]] date:[NSDate dateWithTimeIntervalSinceNow:-[[[_responseObject objectForKey:@"detail"] objectForKey:@"diff"] intValue]] type:BubbleTypeMine];
				sayBubble.avatar_url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_avatar"]]];
				[bubbleData addObject:sayBubble];
			}
			else if ([message rangeOfString:VIDEOBOUND].location == 0)
			{
				NSBubbleData *sayBubble = [NSBubbleData dataWithVideo:[NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[message substringFromIndex:VIDEOBOUND.length]] date:[NSDate dateWithTimeIntervalSinceNow:-[[[_responseObject objectForKey:@"detail"] objectForKey:@"diff"] intValue]] type:BubbleTypeMine];
				sayBubble.avatar_url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_avatar"]]];
				[bubbleData addObject:sayBubble];
			}
			else if ([message rangeOfString:VOICEBOUND].location == 0)
			{
				NSBubbleData *sayBubble = [NSBubbleData dataWithAudio:[NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[message substringFromIndex:VOICEBOUND.length]] date:[NSDate dateWithTimeIntervalSinceNow:-[[[_responseObject objectForKey:@"detail"] objectForKey:@"diff"] intValue]] type:BubbleTypeMine];
				sayBubble.avatar_url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_avatar"]]];
				[bubbleData addObject:sayBubble];
			}
			else if ([message rangeOfString:MAPBOUND].location == 0)
			{
				NSBubbleData *sayBubble = [NSBubbleData dataWithMap:[message substringFromIndex:MAPBOUND.length] date:[NSDate dateWithTimeIntervalSinceNow:-[[[_responseObject objectForKey:@"detail"] objectForKey:@"diff"] intValue]] type:BubbleTypeMine];
				sayBubble.delegate = self;
				sayBubble.avatar_url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_avatar"]]];
				[bubbleData addObject:sayBubble];
			}
			else if ([message rangeOfString:STICKERBOUND].location == 0)
			{
				NSBubbleData *sayBubble = [NSBubbleData dataWithSticker:[message substringFromIndex:STICKERBOUND.length] date:[NSDate dateWithTimeIntervalSinceNow:-[[[_responseObject objectForKey:@"detail"] objectForKey:@"diff"] intValue]] type:BubbleTypeMine];
				sayBubble.avatar_url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_avatar"]]];
				[bubbleData addObject:sayBubble];
			}
			else
			{
				[textField setText:@""];
				
				NSBubbleData *sayBubble = [NSBubbleData dataWithText:message date:[NSDate dateWithTimeIntervalSinceNow:-[[[_responseObject objectForKey:@"detail"] objectForKey:@"diff"] intValue]] type:BubbleTypeMine];
				sayBubble.avatar_url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",WEBAPI_URL,[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_avatar"]]];
				
				[bubbleData addObject:sayBubble];
			}
			
			[bubbleTable reloadData];
			[self scrollToBottom:YES];
		}
		else if ([[_responseObject objectForKey:@"success"] isEqualToString:@"2"])
		{
			[vwBottom setHidden:YES];
			[vwBlock1 setHidden:YES];
			[vwBlock2 setHidden:NO];
			
			[self moveDownView];
		}
		else
		{
			
		}
	};
	
	void ( ^failure )( NSError* _error ) = ^( NSError* _error )
	{
		[btSend setUserInteractionEnabled:YES];
	} ;
	
	NSString *groupusers = @"";
	for (NSDictionary *dict in lstMembers)
	{
		groupusers = [NSString stringWithFormat:@"%@,%@",groupusers,[dict objectForKey:@"user_id"]];
	}
	groupusers = [groupusers substringFromIndex:1];
	
	if (text)
	{
		[btSend setUserInteractionEnabled:NO];
		[[YYYCommunication sharedManager] SendGMessage:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"]
											   groupid:[dictGroup objectForKey:@"id"]
											groupusers:groupusers
											   message:text
											 successed:successed
											   failure:failure];
	}
	else if (location)
	{
		[[YYYCommunication sharedManager] SendGMessage:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"]
											   groupid:[dictGroup objectForKey:@"id"]
											groupusers:groupusers
											   message:location
											 successed:successed
											   failure:failure];
	}
	else if (sticker)
	{
		[[YYYCommunication sharedManager] SendGMessage:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"]
											  groupid:[dictGroup objectForKey:@"id"]
										   groupusers:groupusers
											  message:sticker
											successed:successed
											  failure:failure];
	}
	else if (photo)
	{
		[[YYYCommunication sharedManager] SendGFile:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"]
											groupid:[dictGroup objectForKey:@"id"]
										 groupusers:groupusers
											   type:@"photo"
											   file:photo
										  successed:successed
											failure:failure];
	}
	else if (video)
	{
		[[YYYCommunication sharedManager] SendGFile:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"]
											groupid:[dictGroup objectForKey:@"id"]
										 groupusers:groupusers
											   type:@"video"
											   file:video
										  successed:successed
											failure:failure];
	}
	else if (voice)
	{
		[[YYYCommunication sharedManager] SendGFile:[[YYYCommunication sharedManager].dictInfo objectForKey:@"user_id"]
											groupid:[dictGroup objectForKey:@"id"]
										 groupusers:groupusers
											   type:@"voice"
											   file:voice
										  successed:successed
											failure:failure];
	}
}

@end
