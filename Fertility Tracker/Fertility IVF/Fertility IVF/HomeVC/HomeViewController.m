//
//  HomeViewController.m
//  Fertility IVF
//
//  Created by Tconnect on 12/16/14.
//  Copyright (c) 2014 Tconnect. All rights reserved.
//

#import "HomeViewController.h"
#import "MedicationsViewController.h"
#import "CycleViewController.h"
#import "ProfileViewController.h"
#import "SettingsViewController.h"
#import "NotesViewController.h"
#import "CalendarViewController.h"

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//
//    BOOL rateClickInd = [userDefaults boolForKey:@"rateAlertClick"];
//    BOOL remindClickInd = [userDefaults boolForKey:@"remind"];
//
//    if (!rateClickInd)
//    {
//        UIAlertView *rateAlert = [[UIAlertView alloc]initWithTitle:@"My IVF Tracker" message:@"If you enjoy using My IVF Tracker, would you mind taking a moment to rate it? It won't take more than a minute. Thanks for your support!" delegate:self cancelButtonTitle:@"No, Thanks" otherButtonTitles:@"Rate My IVF Tracker", @"Remind me later", nil];
//        rateAlert.tag = 1001;
//        [rateAlert show];
//    }
//    else if (remindClickInd)
//    {
//        NSString *currentDateStr = [appDelegate formatDate:[NSDate date] ToFormat:@"yyy-MM-dd HH:mm:ss"];
//
//        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//
//        NSDate *previousDate = [formatter dateFromString:[userDefaults valueForKey:@"date"]];
//        NSDate *currentDate = [formatter dateFromString:currentDateStr];
//        
//        NSLog(@"PreviousDate:  %@",previousDate);
//        NSLog(@"currentDate:  %@",currentDate);
//
//        NSInteger hours = [self hoursBetweenDates:currentDate andDate:previousDate];
//        NSLog(@"Hours:  %ld",(long)hours);
//
//        if (hours >= 5)
//        {
//            UIAlertView *rateAlert = [[UIAlertView alloc]initWithTitle:@"My IVF Tracker" message:@"If you enjoy using My IVF Tracker, would you mind taking a moment to rate it? It won't take more than a minute. Thanks for your support!" delegate:self cancelButtonTitle:@"No, Thanks " otherButtonTitles:@"Rate My IVF Tracker", @"Remind me later", nil];
//            rateAlert.tag = 1001;
//            [rateAlert show];
//        }
//    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001)
    {
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc]init];
        if (buttonIndex == 0)
        {
            [userDefaults setBool:TRUE forKey:@"rateAlertClick"];
        }
        else if (buttonIndex == 1)
        {
            [userDefaults setBool:TRUE forKey:@"rateAlertClick"];
            
            BOOL fbInstalled = [self schemeAvailable:@"fb://"];
            if (fbInstalled)
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fb://profile/753584901440867"]];
            }
            else
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/myivftracker"]];
            }
        }
        else if (buttonIndex == 2)
        {
            [userDefaults setBool:TRUE forKey:@"rateAlertClick"];
            [userDefaults setBool:TRUE forKey:@"remind"];
            [userDefaults setValue:[appDelegate formatDate:[NSDate date] ToFormat:@"yyy-MM-dd HH:mm:ss"] forKey:@"date"];
            //[userDefaults setValue:@"2016-10-27 10:03:31" forKey:@"date"];
        }
        
        [userDefaults synchronize];
    }
}

- (BOOL)schemeAvailable:(NSString *)scheme
{
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:scheme];
    return [application canOpenURL:URL];
}

-(NSInteger)hoursBetweenDates:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
//    NSDate *fromDate;
//    NSDate *toDate;
//    
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    
//    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
//                 interval:NULL forDate:fromDateTime];
//    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
//                 interval:NULL forDate:toDateTime];
//    
//    NSDateComponents *difference = [calendar components:NSCalendarUnitMinute fromDate:fromDate toDate:toDate options:0];
    
    NSTimeInterval distanceBetweenDates = [fromDateTime timeIntervalSinceDate:toDateTime];
    int secondsInAnHour = 3600;
    NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
//    
    return hoursBetweenDates;
}

-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *fname = [defaults objectForKey:@"fname"];
    NSString *lname = [defaults objectForKey:@"lname"];
    
    if([fname length] > 0)
    {
        [lblName setText:[NSString stringWithFormat:@"Welcome: %@ %@",fname,lname]];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:appDelegate.deviceDateFormat];
    
    NSString *currentDate = [formatter stringFromDate:[NSDate date]];
    
    
    if ([appDelegate.cycleStartDate length] > 0)
    {
        int days = [appDelegate calculateDays:currentDate SecondDate:appDelegate.cycleIVFStartDate Format:appDelegate.deviceDateFormat];
        
        NSString *str = @"";
        NSString *daysStr = @"";
        
        if (days > 0)
        {
            if (days == 1)
                str = @"day left";
            else
                str = @"days left";
            
            [lblDays setFont:[UIFont systemFontOfSize:50.0]];
            [lblDaysText setFont:[UIFont systemFontOfSize:20.0]];
            daysStr = [NSString stringWithFormat:@"%i",days];
        }
        else
        {
            days = [appDelegate calculateDays:appDelegate.cycleIVFStartDate SecondDate:currentDate Format:appDelegate.deviceDateFormat];
            
            int endDays = [appDelegate calculateDays:currentDate SecondDate:appDelegate.cycleIVFEndDate Format:appDelegate.deviceDateFormat];
            
            if (days >= 0 && endDays >= 0)
            {
                daysStr = @"Day";
                str = [NSString stringWithFormat:@"%i",days+1];
                [lblDays setFont:[UIFont systemFontOfSize:30.0]];
                [lblDaysText setFont:[UIFont systemFontOfSize:40.0]];
            }
            else
            {
                days = 0;
                str = @"Cycle is over";
                daysStr = @"";
                 [lblDaysText setFont:[UIFont systemFontOfSize:20.0]];
            }
        }
        
        [lblDaysText setText:str];
        lblDays.text = daysStr;
    }
    else
    {
        medBtn.enabled = FALSE;
        apptBtn.enabled = FALSE;
        medBtn1.enabled = FALSE;
        apptBtn1.enabled = FALSE;
        profileBtn.enabled = FALSE;
        noteBtn.enabled = FALSE;
        calBtn.enabled = FALSE;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)slideButton:(UIButton*)btn ImageView:(UIImageView*)imgView XPosition:(float)xPos YPosition:(float)YPos
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationDuration:0.35f];
    [btn setCenter:CGPointMake(xPos, YPos)];
    [UIView setAnimationDuration:0.55f];
    [imgView setAlpha:1];
    [UIView commitAnimations];
}

-(IBAction)settingsBtnAction:(id)sender
{
    SettingsViewController *settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self.navigationController pushViewController:settingsVC animated:YES];
}

-(IBAction)medBtnAction:(UIButton*)button
{
    MedicationsViewController *medVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MedicationsViewController"];
    if (button.tag == 1001)
        medVC.medSelected = TRUE;
    else
        medVC.medSelected = FALSE;
    medVC.queryIndicator = @"On going Dosage";
    [self.navigationController pushViewController:medVC animated:NO];
}

-(IBAction)menuBtnAction:(UIButton*)button
{
    if (button.tag == 1003)
    {
        CycleViewController *cycleVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CycleViewController"];
        [self.navigationController pushViewController:cycleVC animated:NO];
    }
    else if (button.tag == 1002 || button.tag == 1004)
    {
        MedicationsViewController *medVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MedicationsViewController"];
        if (button.tag == 1003)
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
