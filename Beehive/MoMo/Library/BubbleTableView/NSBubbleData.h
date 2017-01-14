//
//  NSBubbleData.h
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import <Foundation/Foundation.h>
#import "NSBubbleMap.h"

@protocol NSBubbleDataDelegate <NSObject>

-(void)mapTouched:(float)latitude :(float)longitude;

@end

typedef enum _NSBubbleType
{
    BubbleTypeMine = 0,
    BubbleTypeSomeoneElse = 1
} NSBubbleType;

@interface NSBubbleData : NSObject<NSBubbleMapDelegate>

@property (readonly, nonatomic, strong) NSDate *date;
@property (readonly, nonatomic) NSBubbleType type;
@property (readonly, nonatomic, strong) UIView *view;
@property (readonly, nonatomic) UIEdgeInsets insets;
@property (nonatomic, strong) UIImage *avatar;
@property (nonatomic, strong) NSURL *avatar_url;
@property (nonatomic,retain) NSString *mg_id;

@property (nonatomic,retain) id<NSBubbleDataDelegate> delegate;

- (id)initWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type;
+ (id)dataWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type;
- (id)initWithImage:(NSString *)image date:(NSDate *)date type:(NSBubbleType)type;
+ (id)dataWithImage:(NSString *)image date:(NSDate *)date type:(NSBubbleType)type;
- (id)initWithAudio:(NSString *)audio date:(NSDate *)date type:(NSBubbleType)type;
+ (id)dataWithAudio:(NSString *)audio date:(NSDate *)date type:(NSBubbleType)type;
- (id)initWithVideo:(NSString *)video date:(NSDate *)date type:(NSBubbleType)type;
+ (id)dataWithVideo:(NSString *)video date:(NSDate *)date type:(NSBubbleType)type;
- (id)initWithMap:(NSString *)location date:(NSDate *)date type:(NSBubbleType)type;
+ (id)dataWithMap:(NSString *)location date:(NSDate *)date type:(NSBubbleType)type;
- (id)initWithSticker:(NSString *)stickerid date:(NSDate *)date type:(NSBubbleType)type;
+ (id)dataWithSticker:(NSString *)stickerid date:(NSDate *)date type:(NSBubbleType)type;

- (id)initWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets;
+ (id)dataWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets;

@end
