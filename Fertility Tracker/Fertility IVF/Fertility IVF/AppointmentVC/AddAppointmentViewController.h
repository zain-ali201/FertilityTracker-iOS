//
//  AddAppointmentViewController.h
//  Fertility IVF
//
//  Created by Tconnect on 12/23/14.
//  Copyright (c) 2014 Tconnect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

#import "AppDelegate.h"
#import "MedicationDetail.h"

@interface AddAppointmentViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
    AppDelegate *appDelegate;
    
    IBOutlet UIScrollView *mainScrollView;
    
    IBOutlet UILabel *lblMain;
    
    IBOutlet UITextField *txtName;
    IBOutlet UITextField *txtNotes;
    
    /*******ReminderView Outlets*******/
    
    IBOutlet UIImageView *reminderOffBG;
    IBOutlet UIView *reminderOnView;
    
    IBOutlet UISwitch *reminderSwitch;
    IBOutlet UILabel *lblTime;
    IBOutlet UILabel *lblStartDate;
    IBOutlet UILabel *lblEndDate;
    IBOutlet UILabel *lblCycleStartDateStr;
    IBOutlet UILabel *lblCycleEndDateStr;
    IBOutlet UILabel *lblCycleStartDate;
    IBOutlet UILabel *lblCycleEndDate;
    
    IBOutlet UIImageView *cycleImgView;

    
    IBOutlet UIView *timePickerView;
    IBOutlet UIView *datePickerView;
    
    IBOutlet UIDatePicker *timePicker;
    IBOutlet UIDatePicker *datePicker;
    
    NSCalendar *calendar;
    
    /*********************************/
    
    float pickerYPosition;
    float pickerYOpenPosition;
    
    BOOL reminderIndicator;
    BOOL isStartDateSelected;
    int increment;
    
    int device;
}

@property BOOL reqForUpdate;
@property (nonatomic,retain) MedicationDetail *apptDetail;
@property (strong, nonatomic) EKEventStore *eventStore;

@end
