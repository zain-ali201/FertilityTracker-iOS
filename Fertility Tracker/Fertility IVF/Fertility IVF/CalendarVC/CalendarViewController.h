//
//  CalendarViewController.h
//  Fertility IVF
//
//  Created by Tconnect on 12/29/14.
//  Copyright (c) 2014 Tconnect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DayButton.h"

@interface CalendarViewController : UIViewController<DayButtonDelegate>
{
    AppDelegate *appDelegate;
    
    IBOutlet UIView *calenderView;
    IBOutlet UILabel *lblMonth;
    IBOutlet UIImageView *bgImgView;
    IBOutlet UIImageView *bgImgView1;
    
    NSMutableArray *dayButtons;
    NSCalendar *calendar;
    
    /**********List Outlets***********/
    
    IBOutlet UILabel *lblMain;
    IBOutlet UIView *listView;
    IBOutlet UIButton *medBtn;
    IBOutlet UIButton *apptBtn;
    IBOutlet UILabel *lblNoRecord;
    
    IBOutlet UIScrollView *mainScrollView;
    NSMutableArray *medicationsArray;
    NSMutableArray *calendarMedicationsArray;
    NSDate *selectedDate;
    
    /*********************************/
    
    float cellWidth;
    float cellHeight;
    int currentMonth;
    int currentYear;
    
    BOOL medSelected;
    BOOL increment;
}

@end
