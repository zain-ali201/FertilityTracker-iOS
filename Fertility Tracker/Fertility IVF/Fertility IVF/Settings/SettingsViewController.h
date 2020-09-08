//
//  SettingsViewController.h
//  Fertility IVF
//
//  Created by Sprint on 24/02/2019.
//  Copyright © 2019 Tconnect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"

@interface SettingsViewController : UIViewController<MFMailComposeViewControllerDelegate,UIAlertViewDelegate>
{
    AppDelegate *appDelegate;
}
@end

