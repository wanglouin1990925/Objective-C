//
//  YYYMessageViewController.h
//  MoMo
//
//  Created by Wang MeiHua on 11/6/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"
#import <AVFoundation/AVFoundation.h>
#import <MapKit/MapKit.h>
#import "HPGrowingTextView.h"

@interface YYYMessageViewController : UIViewController<UIBubbleTableViewDataSource,NSBubbleDataDelegate,UITextFieldDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVAudioRecorderDelegate,UIActionSheetDelegate,HPGrowingTextViewDelegate>
{
	IBOutlet UIBubbleTableView *bubbleTable;
    IBOutlet UIView			*textInputView;
//    IBOutlet UITextField	*textField;
	IBOutlet UIButton		*btSend;
    
    HPGrowingTextView		*textField;
	
	IBOutlet UIView			*vwBottom;
	IBOutlet UIView			*vwMore;
    NSMutableArray			*bubbleData;
	
	//Emoji
	IBOutlet UIView			*vwEmoticon;
	IBOutlet UIScrollView	*scvEmoticon;
	IBOutlet UIPageControl	*pageCtl;
	
	//Sticker
	IBOutlet UIView			*vwSticker;
	IBOutlet UIScrollView	*scvStickerTop;
	IBOutlet UIScrollView	*scvSticker;
	IBOutlet UIPageControl	*pageCtlSticker;
	NSMutableArray			*lstSticker;
	int						nStickerType;
	
	//Voice
	IBOutlet UIView			*vwVoice;
	
	IBOutlet UIButton *btEmoji1;
	IBOutlet UIButton *btEmoji2;
	IBOutlet UIButton *btEmoji3;
	IBOutlet UIButton *btEmoji4;
	
	int nLastMsgIndex;
	int keyboardHeight;
	
    NSMutableArray          *lstMsgId;
    
	BOOL isVideo;
	
	NSTimer *timer;
	int nVoiceSec;
	AVAudioRecorder *recorder;
	NSURL *audioURL;
	
	IBOutlet UILabel *lblRecord;
	IBOutlet UIView	*vwBlock1;
	IBOutlet UIView	*vwBlock2;
}

-(IBAction)btEmoticonClick:(id)sender;
-(IBAction)btOtherClick:(id)sender;
-(IBAction)btPhotoClick:(id)sender;
-(IBAction)btCameraClick:(id)sender;
-(IBAction)btVideoClick:(id)sender;
-(IBAction)btVoiceClick:(id)sender;
-(IBAction)btLocationClick:(id)sender;
-(IBAction)btStickerClick:(id)sender;
-(IBAction)btMoreClick:(id)sender;

-(IBAction)btRecordSend:(id)sender;
-(IBAction)btRecordCancel:(id)sender;
-(IBAction)btRecordStart:(id)sender;

@property (nonatomic, retain) NSDictionary *emojis;
@property (nonatomic, retain) NSDictionary *dictUser;

@end
