//
//  DEMOMenuViewController.m
//  RESideMenuStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOMenuViewController.h"
#import "YYYHomeController.h"
#import "YYYProjectController.h"
#import "YYYSettingController.h"
#import "YYYNotificationController.h"
#import "UIViewController+RESideMenu.h"
#import "YYYSettingTableController.h"
#import "YYYCommunication.h"
#import "UIImageView+AFNetworking.h"

@interface DEMOMenuViewController ()

@end

@implementation DEMOMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        
        tableView.backgroundView = nil;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = YES;
        tableView.scrollsToTop = NO;
        
        tableView.tableHeaderView = ({
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 184.0f)];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 40, 100, 100)];
            imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WEBAPI_URL,[[YYYCommunication sharedManager].me objectForKey:@"user_avatar"]]]];
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = 50.0;
            imageView.layer.borderColor = [UIColor whiteColor].CGColor;
            imageView.layer.borderWidth = 3.0f;
            imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
            imageView.layer.shouldRasterize = YES;
            imageView.clipsToBounds = YES;
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 240, 24)];
            label.text = [[YYYCommunication sharedManager].me objectForKey:@"user_username"];
            label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            
//          [label sizeToFit];
            
            label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            
            [view addSubview:imageView];
            [view addSubview:label];
            view;
        });
        
        tableView;
    });
    [self.view addSubview:self.tableView];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UINavigationController *navigationController = (UINavigationController *)self.sideMenuViewController.contentViewController;
    
    switch (indexPath.row) {
        case 0:
            navigationController.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"YYYHomeController"]];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 1:
            navigationController.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"YYYProjectController"]];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 2:
            navigationController.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"YYYNotificationController"]];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 3:
            navigationController.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"YYYSettingTableController"]];
            [self.sideMenuViewController hideMenuViewController];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
	NSArray *titles = @[NSLocalizedString(@"My stuff",@"Message"),NSLocalizedString(@"All Projects",@""),NSLocalizedString(@"My Notifications",@""), NSLocalizedString(@"My Settings",@"")];
    NSArray *images = @[@"IconProfile",@"IconWorld",@"IconInfo", @"IconSettings"];
    
    cell.textLabel.text = titles[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    
    return cell;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark -
#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
//    NSLog(@"willShowMenuViewController");
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
//    NSLog(@"didShowMenuViewController");
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
//    NSLog(@"willHideMenuViewController");
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
//    NSLog(@"didHideMenuViewController");
}

@end
