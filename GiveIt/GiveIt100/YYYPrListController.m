//
//  YYYPrListController.m
//  GiveIt100
//
//  Created by Wang MeiHua on 1/13/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "YYYPrListController.h"
#import "YYYDateListController.h"

@interface YYYPrListController ()

@end

@implementation YYYPrListController

@synthesize lst_project;

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
	// Do any additional setup after loading the view.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([lst_project count]) return [lst_project count];
    else return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIdentifier];
    }
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:16.0f]];
    
    if ([lst_project count]) {
        [cell.textLabel setText:[[lst_project objectAtIndex:indexPath.row] objectForKey:@"title"]];
    }else{
        [cell.textLabel setText:@"You need to add a project before you can add any video. go to settings"];
        cell.textLabel.numberOfLines = 0;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([lst_project count]) {
        return 44.0f;
    }else{
        return 60.0f;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![lst_project count]) {
        return;
    }
    YYYDateListController *viewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"YYYDateListController"];
    viewcontroller.dictProject = [lst_project objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
