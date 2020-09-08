//
//  MedicationsViewController.m
//  Fertility IVF
//
//  Created by Tconnect on 12/16/14.
//  Copyright (c) 2014 Tconnect. All rights reserved.
//

#import "MedicationsViewController.h"
#import "AddMedicationViewController.h"
#import "AddAppointmentViewController.h"
#import "MyCommonFunctions.h"
#import "MedicationDetail.h"
#import "CalendarViewController.h"
#import "CycleViewController.h"
#import "HomeViewController.h"
#import "NotesViewController.h"

@implementation MedicationsViewController

@synthesize medSelected,queryIndicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    lblNoRecord.hidden = YES;
    
    if(medSelected)
    {
        categoriesArray = [[NSArray alloc]initWithObjects:@"On going Dosage",@"Completed",@"All", nil];
        lblCategories.text = @"On going Dosage";
    }
    else
    {
        categoriesArray = [[NSArray alloc]initWithObjects:@"Upcoming Appointments",@"Completed",@"All", nil];
        lblCategories.text = @"Upcoming Appointments";
    }
    
    int device = [appDelegate CheckDevice];
    
    if (device == 4)
    {
        pickerYPosition = 575.0;
        pickerYOpenPosition = 395.0;
       
    }
    else if(device == 5)
    {
        pickerYPosition = 672.0;
        pickerYOpenPosition = 483.0;
    }
    
    [pickerView setCenter:CGPointMake(self.view.center.x, pickerYPosition)];
    [self.view addSubview:pickerView];
    [self.view bringSubviewToFront:pickerView];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self fillMainScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)categroiesBtnAction:(id)sender
{
    [appDelegate jumpAnimationForView:pickerView toPoint:CGPointMake(self.view.center.x, pickerYOpenPosition)];
}

-(IBAction)pickerDoneBtnAction:(id)sender
{
    queryIndicator = [categoriesArray objectAtIndex:[picker selectedRowInComponent:0]];
    lblCategories.text = queryIndicator;
    [self fillMainScrollView];
    [self hidePickerViews];
}

-(IBAction)pickerCancelBtnAction:(id)sender
{
    [self hidePickerViews];
}

-(void)hidePickerViews
{
    [appDelegate jumpAnimationForView:pickerView toPoint:CGPointMake(self.view.center.x, pickerYPosition)];
}

-(void)getListRecords
{
    medicationsArray = [[NSMutableArray alloc]init];
    
    if ([queryIndicator isEqualToString:@"On going Dosage"] || [queryIndicator isEqualToString:@"Upcoming Appointments"])
    {
        medQueryString = [NSString stringWithFormat:@"select * from Medications where start_date <= '%@' and end_date <= '%@'", [appDelegate formatDate:[NSDate date] ToFormat:@"MM/dd/yyyy"], [appDelegate formatDate:appDelegate.cycleEndDate Format:appDelegate.deviceDateFormat ToFormat:@"MM/dd/yyyy"]];
        apptQueryString = [NSString stringWithFormat:@"select * from Appointments where start_date >= '%@'",[appDelegate formatDate:[NSDate date] ToFormat:@"MM/dd/yyyy"]];
    }
    else if ([queryIndicator isEqualToString:@"Completed"])
    {
        medQueryString = [NSString stringWithFormat:@"select * from Medications where end_date <= '%@'",[appDelegate formatDate:[NSDate date] ToFormat:@"MM/dd/yyyy"]];
        apptQueryString = [NSString stringWithFormat:@"select * from Appointments where start_date < '%@' and start_date!= ''",[appDelegate formatDate:[NSDate date] ToFormat:@"MM/dd/yyyy"]];
    }
    else if ([queryIndicator isEqualToString:@"All"])
    {
        medQueryString = @"select * from Medications";
        apptQueryString = @"select * from Appointments";
    }
    else if ([queryIndicator isEqualToString:@"date"])
    {
        medQueryString = @"select * from Medications";
        apptQueryString = @"select * from Appointments";
    }
    
    if (medSelected)
    {
        [medBtn setImage:[UIImage imageNamed:@"medication_on.png"] forState:UIControlStateNormal];
        [apptBtn setImage:[UIImage imageNamed:@"appointment_off.png"] forState:UIControlStateNormal];
        
        sqlite3_stmt *ReturnStatement = (sqlite3_stmt *) [MyCommonFunctions getStatement:medQueryString];
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
        
        sqlite3_stmt *ReturnStatement = (sqlite3_stmt *) [MyCommonFunctions getStatement:apptQueryString];
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

-(void)fillMainScrollView
{
    for (UIView *view in mainScrollView.subviews)
        [view removeFromSuperview];
    
    
    [self getListRecords];
    
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

-(IBAction)backbtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)addBtnAction:(id)sender
{
    if (medSelected)
    {
        NSString *viewName = [appDelegate CheckDevice:@"AddMedicationViewController" iPhone5:@"AddMedicationViewControllerIphone5" iPAD:@""];
        AddMedicationViewController *addMedVC = [[AddMedicationViewController alloc]initWithNibName:viewName bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:addMedVC animated:YES];
    }
    else
    {
        NSString *viewName = [appDelegate CheckDevice:@"AddAppointmentViewController" iPhone5:@"AddAppointmentViewControllerIphone5" iPAD:@""];
        AddAppointmentViewController *addApptVC = [[AddAppointmentViewController alloc]initWithNibName:viewName bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:addApptVC animated:YES];
    }
}

-(IBAction)calenderBtnAction:(id)sender
{
    NSString *viewName = [appDelegate CheckDevice:@"CalendarViewController" iPhone5:@"CalendarViewControllerIphone5" iPAD:@""];
    CalendarViewController *calendarVC = [[CalendarViewController alloc]initWithNibName:viewName bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:calendarVC animated:YES];
}

-(IBAction)clickBtnACtion:(UIButton*)button
{
    if (button.tag == 1001)
    {
        medSelected = TRUE;
        
        categoriesArray = [[NSArray alloc]initWithObjects:@"On going Dosage",@"Completed",@"All", nil];
        lblCategories.text = @"On going Dosage";
        [picker reloadAllComponents];
    }
    else
    {
        medSelected = FALSE;
        
        categoriesArray = [[NSArray alloc]initWithObjects:@"Upcoming Appointments",@"Completed",@"All", nil];
        lblCategories.text = @"Upcoming Appointments";
        [picker reloadAllComponents];
    }
    queryIndicator = @"On going Dosage";
    [self fillMainScrollView];
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
    else if (button.tag == 1003)
    {
        CycleViewController *cycleVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CycleViewController"];
        [self.navigationController pushViewController:cycleVC animated:NO];
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

#pragma mark- PickerView Delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return 3;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [categoriesArray objectAtIndex:row];
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}


@end
