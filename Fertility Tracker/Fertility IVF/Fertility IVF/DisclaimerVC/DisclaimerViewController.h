//
//  DisclaimerViewController.h
//  Fertility IVF
//
//  Created by Zain Ali on 3/12/15.
//  Copyright (c) 2015 Tconnect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface DisclaimerViewController : UIViewController
{
    AppDelegate *appDelegate;
    
    IBOutlet UIScrollView *scrollView;
    IBOutlet UILabel *lblMessage;
    IBOutlet UIButton *checkBtn;
    IBOutlet UIButton *nextBtn;
    IBOutlet UILabel *lblDetail;
    
    BOOL isChecked;
}

@property BOOL fromInfoVC;

@end
