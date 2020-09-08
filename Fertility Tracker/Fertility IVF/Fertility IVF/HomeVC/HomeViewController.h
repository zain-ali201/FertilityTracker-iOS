//
//  HomeViewController.h
//  Fertility IVF
//
//  Created by Tconnect on 12/16/14.
//  Copyright (c) 2014 Tconnect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface HomeViewController : UIViewController<UIAlertViewDelegate>
{
    AppDelegate *appDelegate;
    
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblDays;
    IBOutlet UILabel *lblDaysText;
    IBOutlet UIButton *medBtn;
    IBOutlet UIButton *apptBtn;
    IBOutlet UIButton *medBtn1;
    IBOutlet UIButton *apptBtn1;
    IBOutlet UIButton *cycleBtn;
    IBOutlet UIButton *calBtn;
    IBOutlet UIButton *profileBtn;
    IBOutlet UIButton *noteBtn;
}
@end
