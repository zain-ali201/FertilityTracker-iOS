//
//  CycleViewController.h
//  Fertility IVF
//
//  Created by Tconnect on 12/25/14.
//  Copyright (c) 2014 Tconnect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface CycleViewController : UIViewController
{
    AppDelegate *appDelegate;
    
    IBOutlet UITextField *txtStartDate;
    IBOutlet UITextField *txtEndDate;
    
    IBOutlet UIView *IVFView;
    IBOutlet UITextField *txtIVFStartDate;
    IBOutlet UITextField *txtIVFEndDate;
    
    IBOutlet NSLayoutConstraint *topConstraint;
    IBOutlet UIView *datePickerView;
    IBOutlet UIDatePicker *datePicker;
    
    BOOL isStartDateSelected;
    BOOL isIVFStartDateSelected;
    
    float pickerYPosition;
    float pickerYOpenPosition;
    
    BOOL isIVFCycle;
    BOOL isFirstTime;
    
    int device;
}
@end
