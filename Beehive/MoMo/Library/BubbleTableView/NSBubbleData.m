//
//  NSBubbleData.m
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import "NSBubbleData.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"
#import "NSBubbleAudioPlayer.h"
#import "NSBubbleVideoPlayer.h"
#import <MapKit/MapKit.h>
#import "Place.h"
#import "PlaceMark.h"
#import "NSBubbleMap.h"
#import "NSBubbleSticker.h"

@implementation NSBubbleData

#pragma mark - Properties

@synthesize delegate;
@synthesize date = _date;
@synthesize type = _type;
@synthesize view = _view;
@synthesize insets = _insets;
@synthesize avatar = _avatar;
@synthesize avatar_url = _avatar_url;
@synthesize mg_id = _mg_id;

#pragma mark - Lifecycle

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [_date release];
	_date = nil;
    [_view release];
    _view = nil;
    
    self.avatar = nil;

    [super dealloc];
}
#endif

#pragma mark - Text bubble

const UIEdgeInsets textInsetsMine = {5, 10, 11, 17};
const UIEdgeInsets textInsetsSomeone = {5, 15, 11, 10};

+ (id)dataWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type
{
#if !__has_feature(objc_arc)
    return [[[NSBubbleData alloc] initWithText:text date:date type:type] autorelease];
#else
    return [[NSBubbleData alloc] initWithText:text date:date type:type];
#endif    
}

+ (id)dataWithAudio:(NSString *)audio date:(NSDate *)date type:(NSBubbleType)type
{
#if !__has_feature(objc_arc)
    return [[[NSBubbleData alloc] initWithAudio:audio date:date type:type] autorelease];
#else
    return [[NSBubbleData alloc] initWithAudio:audio date:date type:type];
#endif
}

- (id)initWithAudio:(NSString *)audio date:(NSDate *)date type:(NSBubbleType)type
{
	NSBubbleAudioPlayer *audioplayer = [NSBubbleAudioPlayer customView];
	[audioplayer setFrame:CGRectMake(0, 0, 230, 36)];
	[audioplayer initWithUrl:audio];
	
	UIEdgeInsets insets = (type == BubbleTypeMine ? textInsetsMine : textInsetsSomeone);
    return [self initWithView:audioplayer date:date type:type insets:insets];
}

+ (id)dataWithVideo:(NSString *)video date:(NSDate *)date type:(NSBubbleType)type
{
#if !__has_feature(objc_arc)
    return [[[NSBubbleData alloc] initWithVideo:video date:date type:type] autorelease];
#else
    return [[NSBubbleData alloc] initWithVideo:video date:date type:type];
#endif
}

- (id)initWithVideo:(NSString *)video date:(NSDate *)date type:(NSBubbleType)type
{
	NSBubbleVideoPlayer *videoplayer = [NSBubbleVideoPlayer customView];
	[videoplayer setFrame:CGRectMake(0, 0, 230, 230)];
	[videoplayer initWithUrl:video];
	
	UIEdgeInsets insets = (type == BubbleTypeMine ? textInsetsMine : textInsetsSomeone);
    return [self initWithView:videoplayer date:date type:type insets:insets];
}

+ (id)dataWithMap:(NSString *)location date:(NSDate *)date type:(NSBubbleType)type
{
#if !__has_feature(objc_arc)
    return [[[NSBubbleData alloc] initWithMap:location date:date type:type] autorelease];
#else
    return [[NSBubbleData alloc] initWithMap:location date:date type:type];
#endif
}

- (id)initWithMap:(NSString *)location date:(NSDate *)date type:(NSBubbleType)type
{
	NSBubbleMap *map = [NSBubbleMap customView];
	[map setFrame:CGRectMake(0, 0, 100, 100)];
	map.delegate = self;
	[map initWithLocation:location];
	
	UIEdgeInsets insets = (type == BubbleTypeMine ? textInsetsMine : textInsetsSomeone);
    return [self initWithView:map date:date type:type insets:insets];
}

- (id)initWithSticker:(NSString *)stickerid date:(NSDate *)date type:(NSBubbleType)type
{
	NSBubbleSticker *sticker = [NSBubbleSticker customView];
	[sticker setFrame:CGRectMake(0, 0, 50, 50)];
	[sticker initWithSticker:stickerid];
	
	UIEdgeInsets insets = (type == BubbleTypeMine ? textInsetsMine : textInsetsSomeone);
    return [self initWithView:sticker date:date type:type insets:insets];
}

+ (id)dataWithSticker:(NSString *)sticker date:(NSDate *)date type:(NSBubbleType)type
{
#if !__has_feature(objc_arc)
    return [[[NSBubbleData alloc] initWithSticker:sticker date:date type:type] autorelease];
#else
    return [[NSBubbleData alloc] initWithSticker:sticker date:date type:type];
#endif
}

-(void)mapTouched:(float)lat :(float)lng
{
	[delegate mapTouched:lat :lng];
}

- (id)initWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type
{
//	UIFont *font = [UIFont systemFontOfSize:[[[[NSUserDefaults standardUserDefaults] objectForKey:@"setting"] objectForKey:@"textsize"] intValue]];
	UIFont *font = [UIFont systemFontOfSize:16];
	CGRect textRect = [text boundingRectWithSize:CGSizeMake(220, 9999)
										 options:NSStringDrawingUsesLineFragmentOrigin
									  attributes:@{NSFontAttributeName:font}
										 context:nil];
	CGSize size = textRect.size;
	
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = (text ? text : @"");
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    
#if !__has_feature(objc_arc)
    [label autorelease];
#endif
    
    UIEdgeInsets insets = (type == BubbleTypeMine ? textInsetsMine : textInsetsSomeone);
    return [self initWithView:label date:date type:type insets:insets];
}

#pragma mark - Image bubble

const UIEdgeInsets imageInsetsMine = {11, 13, 16, 22};
const UIEdgeInsets imageInsetsSomeone = {11, 18, 16, 14};

+ (id)dataWithImage:(NSString *)imageurl date:(NSDate *)date type:(NSBubbleType)type
{
#if !__has_feature(objc_arc)
    return [[[NSBubbleData alloc] initWithImage:imageurl date:date type:type] autorelease];
#else
    return [[NSBubbleData alloc] initWithImage:imageurl date:date type:type];
#endif    
}

- (id)initWithImage:(NSString *)imageurl date:(NSDate *)date type:(NSBubbleType)type
{
	CGSize size = CGSizeMake(150, 150);
//    CGSize size = image.size;
//    if (size.width > 220)
//    {
//        size.height /= (size.width / 220);
//        size.width = 220;
//    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
	imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView setImageWithURL:[NSURL URLWithString:imageurl]];
    imageView.layer.cornerRadius = 5.0;
    imageView.layer.masksToBounds = YES;

    
#if !__has_feature(objc_arc)
    [imageView autorelease];
#endif
    
    UIEdgeInsets insets = (type == BubbleTypeMine ? imageInsetsMine : imageInsetsSomeone);
    return [self initWithView:imageView date:date type:type insets:insets];       
}

#pragma mark - Custom view bubble

+ (id)dataWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets
{
#if !__has_feature(objc_arc)
    return [[[NSBubbleData alloc] initWithView:view date:date type:type insets:insets] autorelease];
#else
    return [[NSBubbleData alloc] initWithView:view date:date type:type insets:insets];
#endif    
}

- (id)initWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets  
{
    self = [super init];
    if (self)
    {
#if !__has_feature(objc_arc)
        _view = [view retain];
        _date = [date retain];
#else
        _view = view;
        _date = date;
#endif
        _type = type;
        _insets = insets;
    }
    return self;
}

@end
