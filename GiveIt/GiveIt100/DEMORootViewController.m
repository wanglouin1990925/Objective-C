//
//  DEMOViewController.m
//  RESideMenuStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMORootViewController.h"
#import "DEMOMenuViewController.h"

@interface DEMORootViewController ()

@end

@implementation DEMORootViewController

- (void)awakeFromNib
{
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DEMOMenuViewController"];
    [self.view setBackgroundColor:[UIColor colorWithRed:50.0f/255 green:102.0f/255 blue:133.0f/255 alpha:0.5f]];

    //  self.backgroundImage = [UIImage imageNamed:@"Stars"];
    self.delegate = (DEMOMenuViewController *)self.menuViewController;
}

@end
