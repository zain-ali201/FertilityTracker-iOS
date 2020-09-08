//
//  CycleViewController.m
//  Fertility IVF
//
//  Created by Tconnect on 12/25/14.
//  Copyright (c) 2014 Tconnect. All rights reserved.
//

#import "CycleViewController.h"
#import "HomeViewController.h"
#import "MedicationsViewController.h"
#import "SettingsViewController.h"
#import "NotesViewController.h"
#import "CalendarViewController.h"

@implementation CycleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];

    [self.view bringSubviewToFront:datePickerView];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    txtStartDate.text = [defaults objectForKey:@"startDate"];
    txtEndDate.text = [defaults objectForKey:@"EndDate"];
    txtIVFStartDate.text = [defaults objectForKey:@"IVFstartDate"];
    txtIVFEndDate.text = [defaults objectForKey:@"IVFEndDate"];
    
    if ([txtIVFStartDate.text length] > 0)
    {
        IVFView.alpha = 1;
        isIVFCycle = TRUE;
    }
    else
        isIVFCycle = FALSE;
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    BOOL alertInd = [userDefaults boolForKey:@"CycleFirstAlert"];
    
    if (!alertInd)
    {
        UIAlertView *cycleAlert = [[UIAlertView alloc]initWithTitle:@"Reminder" message:@"Medication Cycle and Cycle dates must match." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [cycleAlert show];
        
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc]init];
        [userDefaults setBool:TRUE forKey:@"CycleFirstAlert"];
        [userDefaults synchronize];
        
        isFirstTime = TRUE;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancelBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)doneBtnAction:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:appDelegate.deviceDateFormat];
    
    BOOL startDateflag = [appDelegate dateComparison:[dateFormatter dateFromString:txtStartDate.text] SecondDate:[dateFormatter dateFromString:txtEndDate.text]  Order:@"A"];
    
    BOOL IVFStartDateflag = [appDelegate dateComparison:[dateFormatter dateFromString:txtIVFStartDate.text] SecondDate:[dateFormatter dateFromString:txtIVFEndDate.text]  Order:@"A"];
    
    if ([txtStartDate.text length] == 0)
    {
        alert.message = @"Please select start date.";
        [alert show];
    }
    else if ([txtEndDate.text length] == 0)
    {
        alert.message = @"Please select end date.";
        [alert show];
    }
    else if ([txtIVFStartDate.text length] == 0)
    {
        alert.message = @"Please select start date for Cycle.";
        [alert show];
    }
    else if ([txtIVFEndDate.text length] == 0)
    {
        alert.message = @"Please select end date for Cycle.";
        [alert show];
    }
    else if (!startDateflag)
    {
        alert.message = @"End Date should be greater than start date of Medication Cycle.";
        [alert show];
    }
    else if (!IVFStartDateflag)
    {
        alert.message = @"End Date should be greater than start date of Cycle.";
        [alert show];
    }
    else
    {
        NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
        [defaults setValue:txtStartDate.text forKey:@"startDate"];
        [defaults setValue:txtEndDate.text forKey:@"EndDate"];
        [defaults setValue:txtIVFStartDate.text forKey:@"IVFstartDate"];
        [defaults setValue:txtIVFEndDate.text forKey:@"IVFEndDate"];
        [defaults synchronize];
        
        appDelegate.cycleStartDate = txtStartDate.text;
        appDelegate.cycleEndDate = txtEndDate.text;
        appDelegate.cycleIVFStartDate = txtIVFStartDate.text;
        appDelegate.cycleIVFEndDate = txtIVFEndDate.text;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:appDelegate.deviceDateFormat];
        
        NSCalendar *gregCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSDateComponents *dateComponents = [gregCalendar components:( NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay )  fromDate:[dateFormatter dateFromString:txtIVFStartDate.text]];
        
        
        NSDateComponents *dateComps = [[NSDateComponents alloc] init];
        
        [dateComps setDay:[dateComponents day]];
        
        [dateComps setMonth:[dateComponents month]];
        
        [dateComps setYear:[dateComponents year]];
        
        [dateComps setHour:9];
        
        [dateComps setMinute:0];
        
        [dateComps setSecond:0];
        
        NSDate *fireDate = [gregCalendar dateFromComponents:dateComps];
        
        UILocalNotification *notification = [[UILocalNotification alloc]init];
        [notification setAlertBody:@"Your cycle should have started."];
        [notification setFireDate:fireDate];
        notification.repeatInterval= NSCalendarUnitDay;
        [notification setTimeZone:[NSTimeZone defaultTimeZone]];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)dateBtnAction:(id)sender
{
    datePicker.date = [NSDate date];
    
    if (!isFirstTime)
    {
        UIAlertView *cycleAlert = [[UIAlertView alloc]initWithTitle:@"Reminder" message:@"Medication Cycle and Cycle dates must match." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [cycleAlert show];
    }
    
    if ([sender tag] == 1001)
    {
        isStartDateSelected = TRUE;
        isIVFCycle = FALSE;
        isFirstTime = TRUE;
    }
    else if ([sender tag] == 1002)
    {
        isStartDateSelected = FALSE;
        isIVFCycle = FALSE;
    }
    else if ([sender tag] == 1003)
    {
        isIVFStartDateSelected = TRUE;
        isIVFCycle = TRUE;
    }
    else if ([sender tag] == 1004)
    {
        isIVFStartDateSelected = FALSE;
        isIVFCycle = TRUE;
    }
    
    
    [self hidePickerViews];
    [self performSelector:@selector(showPickerView) withObject:nil afterDelay:0.4];
}

-(IBAction)pickerDoneBtnAction:(UIButton*)button
{
    BOOL pickerHideFlag = FALSE;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:appDelegate.deviceDateFormat];
    
    NSDate *pickedDate = [datePicker date];
    NSString *date = [dateFormatter stringFromDate:pickedDate];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    if (isIVFCycle)
    {
        if (isIVFStartDateSelected)
        {
            BOOL startDateflag = [appDelegate dateComparison:[dateFormatter dateFromString:txtStartDate.text] SecondDate:pickedDate Order:@"A"];
            
            BOOL endDateflag = [appDelegate dateComparison:[dateFormatter dateFromString:txtEndDate.text] SecondDate:pickedDate Order:@"D"];
            
            if (startDateflag && endDateflag)
            {
                txtIVFStartDate.text = date;
                pickerHideFlag = TRUE;
                //appDelegate.cycleIVFStartDate = date;
            }
            else
            {
                alert.message = @"Cycle start date must be between Medication Cycle date.";
                [alert show];
            }
        }
        else
        {
            BOOL flag = [appDelegate dateComparison:[dateFormatter dateFromString:txtIVFStartDate.text] SecondDate:pickedDate Order:@"A"];
            
            if (flag)
            {
                BOOL startDateflag = [appDelegate dateComparison:[dateFormatter dateFromString:txtStartDate.text] SecondDate:pickedDate Order:@"A"];
                
                BOOL endDateflag = [appDelegate dateComparison:[dateFormatter dateFromString:txtEndDate.text] SecondDate:pickedDate Order:@"D"];
                
                if (startDateflag && endDateflag)
                {
                    txtIVFEndDate.text = date;
                    pickerHideFlag = TRUE;
                    //appDelegate.cycleIVFEndDate = date;
                }
                else
                {
                    alert.message = @"Cycle end date must be between Medication Cycle date.";
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
    else
    {
        if (isStartDateSelected)
        {
            txtStartDate.text = date;
            pickerHideFlag = TRUE;
            
            //appDelegate.cycleStartDate = date;
        }
        else
        {
            BOOL flag = [appDelegate dateComparison:[dateFormatter dateFromString:txtStartDate.text] SecondDate:pickedDate Order:@"A"];
            
            if (flag)
            {
                txtEndDate.text = date;
                pickerHideFlag = TRUE;
                //appDelegate.cycleEndDate = date;
                
                isIVFCycle = TRUE;
                CGContextRef context = UIGraphicsGetCurrentContext();
                [UIView beginAnimations:nil context:context];
                [UIView setAnimationDuration:0.5f];
                IVFView.alpha = 1;
                [UIView commitAnimations];
            }
            else
            {
                pickerHideFlag = FALSE;
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"End Date should be greater than start date." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
        }
    }
    
    if(pickerHideFlag)
        [self hidePickerViews];
}

-(IBAction)pickerCancelBtnAction:(id)sender
{
    [self hidePickerViews];
}

-(void)showPickerView
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.33];
    [UIView commitAnimations];
    
    topConstraint.constant = -200;
}

-(void)hidePickerViews
{
    topConstraint.constant = 0;
}

-(IBAction)menuBtnAction:(UIButton*)button
{
    if (button.tag == 1001)
    {
        HomeViewController *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        [self.navigationController pushViewController:homeVC animated:NO];
    }
    else if (button.tag == 1002 || button.tag == 1004)
    {
        MedicationsViewController *medVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MedicationsViewController"];
        if (button.tag == 1002)
            medVC.medSelected = TRUE;
        else
            medVC.medSelected = FALSE;
        medVC.queryIndicator = @"On going Dosage";
        [self.navigationController pushViewController:medVC animated:NO];
    }
    else if (button.tag == 1005)
    {
        CalendarViewController *calendarVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CalendarViewController"];
        [self.navigationController pushViewController:calendarVC animated:YES];
        
    }
    else if (button.tag == 1006)
    {
        NotesViewController *notesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotesViewController"];
        [self.navigationController pushViewController:notesVC animated:NO];
    }
}

@end
