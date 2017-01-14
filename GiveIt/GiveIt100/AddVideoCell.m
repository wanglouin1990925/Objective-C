//
//  AddVideoCell.m
//  GiveIt100
//
//  Created by Wang MeiHua on 1/30/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "AddVideoCell.h"

@implementation AddVideoCell

@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initwithData:(NSString*)_daynumber : (NSString*)_date :(int)nIndex
{
    dayNumber = _daynumber;
    date = _date;
    
    [lblDayNumber setText:[NSString stringWithFormat:@"Day %@",_daynumber]];
    [lblDate setText:_date];
    [btAddVideo addTarget:self action:@selector(btAddVideoClick:) forControlEvents:UIControlEventTouchUpInside];
    [btAddVideo setTag:nIndex];
}

-(IBAction)btAddVideoClick:(id)sender
{
    [self.delegate addVideo:dayNumber :date];
}

@end
