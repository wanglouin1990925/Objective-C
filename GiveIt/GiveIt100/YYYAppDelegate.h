//
//  YYYAppDelegate.h
//  GiveIt100
//
//  Created by Wang MeiHua on 1/10/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYYAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)userLoggedIn;
- (void)userLogedOut;

@end
