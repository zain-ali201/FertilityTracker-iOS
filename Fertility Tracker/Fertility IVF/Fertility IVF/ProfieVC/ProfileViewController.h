//
//  ProfileViewController.h
//  Fertility IVF
//
//  Created by Tconnect on 12/25/14.
//  Copyright (c) 2014 Tconnect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ProfileViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
    AppDelegate *appDelegate;
    
    IBOutlet UIScrollView *mainScrollView;
    
    IBOutlet UITextField *txtFirstName;
    IBOutlet UITextField *txtLastName;
    IBOutlet UITextField *txtDate;
    IBOutlet UITextField *txtWeight;
    IBOutlet UITextField *txtHeight;
    
    IBOutlet UIView *datePickerView;
    IBOutlet UIDatePicker *datePicker;
    
    float pickerYPosition;
    float pickerYOpenPosition;
}

@end
