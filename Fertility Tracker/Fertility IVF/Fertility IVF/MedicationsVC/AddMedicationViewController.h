//
//  AddMedicationViewController.h
//  Fertility IVF
//
//  Created by Tconnect on 12/23/14.
//  Copyright (c) 2014 Tconnect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

#import "AppDelegate.h"
#import "MedicationDetail.h"
#import "FrequencyDetail.h"

@interface AddMedicationViewController : UIViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate>
{
    AppDelegate *appDelegate;
    
    IBOutlet UIScrollView *mainScrollView;
    
    IBOutlet UILabel *lblMain;
    
    IBOutlet UITextField *txtName;
    IBOutlet UITextField *txtNotes;
    IBOutlet UITextField *txtStrength;
    IBOutlet UITextField *txtPerson;
    
//    IBOutlet UIImageView *reminderOffBG;
//    IBOutlet UIView *reminderOnView;
    
    NSMutableArray *frequencyArray;
    
    /*******ReminderView Outlets*******/
    
    IBOutlet UIImageView *reminderOffBG;
    IBOutlet UIView *reminderOnView;
    
    IBOutlet UISwitch *reminderSwitch;
    IBOutlet UITextField *txtDose;
    IBOutlet UILabel *lblTime;
    IBOutlet UILabel *lblStartDate;
    IBOutlet UILabel *lblEndDate;
    IBOutlet UILabel *lblFrequency;
    IBOutlet UILabel *lblCycleStartDate;
    IBOutlet UILabel *lblCycleEndDate;
    
    IBOutlet UIView *frequencyPickerView;
    IBOutlet UIView *timePickerView;
    IBOutlet UIView *datePickerView;
    
    IBOutlet UIPickerView *frequencyPicker;
    IBOutlet UIDatePicker *timePicker;
    IBOutlet UIDatePicker *datePicker;
    
    IBOutlet UIImageView *glow1;
    IBOutlet UIImageView *glow2;
    
    NSCalendar *calendar;
    
    FrequencyDetail *frequencyDetail;
    
    /*********************************/
    
    float pickerYPosition;
    float pickerYOpenPosition;
    
    BOOL reminderIndicator;
    BOOL isStartDateSelected;
    int increment;
    int device;
    
}

@property BOOL reqForUpdate;
@property (nonatomic,retain) MedicationDetail *medDetail;
@property (strong, nonatomic) EKEventStore *eventStore;

@end
