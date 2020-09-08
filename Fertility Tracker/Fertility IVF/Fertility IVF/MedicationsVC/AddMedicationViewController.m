//
//  AddMedicationViewController.m
//  Fertility IVF
//
//  Created by Tconnect on 12/23/14.
//  Copyright (c) 2014 Tconnect. All rights reserved.
//

#import "AddMedicationViewController.h"
#import "MyCommonFunctions.h"
#import "FrequencyDetail.h"
#import "FrequencyViewController.h"

@implementation AddMedicationViewController

@synthesize medDetail,reqForUpdate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    reminderIndicator = FALSE;
    reminderOnView.alpha = 0;
    reminderOffBG.alpha = 1;
    
    device = [appDelegate CheckDevice];
    
    if (device == 4)
    {
        increment = 300.0;
        pickerYPosition = 575.0;
        pickerYOpenPosition = 395.0;
        
        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, mainScrollView.frame.size.height+180)];
    }
    else if(device == 5)
    {
        increment = 250.0;
        pickerYPosition = 672.0;
        pickerYOpenPosition = 483.0;
    }
    
    [frequencyPickerView setCenter:CGPointMake(self.view.center.x, pickerYPosition)];
    [self.view addSubview:frequencyPickerView];
    
    [timePickerView setCenter:CGPointMake(self.view.center.x, pickerYPosition)];
    [self.view addSubview:timePickerView];
    
    [datePickerView setCenter:CGPointMake(self.view.center.x, pickerYPosition)];
    [self.view addSubview:datePickerView];
    
    [self.view bringSubviewToFront:frequencyPickerView];
    [self.view bringSubviewToFront:timePickerView];
    [self.view bringSubviewToFront:datePickerView];
    
    /*********Frequency Values********/
    FrequencyDetail *freqDetail1 = [[FrequencyDetail alloc]init];
    freqDetail1.freqID = 1;
    freqDetail1.title = @"Daily";
    
    FrequencyDetail *freqDetail2 = [[FrequencyDetail alloc]init];
    freqDetail2.freqID = 2;
    freqDetail2.title = @"Weekly";
    
    FrequencyDetail *freqDetail3 = [[FrequencyDetail alloc]init];
    freqDetail3.freqID = 3;
    freqDetail3.title = @"Monthly";
    
    FrequencyDetail *freqDetail4 = [[FrequencyDetail alloc]init];
    freqDetail4.freqID = 4;
    freqDetail4.title = @"Every x hours";
    
    FrequencyDetail *freqDetail5 = [[FrequencyDetail alloc]init];
    freqDetail5.freqID = 5;
    freqDetail5.title = @"Every x days";
    
    FrequencyDetail *freqDetail6 = [[FrequencyDetail alloc]init];
    freqDetail6.freqID = 6;
    freqDetail6.title = @"Every x weeks";
    
    FrequencyDetail *freqDetail7 = [[FrequencyDetail alloc]init];
    freqDetail7.freqID = 7;
    freqDetail7.title = @"Every x months";
    
    
    frequencyArray = [[NSMutableArray alloc]init];
    [frequencyArray addObject:freqDetail1];
    [frequencyArray addObject:freqDetail2];
    [frequencyArray addObject:freqDetail3];
    [frequencyArray addObject:freqDetail4];
    [frequencyArray addObject:freqDetail5];
    [frequencyArray addObject:freqDetail6];
    [frequencyArray addObject:freqDetail7];
    
    /************************************/
    
    if (reqForUpdate)
    {
        lblMain.text = @"Medication";
        
        frequencyDetail = medDetail.freqDetail;
        txtName.text = medDetail.medName;
        txtStrength.text = medDetail.strength;
        txtNotes.text = medDetail.notes;
        txtPerson.text = medDetail.personName;
        txtDose.text = medDetail.dose;
        lblEndDate.text = medDetail.endDate;
        lblFrequency.text = frequencyDetail.childFreqID>0?frequencyDetail.childTitle:frequencyDetail.title;
        lblStartDate.text = medDetail.startDate;
        lblTime.text = medDetail.time;
        
        
        
        if (medDetail.reminderStatus)
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
        lblMain.text = @"Add Medication";
    }
    
    lblCycleStartDate.text = appDelegate.cycleStartDate;
    lblCycleEndDate.text = appDelegate.cycleEndDate;
    [glow1 setAlpha:0];
    [glow2 setAlpha:0];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated
{
    if (frequencyDetail.childFreqID > 0) {
        lblFrequency.text = frequencyDetail.childTitle;
    }
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
        
        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, mainScrollView.frame.size.height+increment)];
    }
    else
    {
        reminderOnView.alpha = 0;
        reminderOffBG.alpha = 1;
        
        reminderIndicator = FALSE;
        
        txtDose.text = @"";
        lblEndDate.text = @"";
        lblFrequency.text = @"";
        lblStartDate.text = @"";
        lblTime.text = @"";
        
        if (device == 5) {
            [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, mainScrollView.frame.size.height)];
        }
    }
    [UIView commitAnimations];
}

-(IBAction)doneBtnAction:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    if ([txtName.text isEqualToString:@""])
    {
        alert.message = @"Please enter medication name.";
        [alert show];
    }
    else if ([txtStrength.text isEqualToString:@""])
    {
        alert.message = @"Please enter strength.";
        [alert show];
    }
    else if ([lblFrequency.text isEqualToString:@""] && reminderIndicator)
    {
        alert.message = @"Please select frequency.";
        [alert show];
    }
    else if ([lblTime.text isEqualToString:@""] && reminderIndicator)
    {
        alert.message = @"Please select time.";
        [alert show];
    }
    else if ([lblStartDate.text isEqualToString:@""] && reminderIndicator)
    {
        alert.message = @"Please select start date.";
        [alert show];
    }
    else if ([lblEndDate.text isEqualToString:@""] && reminderIndicator)
    {
        alert.message = @"Please select end date.";
        [alert show];
    }
    else
    {
        EKAuthorizationStatus authorizationStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
        
        if (reqForUpdate)
        {
            BOOL flag = [self updateMedicationRecord];
            
            if (flag)
            {
                if (reminderIndicator)
                {
                    if (_eventStore == nil)
                    {
                        _eventStore = [[EKEventStore alloc]init];
                        
                        if (authorizationStatus)
                        {
                            [self createReminder];
                            [self clearScreen:@"Your medication has been updated." Indicator:NO];
                        }
                        else
                        {
                            [_eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
                                
                                if (granted)
                                {
                                    [self createReminder];
                                    [self clearScreen:@"Your medication has been updated." Indicator:NO];
                                }
                            }];
                        }
                    }
                    else
                    {
                        [self createReminder];
                        [self clearScreen:@"Your medication has been updated." Indicator:NO];
                    }
                }
                
            }
        }
        else
        {
            BOOL flag = [self addMedicationRecord];
            
            if (flag)
            {
                if (reminderIndicator)
                {
                    if (_eventStore == nil)
                    {
                        _eventStore = [[EKEventStore alloc]init];
                        
                        if (authorizationStatus)
                        {
                            [self createReminder];
                            [self clearScreen:@"Your medication has been saved." Indicator:NO];
                        }
                        else
                        {
                            [_eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
                                
                                if (granted)
                                {
                                    [self createReminder];
                                    [self clearScreen:@"Your medication has been saved." Indicator:YES];
                                }
                            }];
                        }
                    }
                    else
                    {
                        [self createReminder];
                        [self clearScreen:@"Your medication has been saved." Indicator:YES];
                    }
                }
            }
        }
    }
}

-(void)clearScreen:(NSString*)message Indicator:(BOOL)ind
{
    UIAlertView *medAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    medAlert.tag = 1001;
    medAlert.message = message;
    [medAlert show];
    
    if (ind)
    {
        txtName.text = @"";
        txtStrength.text = @"";
        txtNotes.text = @"";
        txtPerson.text = @"";
        txtDose.text = @"";
        lblEndDate.text = @"";
        lblFrequency.text = @"";
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
    
    reminder.title = [NSString stringWithFormat:@"My IVF Tracker - Medication Reminder \nMedication: %@ \nToday at %@",txtName.text,lblTime.text];
    
    reminder.calendar = [_eventStore defaultCalendarForNewReminders];
    
//    EKCalendar *remCalendar = [EKCalendar calendarForEntityType:EKEntityTypeReminder eventStore:_eventStore];
//    remCalendar.title = @"My IVF Tracker";
//    remCalendar.source = _eventStore.defaultCalendarForNewReminders.source;
//    
//    NSError *calendarErr = nil;
//    [_eventStore saveCalendar:remCalendar commit:YES error:&calendarErr];
//    
//    reminder.calendar = remCalendar;
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:appDelegate.deviceDateFormat];
    
    NSDateComponents *dateComponents = [calendar components:( NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay )  fromDate:[dateFormatter dateFromString:lblStartDate.text]];
    
    NSDateComponents *endDateComponents = [calendar components:( NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay )  fromDate:[dateFormatter dateFromString:lblEndDate.text]];
    
    [dateFormatter setDateFormat:@"hh:mm aa"];
    
    NSDateComponents *timeComponents = [calendar components:( NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:[dateFormatter dateFromString:lblTime.text]];
    
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    
    [dateComps setDay:[dateComponents day]];
    
    [dateComps setMonth:[dateComponents month]];
    
    [dateComps setYear:[dateComponents year]];
    
    [dateComps setHour:[timeComponents hour]];
    
    [dateComps setMinute:[timeComponents minute]];
    
    [dateComps setSecond:[timeComponents second]];
    
    NSDateComponents *endDateComps = [[NSDateComponents alloc] init];
    
    [endDateComps setDay:[endDateComponents day]];
    
    [endDateComps setMonth:[endDateComponents month]];
    
    [endDateComps setYear:[endDateComponents year]];
    
    [endDateComps setHour:[timeComponents hour]];
    
    [endDateComps setMinute:[timeComponents minute]];
    
    [endDateComps setSecond:[timeComponents second]];
    
    
    NSDate *date = [calendar dateFromComponents:dateComps];
    
    NSDate *endDate = [calendar dateFromComponents:endDateComps];
    
    NSLog(@"End Date: %@",endDate);
    
    
    EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:date];
    
    
    [reminder addAlarm:alarm];
    
    [reminder setStartDateComponents:dateComponents];
    
    
    EKRecurrenceEnd *endRec = [EKRecurrenceEnd recurrenceEndWithEndDate:endDate];
    
    //initRecurrenceWithFrequency:interval:daysOfTheWeek:daysOfTheMonth:monthsOfTheYear:weeksOfTheYear:daysOfTheYear:setPositions:end:
    
    //int interval = 0;
    NSArray* rulesArray = [reminder recurrenceRules];
    
    for (EKRecurrenceRule* rule in rulesArray)
        [reminder removeRecurrenceRule:rule];
    
    NSLog(@"childFreqID = %i", frequencyDetail.childFreqID);
    
    EKRecurrenceRule *recurrenceRule;

    if (frequencyDetail.freqID == 1) {
        recurrenceRule = [[EKRecurrenceRule alloc]initRecurrenceWithFrequency:EKRecurrenceFrequencyDaily interval:1 end:endRec];
    }
    else if (frequencyDetail.freqID == 2) {
        recurrenceRule = [[EKRecurrenceRule alloc]initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly interval:1 end:endRec];
    }
    else if (frequencyDetail.freqID == 3) {
        recurrenceRule = [[EKRecurrenceRule alloc]initRecurrenceWithFrequency:EKRecurrenceFrequencyMonthly interval:1 end:endRec];
    }
    else if (frequencyDetail.freqID == 4) {
        recurrenceRule = [[EKRecurrenceRule alloc]initRecurrenceWithFrequency:EKRecurrenceFrequencyDaily interval:1 end:endRec];
    }
    else if (frequencyDetail.freqID == 5) {
        recurrenceRule = [[EKRecurrenceRule alloc]initRecurrenceWithFrequency:EKRecurrenceFrequencyDaily interval:frequencyDetail.childFreqID end:endRec];
    }
    else if (frequencyDetail.freqID == 6) {
        recurrenceRule = [[EKRecurrenceRule alloc]initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly interval:frequencyDetail.childFreqID end:endRec];
    }
    else if (frequencyDetail.freqID == 7) {
        recurrenceRule = [[EKRecurrenceRule alloc]initRecurrenceWithFrequency:EKRecurrenceFrequencyMonthly interval:frequencyDetail.childFreqID end:endRec];
    }
    
    
    
    NSMutableArray *rules = [[NSMutableArray alloc] init];
    
    [rules arrayByAddingObject:recurrenceRule];
    
    reminder.recurrenceRules = rules;
    
    //[reminder addRecurrenceRule:recurrenceRule];
    [reminder setDueDateComponents:endDateComponents];
    
    
    NSError *error = nil;
    
    [_eventStore saveReminder:reminder commit:YES error:&error];
    
    if (error)
        NSLog(@"error = %@", error);
    
}

-(IBAction)frequencyBtnAction:(id)sender
{
    [self hideKeyboard];
    [frequencyPicker reloadAllComponents];
    [appDelegate jumpAnimationForView:frequencyPickerView toPoint:CGPointMake(self.view.center.x, pickerYOpenPosition)];
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
    {
        isStartDateSelected = TRUE;
        [glow1 setAlpha:1];
        [glow2 setAlpha:0];
    }
    else
    {
        isStartDateSelected = FALSE;
        [glow1 setAlpha:0];
        [glow2 setAlpha:1];
    }
    
    [self hidePickerViews];
    [self performSelector:@selector(showPickerView) withObject:nil afterDelay:0.4];
}

-(void)showPickerView
{
    [appDelegate jumpAnimationForView:datePickerView toPoint:CGPointMake(self.view.center.x, pickerYOpenPosition)];
}

-(IBAction)pickerDoneBtnAction:(UIButton*)button
{
    BOOL pickerHideFlag = FALSE;
    [glow1 setAlpha:0];
    [glow2 setAlpha:0];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    if (button.tag == 1001)
    {
        frequencyDetail = [frequencyArray objectAtIndex:[frequencyPicker selectedRowInComponent:0]];

        if (frequencyDetail.freqID > 3)
        {
            NSString *viewName = [appDelegate CheckDevice:@"FrequencyViewController" iPhone5:@"FrequencyViewControllerIphone5" iPAD:@""];
            FrequencyViewController *freqVC = [[FrequencyViewController alloc]initWithNibName:viewName bundle:[NSBundle mainBundle]];
            freqVC.detail = frequencyDetail;
            [self.navigationController pushViewController:freqVC animated:YES];
        }
        else
        {
            lblFrequency.text = frequencyDetail.title;
        }
        
        pickerHideFlag = TRUE;
    }
    else if (button.tag == 1002)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mm aa"];
        
        NSDate *pickedTime = [timePicker date];
        lblTime.text = [dateFormatter stringFromDate:pickedTime];
        
        pickerHideFlag = TRUE;
    }
    else if (button.tag == 1003)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:appDelegate.deviceDateFormat];
        
        NSDate *pickedDate = [datePicker date];
        NSString *date = [dateFormatter stringFromDate:pickedDate];
        if (isStartDateSelected)
        {
            BOOL startDateflag = [appDelegate dateComparison:[dateFormatter dateFromString:appDelegate.cycleStartDate] SecondDate:pickedDate Order:@"A"];
            
            //BOOL endDateflag = [appDelegate dateComparison:[dateFormatter dateFromString:appDelegate.cycleEndDate] SecondDate:pickedDate Order:@"D"];
            
            if (startDateflag/* && endDateflag*/)
            {
                lblStartDate.text = date;
                pickerHideFlag = TRUE;
            }
            else
            {
                alert.message = @"Start Date must be between Medication Cycle date.";
                [alert show];
            }
        }
        else
        {
            BOOL flag = [appDelegate dateComparison:[dateFormatter dateFromString:lblStartDate.text] SecondDate:pickedDate Order:@"A"];
            
            if (flag)
            {
                BOOL startDateflag = [appDelegate dateComparison:[dateFormatter dateFromString:appDelegate.cycleStartDate] SecondDate:pickedDate Order:@"A"];
                
                BOOL endDateflag = [appDelegate dateComparison:[dateFormatter dateFromString:appDelegate.cycleEndDate] SecondDate:pickedDate Order:@"D"];
                
                if (startDateflag && endDateflag)
                {
                    lblEndDate.text = date;
                    pickerHideFlag = TRUE;
                }
                else
                {
                    alert.message = @"End Date must be between Medication Cycle date.";
                    [alert show];
                }
            }
            else
            {
                pickerHideFlag = FALSE;
                alert.message = @"End Date should be greater than start date.";
                [alert show];
            }
        }
    }
    if(pickerHideFlag)
        [self hidePickerViews];
}

-(IBAction)pickerCancelBtnAction:(id)sender
{
    [glow1 setAlpha:0];
    [glow2 setAlpha:0];
    [self hidePickerViews];
}

-(void)hidePickerViews
{
    [appDelegate jumpAnimationForView:frequencyPickerView toPoint:CGPointMake(self.view.center.x, pickerYPosition)];
    [appDelegate jumpAnimationForView:timePickerView toPoint:CGPointMake(self.view.center.x, pickerYPosition)];
    [appDelegate jumpAnimationForView:datePickerView toPoint:CGPointMake(self.view.center.x, pickerYPosition)];
}

-(BOOL)addMedicationRecord
{
    BOOL flag = [MyCommonFunctions itemExistsInDatabase:@"Medications" FieldName:@"med_name" Value:txtName.text];
    BOOL success = FALSE;
    
    if (!flag)
    {
        NSString *queryString = [NSString stringWithFormat:@"insert into Medications (med_id,med_name,strength,notes,person_name,rem_status,dose,frequency,time,start_date,end_date,frequency_id,freq_child_id,freq_child_title) values (%i,'%@','%@','%@','%@','%i','%@','%@','%@','%@','%@','%i','%i','%@');",1,txtName.text,txtStrength.text,txtNotes.text,txtPerson.text,reminderIndicator,txtDose.text,lblFrequency.text,lblTime.text,[appDelegate formatDate:lblStartDate.text Format:appDelegate.deviceDateFormat ToFormat:@"MM/dd/yyyy"],[appDelegate formatDate:lblEndDate.text Format:appDelegate.deviceDateFormat ToFormat:@"MM/dd/yyyy"],frequencyDetail.freqID,frequencyDetail.childFreqID,frequencyDetail.childTitle];
        
        success = [MyCommonFunctions InsUpdateDelData:queryString];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"This medication is already exists." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
    return success;
}

-(BOOL)updateMedicationRecord
{
    NSString *queryString = [NSString stringWithFormat:@"update Medications set med_name = '%@', strength = '%@', notes  = '%@', person_name  = '%@', rem_status = %i, dose  = '%@', frequency = '%@', time = '%@', start_date = '%@', end_date = '%@', frequency_id = '%i', freq_child_id = '%i', freq_child_title = '%@' where id=%i;",txtName.text,txtStrength.text,txtNotes.text,txtPerson.text,reminderIndicator,txtDose.text,lblFrequency.text,lblTime.text,[appDelegate formatDate:lblStartDate.text Format:appDelegate.deviceDateFormat ToFormat:@"MM/dd/yyyy"],[appDelegate formatDate:lblEndDate.text Format:appDelegate.deviceDateFormat ToFormat:@"MM/dd/yyyy"],frequencyDetail.freqID,frequencyDetail.childFreqID,frequencyDetail.childTitle,medDetail.medID];
    
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
    if (device == 4)
    {
        if (textField == txtNotes || textField == txtPerson)
        {
            [mainScrollView scrollRectToVisible:CGRectMake(mainScrollView.center.x, mainScrollView.center.y, mainScrollView.frame.size.width, mainScrollView.frame.size.height-100) animated:YES];
        }
        else if (textField == txtDose)
        {
            [mainScrollView scrollRectToVisible:CGRectMake(mainScrollView.center.x, mainScrollView.center.y, mainScrollView.frame.size.width, mainScrollView.frame.size.height-180) animated:YES];
        }
    }
    else
    {
        if (textField == txtDose)
        {
            [mainScrollView scrollRectToVisible:CGRectMake(mainScrollView.center.x, mainScrollView.center.y, mainScrollView.frame.size.width, mainScrollView.frame.size.height-100) animated:YES];
        }
    }
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
    [txtStrength resignFirstResponder];
    [txtDose resignFirstResponder];
    [txtNotes resignFirstResponder];
    [txtPerson resignFirstResponder];
}

#pragma mark- PickerView Delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return frequencyArray.count;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    FrequencyDetail *freqDetail = [frequencyArray objectAtIndex:row];
    
    return freqDetail.title;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}

@end
