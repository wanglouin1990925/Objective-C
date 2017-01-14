//
//  CustomPhotoLargeView.m
//  DND
//
//  Created by Wang MeiHua on 10/21/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import "CustomPhotoLargeView.h"
#import "UIImageView+AFNetworking.h"

@implementation CustomPhotoLargeView

@synthesize delegate;

+ (id)sharedView
{
	CustomPhotoLargeView *customView = [[[NSBundle mainBundle] loadNibNamed:@"CustomPhotoLargeView" owner:nil options:nil] lastObject];
    
	// make sure customView is not nil or the wrong class!
    if ([customView isKindOfClass:[CustomPhotoLargeView class]])
        return customView;
    else
        return nil;
}

- (void)initWithData:(NSArray*)lstPhoto
{
	nPhotoCount = (int)[lstPhoto count];
	for (int i = 0; i < [lstPhoto count]; i++)
	{
		UIImageView *imvPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(320*i, 0, 320, scvLargePhoto.frame.size.height)];
		[imvPhoto setImageWithURL:[NSURL URLWithString:[lstPhoto objectAtIndex:i]]];
		imvPhoto.contentMode = UIViewContentModeScaleAspectFill;
		[scvLargePhoto addSubview:imvPhoto];
		imvPhoto.clipsToBounds = YES;
	}
	
	[lblTitle setText:[NSString stringWithFormat:@"1 of %d",nPhotoCount]];
	[scvLargePhoto setContentSize:CGSizeMake(320*[lstPhoto count], scvLargePhoto.frame.size.height)];
	scvLargePhoto.pagingEnabled = YES;
	scvLargePhoto.delegate = self;
}

- (void)setCurrentPage:(int)nPage
{
	[lblTitle setText:[NSString stringWithFormat:@"%d of %d",nPage + 1,nPhotoCount]];
	[scvLargePhoto setContentOffset:CGPointMake(320*nPage, 0)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(IBAction)btBackClick:(id)sender
{
	[delegate DidBackClick];
}

-(IBAction)btNextClick:(id)sender
{
	int nCurPage = scvLargePhoto.contentOffset.x/320;
	if (nCurPage < nPhotoCount - 1)
	{
		nCurPage = nCurPage + 1;
		[scvLargePhoto setContentOffset:CGPointMake(320*nCurPage, 0) animated:YES];
	}
	[lblTitle setText:[NSString stringWithFormat:@"%d of %d",nCurPage + 1,nPhotoCount]];
}

-(IBAction)btPreClick:(id)sender
{
	int nCurPage = scvLargePhoto.contentOffset.x/320;
	if (nCurPage > 0)
	{
		nCurPage = nCurPage - 1;
		[scvLargePhoto setContentOffset:CGPointMake(320*nCurPage, 0) animated:YES];
	}
	[lblTitle setText:[NSString stringWithFormat:@"%d of %d",nCurPage + 1,nPhotoCount]];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	int nCurPage = scvLargePhoto.contentOffset.x/320;
	[lblTitle setText:[NSString stringWithFormat:@"%d of %d",nCurPage + 1,nPhotoCount]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
