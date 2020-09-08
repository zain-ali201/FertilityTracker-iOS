//
//  CalendarViewController.m
//  Fertility IVF
//
//  Created by Tconnect on 12/29/14.
//  Copyright (c) 2014 Tconnect. All rights reserved.
//

#import "CalendarViewController.h"
#import "MyCommonFunctions.h"
#import "AddAppointmentViewController.h"
#import "AddMedicationViewController.h"

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appDelegate = (AppDelegate*) [[UIApplication sharedApplication]delegate];
    
    cellWidth = 43.5;
    cellHeight = 63.0;
    
    calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents *dateParts = [calendar components:unitFlags fromDate:[NSDate date]];
    currentMonth = [dateParts month];
    currentYear = [dateParts year];
    
    [listView setCenter:CGPointMake(self.view.center.x, self.view.frame.size.height*2)];
    [self.view addSubview:listView];
    [self.view bringSubviewToFront:listView];
    
    medSelected = FALSE;
    lblNoRecord.hidden = YES;
    
    increment = TRUE;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self updateCalendarForMonth:currentMonth forYear:currentYear];
    [self fillMainScrollView:selectedDate];
}

-(IBAction)backBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)drawDayButtons
{
    dayButtons = [[NSMutableArray alloc] initWithCapacity:42];
    float YPosition = 0;
    for (int i = 0; i < 6; i++)
    {
        float XPosition = 0;
        for(int j = 0; j < 7; j++)
        {
            CGRect buttonFrame = CGRectMake(XPosition, YPosition, cellWidth, cellHeight);
            DayButton *dayButton = [[DayButton alloc] buttonWithFrame:buttonFrame];
            //[dayButton setBackgroundColor:[UIColor blackColor]];
            dayButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
            
            dayButton.delegate = self;
            
            [dayButtons addObject:dayButton];
            
            [calenderView addSubview:[dayButtons lastObject]];
            
            XPosition += 43.5;
        }
        YPosition += 63.0;
    }
}

- (void)updateCalendarForMonth:(int)month forYear:(int)year
{
    for (UIView *view in calenderView.subviews)
        [view removeFromSuperview];
        
    [self drawDayButtons];
    
    char *months[12] = {"January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"};
    lblMonth.text = [NSString stringWithFormat:@"%s %d", months[month - 1], year];
    
    //Get the first day of the month
    NSDateComponents *dateParts = [[NSDateComponents alloc] init];
    [dateParts setMonth:month];
    [dateParts setYear:year];
    [dateParts setDay:1];
    NSDate *dateOnFirst = [calendar dateFromComponents:dateParts];
    
    NSDateComponents *weekdayComponents = [calendar components:NSCalendarUnitWeekday fromDate:dateOnFirst];
    int weekdayOfFirst = [weekdayComponents weekday];
    
    if(weekdayOfFirst == 1) {
        weekdayOfFirst = 7;
    } else {
        --weekdayOfFirst;
    }
    
    int numDaysInMonth = [calendar rangeOfUnit:NSCalendarUnitDay
                                        inUnit:NSCalendarUnitMonth
                                       forDate:dateOnFirst].length;
    
    int day = 1;
    for (int i = 0; i < 6; i++)
    {
        for(int j = 0; j < 7; j++)
        {
            int buttonNumber = i * 7 + j;
            
            DayButton *button = [dayButtons objectAtIndex:buttonNumber];
            //calendarMedicationsArray = [[NSMutableArray alloc]initWithArray:button.medicationsArray];
            
            button.enabled = NO; //Disable buttons by default
            [button setTitle:nil forState:UIControlStateNormal]; //Set title label text to nil by default
            [button setButtonDate:nil];
            
            if(buttonNumber >= (weekdayOfFirst - 1) && day <= numDaysInMonth) {
                [button setTitle:[NSString stringWithFormat:@"%d", day]
                        forState:UIControlStateNormal];
                
                NSDateComponents *dateParts = [[NSDateComponents alloc] init];
                [dateParts setMonth:month];
                [dateParts setYear:year];
                [dateParts setDay:day];
                NSDate *buttonDate = [calendar dateFromComponents:dateParts];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"MM/dd/yyyy"];
                
                NSDate *currentDate = [NSDate date];
                
                NSString *buttonDateStr = [dateFormatter stringFromDate:buttonDate];
                
                NSString *currentDateStr = [dateFormatter stringFromDate:currentDate];
                
                if([buttonDateStr isEqualToString:currentDateStr])
                {
                    CGRect circleImgViewFrame = CGRectMake(button.center.x-12, button.center.y-12, 23, 23);
                    UIImageView *imgView = [[UIImageView alloc]initWithFrame:circleImgViewFrame];
                    [imgView setImage:[UIImage imageNamed:@"select_date_circle.png"]];
                    [calenderView addSubview:imgView];
                }
                
                BOOL medExists = FALSE;
                
                /*************Medications**************/
                
                NSString *strQuery = [NSString stringWithFormat:@"select * from Medications where '%@' between start_date and end_date",[dateFormatter stringFromDate:buttonDate]];
                
                sqlite3_stmt *ReturnStatement = (sqlite3_stmt *) [MyCommonFunctions getStatement: strQuery];
                {
                    while(sqlite3_step(ReturnStatement) == SQLITE_ROW)
                    {
                        int medID = [((char *)sqlite3_column_text(ReturnStatement, 0)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 0)] : @"" intValue];
                        
                        NSString *startDateStr = ((char *)sqlite3_column_text(ReturnStatement, 10)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 10)] : @"";
                        
                        NSString *endDate = ((char *)sqlite3_column_text(ReturnStatement, 11)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 11)] : @"";
                        
                        int freqID = [((char *)sqlite3_column_text(ReturnStatement, 12)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 12)] : @"" intValue];
                        
                        int freqChildID = [((char *)sqlite3_column_text(ReturnStatement, 13)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 13)] : @"" intValue];
                        
                        NSString *lastCalDateStr = ((char *)sqlite3_column_text(ReturnStatement, 15)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 15)] : @"";
                        
                        
                        
                        MedicationDetail *medDetail = [[MedicationDetail alloc]init];
                        
                        medDetail.medID = medID;
                        medDetail.startDate = [appDelegate formatDate:startDateStr Format:@"MM/dd/yyyy" ToFormat:appDelegate.deviceDateFormat];
                        medDetail.endDate = [appDelegate formatDate:endDate Format:@"MM/dd/yyyy" ToFormat:appDelegate.deviceDateFormat];
                        
                        FrequencyDetail *freqDetail = [[FrequencyDetail alloc]init];
                        freqDetail.freqID = freqID;
                        freqDetail.childFreqID = freqChildID;
                        
                        medDetail.freqDetail = freqDetail;
                        
                        NSDate *startDate = [dateFormatter dateFromString:startDateStr];
                        NSDate *lastCalDate = [dateFormatter dateFromString:lastCalDateStr];
                        
                        NSDateComponents *buttonDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:buttonDate];
                        
                        NSDateComponents *startDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:startDate];
                        
                        NSDateComponents *lastCalDateComponents = nil;
                        
                        if (lastCalDate != nil) {
                           lastCalDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:lastCalDate];
                        }
                        
                        NSCalendar *cal = [NSCalendar currentCalendar];
                        
                        if (freqID == 1)
                        {
                            medExists = TRUE;
                        }
                        else if (freqID == 2)
                        {
                            if (increment)
                            {
                                NSDate *date = nil;
                                
                                NSLog(@"medDetail.medID : %i",medDetail.medID);
                                
                                if ([[dateFormatter stringFromDate:buttonDate] isEqualToString:startDateStr])
                                {
                                    //NSDate *date = [cal dateByAddingUnit:NSCalendarUnitWeekOfMonth value:0 toDate:startDate options:0];
                                    medExists = TRUE;
                                    [self updateLastCalDate:startDateStr MedID:medDetail.medID];
                                    
                                }
                                else if (lastCalDate != nil) {
                                    
                                    date = [cal dateByAddingUnit:NSCalendarUnitWeekOfMonth value:1 toDate:lastCalDate options:0];
                                }
                                
                                if ([[dateFormatter stringFromDate:buttonDate] isEqualToString:[dateFormatter stringFromDate:date]])
                                {
                                    medExists = TRUE;
                                    
                                    [self updateLastCalDate:[appDelegate formatDate:date ToFormat:@"MM/dd/yyyy"] MedID:medDetail.medID];
                                }
                            }
                            else
                            {
                                 int weeksCount = [appDelegate calculateWeeks:[appDelegate formatDate:buttonDate ToFormat:@"MM/dd/yyyy"] SecondDate:lastCalDateStr Format:@"MM/dd/yyyy"];
                                
                                NSDate *date = [cal dateByAddingUnit:NSCalendarUnitWeekOfMonth value:-weeksCount toDate:lastCalDate options:0];
                                
                                 if ([[dateFormatter stringFromDate:buttonDate] isEqualToString:[dateFormatter stringFromDate:date]])
                                 {
                                     medExists = TRUE;
                                     
                                     [self updateLastCalDate:[appDelegate formatDate:date ToFormat:@"MM/dd/yyyy"] MedID:medDetail.medID];
                                 }
                            }
                            
                        }
                        else if (freqID == 3)
                        {
                            NSInteger buttonDateMonth = [buttonDateComponents month];
                            NSInteger startDateMonth = [startDateComponents month];
                            
                            int monthInterval = 0;
                            
                            if (buttonDateMonth > startDateMonth)
                            {
                                monthInterval = buttonDateMonth - startDateMonth;
                            }
                            
                            NSDate *date = [cal dateByAddingUnit:NSCalendarUnitMonth value:monthInterval toDate:startDate options:0];
                            
                            if ([[dateFormatter stringFromDate:buttonDate] isEqualToString:[dateFormatter stringFromDate:date]])
                            {
                                medExists = TRUE;
                            }
                        }
                        else if (freqID == 4)
                        {
                            medExists = TRUE;
                        }
                        else if (freqID == 5)
                        {
                            if (increment)
                            {
                                NSDate *date = nil;
                                
                                if ([[dateFormatter stringFromDate:buttonDate] isEqualToString:startDateStr])
                                {
                                    //NSDate *date = [cal dateByAddingUnit:NSCalendarUnitWeekOfMonth value:0 toDate:startDate options:0];
                                    medExists = TRUE;
                                    [self updateLastCalDate:startDateStr MedID:medDetail.medID];
                                    
                                }
                                else if (lastCalDate != nil) {
                                    int value = 0;
                                    
                                    //if ([buttonDateComponents weekOfMonth] != [lastCalDateComponents weekOfMonth])
                                    {
                                        if (increment)
                                            value = freqChildID;
                                        else
                                        {
                                            value = -freqChildID;
                                        }
                                    }
                                    
                                    date = [cal dateByAddingUnit:NSCalendarUnitDay value:freqChildID toDate:lastCalDate options:0];
                                }
                                
                                if ([[dateFormatter stringFromDate:buttonDate] isEqualToString:[dateFormatter stringFromDate:date]])
                                {
                                    medExists = TRUE;
                                    
                                    [self updateLastCalDate:[appDelegate formatDate:date ToFormat:@"MM/dd/yyyy"] MedID:medDetail.medID];
                                }
                            }
                            else
                            {
                                int daysCount = [appDelegate calculateDays:[appDelegate formatDate:buttonDate ToFormat:@"MM/dd/yyyy"] SecondDate:lastCalDateStr Format:@"MM/dd/yyyy"];
                                
                                if (daysCount%freqChildID == 0)
                                {
                                    NSDate *date = [cal dateByAddingUnit:NSCalendarUnitDay value:-daysCount toDate:lastCalDate options:0];
                                    
                                    if ([[dateFormatter stringFromDate:buttonDate] isEqualToString:[dateFormatter stringFromDate:date]])
                                    {
                                        medExists = TRUE;
                                        
                                        [self updateLastCalDate:[appDelegate formatDate:date ToFormat:@"MM/dd/yyyy"] MedID:medDetail.medID];
                                        increment = TRUE;
                                    }
                                }
                            }
                        }
                        else if (freqID == 6)
                        {
                            if (increment)
                            {
                                NSDate *date = nil;
                                
                                NSLog(@"medDetail.medID : %i",medDetail.medID);
                                
                                if ([[dateFormatter stringFromDate:buttonDate] isEqualToString:startDateStr])
                                {
                                    //NSDate *date = [cal dateByAddingUnit:NSCalendarUnitWeekOfMonth value:0 toDate:startDate options:0];
                                    medExists = TRUE;
                                    [self updateLastCalDate:startDateStr MedID:medDetail.medID];
                                    
                                }
                                else if (lastCalDate != nil) {
                                    
                                    date = [cal dateByAddingUnit:NSCalendarUnitWeekOfMonth value:freqChildID toDate:lastCalDate options:0];
                                }
                                
                                if ([[dateFormatter stringFromDate:buttonDate] isEqualToString:[dateFormatter stringFromDate:date]])
                                {
                                    medExists = TRUE;
                                    
                                    [self updateLastCalDate:[appDelegate formatDate:date ToFormat:@"MM/dd/yyyy"] MedID:medDetail.medID];
                                }
                            }
                            else
                            {
                                int weeksCount = [appDelegate calculateWeeks:[appDelegate formatDate:buttonDate ToFormat:@"MM/dd/yyyy"] SecondDate:lastCalDateStr Format:@"MM/dd/yyyy"];
                                
                                if (weeksCount%freqChildID == 0)
                                {
                                    NSDate *date = [cal dateByAddingUnit:NSCalendarUnitWeekOfMonth value:-weeksCount toDate:lastCalDate options:0];
                                    
                                    if ([[dateFormatter stringFromDate:buttonDate] isEqualToString:[dateFormatter stringFromDate:date]])
                                    {
                                        medExists = TRUE;
                                        
                                        [self updateLastCalDate:[appDelegate formatDate:date ToFormat:@"MM/dd/yyyy"] MedID:medDetail.medID];
                                        increment = TRUE;
                                    }
                                }
                            }
                        }
                        else if (freqID == 7)
                        {
                            NSDate *date = nil;
                            
                            if ([[dateFormatter stringFromDate:buttonDate] isEqualToString:startDateStr])
                            {
                                //NSDate *date = [cal dateByAddingUnit:NSCalendarUnitWeekOfMonth value:0 toDate:startDate options:0];
                                medExists = TRUE;
                                [self updateLastCalDate:startDateStr MedID:medDetail.medID];
                                
                            }
                            else if (lastCalDate != nil) {
                                int value = 0;
                                if ([buttonDateComponents month] != [lastCalDateComponents month])
                                {
                                    if (increment)
                                        value = freqChildID;
                                    else
                                    {
                                        value = -freqChildID;
                                    }
                                }
                                
                                date = [cal dateByAddingUnit:NSCalendarUnitMonth value:value toDate:lastCalDate options:0];
                            }
                            
                            if ([[dateFormatter stringFromDate:buttonDate] isEqualToString:[dateFormatter stringFromDate:date]])
                            {
                                medExists = TRUE;
                                
                                [self updateLastCalDate:[appDelegate formatDate:date ToFormat:@"MM/dd/yyyy"] MedID:medDetail.medID];
                            }
                        }
                        
                        if (medExists)
                        {
                            button.enabled = YES;
                            CGRect medImgViewFrame = CGRectMake(button.center.x-19, button.center.y+13, 16, 15);
                            
                            UIImageView *imgView = [[UIImageView alloc]initWithFrame:medImgViewFrame];
                            [imgView setImage:[UIImage imageNamed:@"tablet.png"]];
                            
                            [calenderView addSubview:imgView];
                        }
                    }
                }

                /**************************************/
                
                BOOL apptExists = [MyCommonFunctions itemExistsInDatabase:@"Appointments" FieldName:@"start_date" Value:[dateFormatter stringFromDate:buttonDate]];
                
                if (apptExists)
                {
                    button.enabled = YES;
                    
                    CGRect apptImgViewFrame = CGRectMake(button.center.x+5, button.center.y+13, 14, 15);
                    
                    UIImageView *imgView = [[UIImageView alloc]initWithFrame:apptImgViewFrame];
                    [imgView setImage:[UIImage imageNamed:@"doc.png"]];
                    
                    [calenderView addSubview:imgView];
                }
                
                BOOL noteExists = [MyCommonFunctions itemExistsInDatabase:@"Notes" FieldName:@"note_date" Value:[dateFormatter stringFromDate:buttonDate]];
                
                if (noteExists)
                {
                    //button.enabled = YES;
                    
                    CGRect apptImgViewFrame = CGRectMake(button.center.x-19, button.center.y-27, 16, 15);
                    
                    UIImageView *imgView = [[UIImageView alloc]initWithFrame:apptImgViewFrame];
                    [imgView setImage:[UIImage imageNamed:@"not.png"]];
                    
                    [calenderView addSubview:imgView];
                    
                }
                
                [calenderView bringSubviewToFront:button];
                
                [button setButtonDate:buttonDate];
                ++day;
            }
        }
    }
}

-(BOOL)updateLastCalDate:(NSString*)date MedID:(int)medID
{
    NSString *queryString = [NSString stringWithFormat:@"update Medications set last_cal_date = '%@' where id=%i;",date,medID];
    
    return [MyCommonFunctions InsUpdateDelData:queryString];
}

- (IBAction)prevBtnPressed:(id)sender {
    increment = FALSE;
    if(currentMonth == 1) {
        currentMonth = 12;
        --currentYear;
    } else {
        --currentMonth;
    }

    [self updateCalendarForMonth:currentMonth forYear:currentYear];

}

- (IBAction)nextBtnPressed:(id)sender {
    increment = TRUE;
    if(currentMonth == 12) {
        currentMonth = 1;
        ++currentYear;
    } else {
        ++currentMonth;
    }
    
    [self updateCalendarForMonth:currentMonth forYear:currentYear];

}

- (void)dayButtonPressed:(DayButton *)button {
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
//    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
//    NSString *theDate = [dateFormatter stringFromDate:button.buttonDate];
//    
//    UIAlertView *dateAlert = [[UIAlertView alloc]
//                              initWithTitle:@"Date Pressed"
//                              message:theDate
//                              delegate:self
//                              cancelButtonTitle:@"Ok"
//                              otherButtonTitles:nil];
//    [dateAlert show];
    
    BOOL medExists = [MyCommonFunctions itemExistsInDatabase:@"Medications" Value:[appDelegate formatDate:button.buttonDate ToFormat:@"MM/dd/yyyy"]];
    
    if(medExists)
        medSelected = TRUE;
    else
        medSelected = FALSE;
    
    lblMain.text = [appDelegate formatDate:button.buttonDate ToFormat:@"MMMM dd, yyyy"];
    
    selectedDate = button.buttonDate;
    [self fillMainScrollView:selectedDate];
    [self jumpAnimationForView:listView toPoint:CGPointMake(self.view.center.x, self.view.center.y)];
    
}

#pragma mark - List Functions

-(IBAction)clickBtnAction:(UIButton*)button
{
    if (button.tag == 1001)
    {
        medSelected = TRUE;
    }
    else
    {
        medSelected = FALSE;
    }
    
    [self fillMainScrollView:selectedDate];
}

-(IBAction)cancelBtnAction:(id)sender
{
    [self jumpAnimationForView:listView toPoint:CGPointMake(self.view.center.x, self.view.frame.size.height*2)];
    
}

-(void)getListRecords:(NSDate*)date
{
    medicationsArray = [[NSMutableArray alloc]init];
    
    if (medSelected)
    {
        [medBtn setImage:[UIImage imageNamed:@"medication_on.png"] forState:UIControlStateNormal];
        [apptBtn setImage:[UIImage imageNamed:@"appointment_off.png"] forState:UIControlStateNormal];
        
        NSString *quesryStr = [NSString stringWithFormat:@"select * from Medications where '%@' between start_date and end_date",[appDelegate formatDate:date ToFormat:@"MM/dd/yyyy"]];
        
        sqlite3_stmt *ReturnStatement = (sqlite3_stmt *) [MyCommonFunctions getStatement:quesryStr];
        {
            while(sqlite3_step(ReturnStatement) == SQLITE_ROW)
            {
                NSString *medID = ((char *)sqlite3_column_text(ReturnStatement, 0)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 0)] : @"";
                
                NSString *medName = ((char *)sqlite3_column_text(ReturnStatement, 2)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 2)] : @"";
                
                NSString *strength = ((char *)sqlite3_column_text(ReturnStatement, 3)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 3)] : @"";
                
                NSString *notes = ((char *)sqlite3_column_text(ReturnStatement, 4)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 4)] : @"";
                
                NSString *personName = ((char *)sqlite3_column_text(ReturnStatement, 5)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 5)] : @"";
                
                NSString *reminderStatus = ((char *)sqlite3_column_text(ReturnStatement, 6)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 6)] : @"";
                
                NSString *dose = ((char *)sqlite3_column_text(ReturnStatement, 7)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 7)] : @"";
                
                NSString *frequency = ((char *)sqlite3_column_text(ReturnStatement, 8)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 8)] : @"";
                
                NSString *time = ((char *)sqlite3_column_text(ReturnStatement, 9)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 9)] : @"";
                
                NSString *startDate = ((char *)sqlite3_column_text(ReturnStatement, 10)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 10)] : @"";
                
                NSString *endDate = ((char *)sqlite3_column_text(ReturnStatement, 11)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 11)] : @"";
                
                NSString *freqID = ((char *)sqlite3_column_text(ReturnStatement, 12)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 12)] : @"";
                
                NSString *freqChildID = ((char *)sqlite3_column_text(ReturnStatement, 13)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 13)] : @"";
                
                NSString *freqChildTitle = ((char *)sqlite3_column_text(ReturnStatement, 14)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 14)] : @"";
                
                
                MedicationDetail *medDetail = [[MedicationDetail alloc]init];
                
                medDetail.medID = [medID intValue];
                medDetail.medName = medName;
                medDetail.strength = strength;
                medDetail.notes = notes;
                medDetail.personName = personName;
                medDetail.reminderStatus = [reminderStatus boolValue];
                medDetail.dose = dose;
                medDetail.time = time;
                medDetail.startDate = [appDelegate formatDate:startDate Format:@"MM/dd/yyyy" ToFormat:appDelegate.deviceDateFormat];
                medDetail.endDate = [appDelegate formatDate:endDate Format:@"MM/dd/yyyy" ToFormat:appDelegate.deviceDateFormat];
                
                FrequencyDetail *freqDetail = [[FrequencyDetail alloc]init];
                freqDetail.title = frequency;
                freqDetail.freqID = [freqID intValue];
                freqDetail.childFreqID = [freqChildID intValue];
                freqDetail.childTitle = freqChildTitle;
                
                medDetail.freqDetail = freqDetail;
                
                [medicationsArray addObject:medDetail];
            }
        }
    }
    else
    {
        [apptBtn setImage:[UIImage imageNamed:@"appointment_on.png"] forState:UIControlStateNormal];
        [medBtn setImage:[UIImage imageNamed:@"medication_off.png"] forState:UIControlStateNormal];
        
        NSString *quesryStr = [NSString stringWithFormat:@"select * from Appointments where start_date='%@'",[appDelegate formatDate:date ToFormat:@"MM/dd/yyyy"]];
        
        sqlite3_stmt *ReturnStatement = (sqlite3_stmt *) [MyCommonFunctions getStatement:quesryStr];
        {
            while(sqlite3_step(ReturnStatement) == SQLITE_ROW)
            {
                NSString *apptID = ((char *)sqlite3_column_text(ReturnStatement, 0)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 0)] : @"";
                
                NSString *apptName = ((char *)sqlite3_column_text(ReturnStatement, 2)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 2)] : @"";
                
                NSString *notes = ((char *)sqlite3_column_text(ReturnStatement, 3)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 3)] : @"";
                
                NSString *reminderStatus = ((char *)sqlite3_column_text(ReturnStatement, 4)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 4)] : @"";
                
                NSString *time = ((char *)sqlite3_column_text(ReturnStatement, 5)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 5)] : @"";
                
                NSString *startDate = ((char *)sqlite3_column_text(ReturnStatement, 6)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 6)] : @"";
                
                NSString *endDate = ((char *)sqlite3_column_text(ReturnStatement, 7)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 7)] : @"";
                
                MedicationDetail *medDetail = [[MedicationDetail alloc]init];
                
                medDetail.medID = [apptID intValue];
                medDetail.medName = apptName;
                medDetail.notes = notes;
                medDetail.reminderStatus = [reminderStatus boolValue];
                medDetail.time = time;
                medDetail.startDate = [appDelegate formatDate:startDate Format:@"MM/dd/yyyy" ToFormat:appDelegate.deviceDateFormat];
                medDetail.endDate = endDate;
                
                [medicationsArray addObject:medDetail];
            }
        }
    }
}

-(void)fillMainScrollView:(NSDate*)date
{
    for (UIView *view in mainScrollView.subviews)
        [view removeFromSuperview];
    
    
    [self getListRecords:date];
    
    if (medicationsArray.count > 0)
    {
        lblNoRecord.hidden = YES;
        
        float YAxis = 0.0;
        
        float lblNameYPosition = 0;
        NSString *imgName;
        
        if(medSelected)
        {
            lblNameYPosition = 8.0;
            imgName = @"capsule_tablet.png";
        }
        else
        {
            lblNameYPosition = 15.0;
            imgName = @"doct_button.png";
        }
        
        for (int i = 0; i < medicationsArray.count; i++)
        {
            MedicationDetail *medDetail = [medicationsArray objectAtIndex:i];
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, YAxis, 306.0, 50.0)];
            
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(7.0, 8.0, 37.0, 33.0)];
            [imgView setImage:[UIImage imageNamed:imgName]];
            
            UILabel *lblName = [[UILabel alloc]initWithFrame:CGRectMake(52.0, lblNameYPosition, 200.0, 17.0)];
            [lblName setBackgroundColor:[UIColor clearColor]];
            [lblName setFont:[UIFont systemFontOfSize:13.0]];
            [lblName setTextColor:[UIColor colorWithRed:137.0/255.0 green:80.0/255.0 blue:125.0/255.0 alpha:1]];
            [lblName setText:medDetail.medName];
            
            UILabel *lblFrequency = [[UILabel alloc]initWithFrame:CGRectMake(52.0, 22.0, 200.0, 17.0)];
            [lblFrequency setBackgroundColor:[UIColor clearColor]];
            [lblFrequency setFont:[UIFont systemFontOfSize:12.0]];
            [lblFrequency setTextColor:[UIColor colorWithRed:1.0 green:143.0/255.0 blue:208.0/255.0 alpha:1]];
            [lblFrequency setText:medDetail.freqDetail.childFreqID>0?medDetail.freqDetail.childTitle:medDetail.freqDetail.title];
            
            
            UILabel *lblTime = [[UILabel alloc]initWithFrame:CGRectMake(220.0, 17.0, 70.0, 17.0)];
            [lblTime setBackgroundColor:[UIColor clearColor]];
            [lblTime setFont:[UIFont systemFontOfSize:12.0]];
            [lblTime setTextColor:[UIColor colorWithRed:0 green:174.0/255.0 blue:239.0/255.0 alpha:1]];
            [lblTime setText:medDetail.time];
            
            UIImageView *arrowImgView = [[UIImageView alloc]initWithFrame:CGRectMake(282.0, 15.0, 11.0, 20.0)];
            [arrowImgView setImage:[UIImage imageNamed:@"right_arrow.png"]];
            
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 306.0, 50.0)];
            btn.tag  = i + 1000;
            
            
            
            UIImageView *lineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(7.0, 49.0, 287.0, 1.0)];
            [lineImgView setImage:[UIImage imageNamed:@"line.png"]];
            
            [view addSubview:imgView];
            [view addSubview:lblName];
            
            if(medSelected)
            {
                [view addSubview:lblFrequency];
                [btn addTarget:self action:@selector(medDetailBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                [btn addTarget:self action:@selector(apptDetailBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [view addSubview:lblTime];
            [view addSubview:arrowImgView];
            [view addSubview:btn];
            [view addSubview:lineImgView];
            
            [mainScrollView addSubview:view];
            
            YAxis += 50.0;
        }
        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, YAxis)];
    }
    else
    {
        lblNoRecord.hidden = NO;
    }
}

-(IBAction)medDetailBtnAction:(UIButton*)button
{
    NSString *viewName = [appDelegate CheckDevice:@"AddMedicationViewController" iPhone5:@"AddMedicationViewControllerIphone5" iPAD:@""];
    AddMedicationViewController *addMedVC = [[AddMedicationViewController alloc]initWithNibName:viewName bundle:[NSBundle mainBundle]];
    addMedVC.reqForUpdate = TRUE;
    addMedVC.medDetail = [medicationsArray objectAtIndex:button.tag - 1000];
    [self.navigationController pushViewController:addMedVC animated:YES];
}

-(IBAction)apptDetailBtnAction:(UIButton*)button
{
    NSString *viewName = [appDelegate CheckDevice:@"AddAppointmentViewController" iPhone5:@"AddAppointmentViewControllerIphone5" iPAD:@""];
    AddAppointmentViewController *addApptVC = [[AddAppointmentViewController alloc]initWithNibName:viewName bundle:[NSBundle mainBundle]];
    addApptVC.reqForUpdate = TRUE;
    addApptVC.apptDetail = [medicationsArray objectAtIndex:button.tag - 1000];
    [self.navigationController pushViewController:addApptVC animated:YES];
}

-(void)jumpAnimationForView:(UIView*)animatedView toPoint:(CGPoint)point
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.7];
    [animatedView setCenter:point];
    [UIView commitAnimations];
    
}

@end
