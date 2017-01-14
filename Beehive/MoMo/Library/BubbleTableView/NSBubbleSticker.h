//
//  NSBubbleSticker.h
//  PiformulaApp
//
//  Created by Wang MeiHua on 4/2/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSBubbleSticker : UIView
{
	IBOutlet UIImageView *imvSticker;
}
+ (id)customView;
-(void)initWithSticker:(NSString*)stickerid;
@end
