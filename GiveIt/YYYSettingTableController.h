//
//  YYYSettingTableController.h
//  GiveIt100
//
//  Created by Wang MeiHua on 1/11/14.
//  Copyright (c) 2014 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface YYYSettingTableController : UITableViewController<MFMailComposeViewControllerDelegate>
{
    IBOutlet UILabel *lblContact;
    IBOutlet UILabel *lblLogout;
    
}

-(IBAction)btTermsClick:(id)sender;
-(IBAction)btPrivacyClick:(id)sender;
@end
