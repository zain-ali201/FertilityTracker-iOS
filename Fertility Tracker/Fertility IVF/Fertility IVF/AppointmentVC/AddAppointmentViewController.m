//
//  AddAppointmentViewController.m
//  Fertility IVF
//
//  Created by Tconnect on 12/23/14.
//  Copyright (c) 2014 Tconnect. All rights reserved.
//

#import "AddAppointmentViewController.h"
#import "MyCommonFunctions.h"

@implementation AddAppointmentViewController

@synthesize apptDetail,reqForUpdate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    device = [appDelegate CheckDevice];
    
    if (device == 4)
    {
        increment = 130.0;
        pickerYPosition = 575.0;
        pickerYOpenPosition = 395.0;
        
        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, mainScrollView.frame.size.height+increment)];
    }
    else if(device == 5)
    {
        increment = 70.0;
        pickerYPosition = 672.0;
        pickerYOpenPosition = 483.0;
    }
    
    [timePickerView setCenter:CGPointMake(self.view.center.x, pickerYPosition)];
    [self.view addSubview:timePickerView];
    
    [datePickerView setCenter:CGPointMake(self.view.center.x, pickerYPosition)];
    [self.view addSubview:datePickerView];
    
    [self.view bringSubviewToFront:timePickerView];
    [self.view bringSubviewToFront:datePickerView];
    
    reminderIndicator = FALSE;
    reminderOnView.alpha = 0;
    reminderOffBG.alpha = 1;
    
    if (reqForUpdate)
    {
        lblMain.text = @"Appointment";
        
        txtName.text = apptDetail.medName;
        txtNotes.text = apptDetail.notes;
        lblEndDate.text = apptDetail.endDate;
        lblStartDate.text = apptDetail.startDate;
        lblTime.text = apptDetail.time;
        
        lblCycleEndDate.alpha = 1;
        lblCycleEndDateStr.alpha = 1;
        lblCycleStartDate.alpha = 1;
        lblCycleStartDateStr.alpha = 1;
        cycleImgView.alpha = 1;
        
        if (apptDetail.reminderStatus)
        {
            [reminderSwitch setOn:YES];
            
            reminderIndicator = TRUE;
            reminderOnView.alpha = 1;
            reminderOffBG.alpha = 0;
            
            [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, mainScrollView.frame.size.height+increment)];
        }
        else
            [reminderSwitch setOn:NO];
    }
    else
    {
        lblMain.text = @"Add Appointment";
    }
    
    lblCycleStartDate.text = appDelegate.cycleStartDate;
    lblCycleEndDate.text = appDelegate.cycleEndDate;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backbtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)switchBtnAction:(UISwitch *)switchState
{
    [self switchFunction:switchState];
}

-(void)switchFunction:(UISwitch *)switchState
{
    [self hideKeyboard];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationDuration:0.5f];
    
    if ([switchState isOn])
    {
        reminderOnView.alpha = 1;
        reminderOffBG.alpha = 0;
        reminderIndicator = TRUE;
        lblCycleEndDate.alpha = 1;
        lblCycleEndDateStr.alpha = 1;
        lblCycleStartDate.alpha = 1;
        lblCycleStartDateStr.alpha = 1;
        cycleImgView.alpha = 1;
        
        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, mainScrollView.frame.size.height+increment)];
    }
    else
    {
        reminderOnView.alpha = 0;
        reminderOffBG.alpha = 1;
        reminderIndicator = FALSE;
        lblCycleEndDate.alpha = 0;
        lblCycleEndDateStr.alpha = 0;
        lblCycleStartDate.alpha = 0;
        lblCycleStartDateStr.alpha = 0;
        cycleImgView.alpha = 0;
        
        lblEndDate.text = @"";
        lblStartDate.text = @"";
        lblTime.text = @"";
        
        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, mainScrollView.frame.size.height)];
        
    }
    [UIView commitAnimations];
}

-(IBAction)doneBtnAction:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    if ([txtName.text isEqualToString:@""])
    {
        alert.message = @"Please enter appointment title.";
        [alert show];
    }
    else if ([lblTime.text isEqualToString:@""] && reminderIndicator)
    {
        alert.message = @"Please select time.";
        [alert show];
    }
    else if ([lblStartDate.text isEqualToString:@""] && reminderIndicator)
    {
        alert.message = @"Please select date.";
        [alert show];
    }
    else if ([lblEndDate.text isEqualToString:@""] && reminderIndicator)
    {
        alert.message = @"Please select end date.";
        [alert show];
    }
    else
    {
        if (reqForUpdate)
        {
            BOOL flag = [self updateAppointmentRecord];
            
            if (flag)
            {
                if (reminderIndicator)
                {
                    if (_eventStore == nil)
                    {
                        _eventStore = [[EKEventStore alloc]init];
                        
                        [_eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
                            
                            if (granted)
                            {
                                [self createReminder];
                                [self clearScreen:@"Your appointment has been updated." Indicator:NO];
                            }
                        }];
                    }
                    else
                    {
                        [self createReminder];
                        [self clearScreen:@"Your appointment has been updated." Indicator:NO];
                    }
                }
            }
        }
        else
        {
            BOOL flag = [self addAppointmentRecord];
            
            if (flag)
            {
                if (reminderIndicator)
                {
                    if (_eventStore == nil)
                    {
                        _eventStore = [[EKEventStore alloc]init];
                        
                        [_eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
                            
                            if (granted)
                            {
                                [self createReminder];
                                [self clearScreen:@"Your appointment has been saved." Indicator:YES];
                            }
                        }];
                    }
                    else
                    {
                        [self createReminder];
                        [self clearScreen:@"Your appointment has been saved." Indicator:YES];
                    }
                }
            }
        }
    }
}

-(void)clearScreen:(NSString*)message Indicator:(BOOL)ind
{
    UIAlertView *apptAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    apptAlert.tag = 1001;
    apptAlert.message = message;
    [apptAlert show];
    
    if (ind)
    {
        txtName.text = @"";
        txtNotes.text = @"";
        lblEndDate.text = @"";
        lblStartDate.text = @"";
        lblTime.text = @"";
        [reminderSwitch setOn:NO animated:YES];
        
        [self switchFunction:reminderSwitch];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)createReminder
{
    calendar = [NSCalendar currentCalendar];
    
    EKReminder *reminder = [EKReminder reminderWithEventStore:self.eventStore];
    
    reminder.title = [NSString stringWithFormat:@"My IVF Tracker - Appointment Reminder \n Appointment: %@ \nToday at %@",txtName.text,lblTime.text];
    
    reminder.calendar = [_eventStore defaultCalendarForNewReminders];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:appDelegate.deviceDateFormat];
    
    NSDateComponents *dateComponents = [calendar components:( NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay )  fromDate:[dateFormatter dateFromString:lblStartDate.text]];
    
    [dateFormatter setDateFormat:@"hh:mm aa"];
    
    NSDateComponents *timeComponents = [calendar components:( NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:[dateFormatter dateFromString:lblTime.text]];
    
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    
    [dateComps setDay:[dateComponents day]];
    
    [dateComps setMonth:[dateComponents month]];
    
    [dateComps setYear:[dateComponents year]];
    
    [dateComps setHour:[timeComponents hour]];
    
    [dateComps setMinute:[timeComponents minute]];
    
    [dateComps setSecond:[timeComponents second]];
    
    NSDate *date = [calendar dateFromComponents:dateComps];
    
    NSLog(@"date: %@",date);
    
    EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:date];
    
    [reminder addAlarm:alarm];
    
    NSError *error = nil;
    
    [_eventStore saveReminder:reminder commit:YES error:&error];
    
    if (error)
        NSLog(@"error = %@", error);
    
}

-(IBAction)timeBtnAction:(id)sender
{
    [self hideKeyboard];
    [appDelegate jumpAnimationForView:timePickerView toPoint:CGPointMake(self.view.center.x, pickerYOpenPosition)];
}

-(IBAction)dateBtnAction:(id)sender
{
    [self hideKeyboard];
    datePicker.date = [NSDate date];
    
    if ([sender tag] == 1001)
        isStartDateSelected = TRUE;
    else
        isStartDateSelected = FALSE;
    
    [appDelegate jumpAnimationForView:datePickerView toPoint:CGPointMake(self.view.center.x, pickerYOpenPosition)];
}

-(IBAction)pickerDoneBtnAction:(UIButton*)button
{
    BOOL pickerHideFlag = FALSE;
    
    if (button.tag == 1001)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mm aa"];
        
        NSDate *pickedTime = [timePicker date];
        lblTime.text = [dateFormatter stringFromDate:pickedTime];
        
        pickerHideFlag = TRUE;
    }
    else if (button.tag == 1002)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:appDelegate.deviceDateFormat];
        
        NSDate *pickedDate = [datePicker date];
        NSString *date = [dateFormatter stringFromDate:pickedDate];
        
        if (isStartDateSelected)
        {
            BOOL startDateflag = [appDelegate dateComparison:[dateFormatter dateFromString:appDelegate.cycleStartDate] SecondDate:pickedDate Order:@"A"];
            
            BOOL endDateflag = [appDelegate dateComparison:[dateFormatter dateFromString:appDelegate.cycleEndDate] SecondDate:pickedDate Order:@"D"];
            
            if (startDateflag && endDateflag)
            {
                lblStartDate.text = date;
                pickerHideFlag = TRUE;
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                alert.message = @"Date must be between Medication Cycle date.";
                [alert show];
            }
        }
        else
        {
            lblEndDate.text = date;
        }
    }
    
    if(pickerHideFlag)
        [self hidePickerViews];
}

-(IBAction)pickerCancelBtnAction:(id)sender
{
    [self hidePickerViews];
}

-(void)hidePickerViews
{
    [appDelegate jumpAnimationForView:timePickerView toPoint:CGPointMake(self.view.center.x, pickerYPosition)];
    [appDelegate jumpAnimationForView:datePickerView toPoint:CGPointMake(self.view.center.x, pickerYPosition)];
}

-(BOOL)addAppointmentRecord
{
    NSString *queryString = [NSString stringWithFormat:@"insert into Appointments (appt_id,appt_name,notes,rem_status,time,start_date,end_date) values (%i,'%@','%@','%i','%@','%@','%@');",1,txtName.text,txtNotes.text,reminderIndicator,lblTime.text,[lblStartDate.text length]>0?[appDelegate formatDate:lblStartDate.text Format:appDelegate.deviceDateFormat ToFormat:@"MM/dd/yyyy"]:@"",[appDelegate formatDate:lblEndDate.text Format:appDelegate.deviceDateFormat ToFormat:@"MM/dd/yyyy"]];
    
    BOOL success = [MyCommonFunctions InsUpdateDelData:queryString];
    
    return success;
}

-(BOOL)updateAppointmentRecord
{
    NSString *queryString = [NSString stringWithFormat:@"update Appointments set appt_name = '%@', notes  = '%@' , rem_status = %i , time = '%@' , start_date = '%@' , end_date = '%@' where id=%i;",txtName.text,txtNotes.text,reminderIndicator,lblTime.text,[lblStartDate.text length]>0?[appDelegate formatDate:lblStartDate.text Format:appDelegate.deviceDateFormat ToFormat:@"MM/dd/yyyy"]:@"",[appDelegate formatDate:lblEndDate.text Format:appDelegate.deviceDateFormat ToFormat:@"MM/dd/yyyy"],apptDetail.medID];
    
    BOOL success = [MyCommonFunctions InsUpdateDelData:queryString];
    
    return success;
}

-(BOOL)deleteFromFavorites:(int)itemID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *queryString = [NSString stringWithFormat:@"delete from Medications where item_id=%i and user_id=%@",itemID,[defaults objectForKey:@"userID"]];
    
    BOOL flag = [MyCommonFunctions InsUpdateDelData:queryString];
    return flag;
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
//    if (reminderIndicator)
//    {
//        if (textField == txtDose)
//        {
//            [mainScrollView scrollRectToVisible:CGRectMake(mainScrollView.center.x, mainScrollView.center.y, mainScrollView.frame.size.width, mainScrollView.frame.size.height-100) animated:YES];
//        }
//    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideKeyboard];
}

-(IBAction)keyboardHideBtnAction:(id)sender
{
    [self hideKeyboard];
}

-(void)hideKeyboard
{
    [txtName resignFirstResponder];
    [txtNotes resignFirstResponder];
}

@end
