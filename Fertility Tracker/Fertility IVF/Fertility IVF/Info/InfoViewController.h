//
//  InfoViewController.h
//  Fertility IVF
//
//  Created by Tconnect on 12/25/14.
//  Copyright (c) 2014 Tconnect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"

@interface InfoViewController : UIViewController<MFMailComposeViewControllerDelegate>
{
    AppDelegate *appDelegate;
    
    IBOutlet UILabel *lblYear;
    IBOutlet UILabel *lblVersion;
}
@end
