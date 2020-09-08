//
//  MedicationsViewController.h
//  Fertility IVF
//
//  Created by Tconnect on 12/16/14.
//  Copyright (c) 2014 Tconnect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MedicationsViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>
{
    AppDelegate *appDelegate;
    
    IBOutlet UIButton *medBtn;
    IBOutlet UIButton *apptBtn;
    
    IBOutlet UIScrollView *mainScrollView;
    NSMutableArray *medicationsArray;
    
    IBOutlet UIView *pickerView;
    IBOutlet UIPickerView *picker;
    
    IBOutlet UILabel *lblCategories;
    IBOutlet UILabel *lblNoRecord;
    
    
    NSArray *categoriesArray;
    NSString *medQueryString;
    NSString *apptQueryString;
    NSString *queryIndicator;
    
    float pickerYPosition;
    float pickerYOpenPosition;
    
    BOOL medSelected;
}

@property BOOL medSelected;
@property(nonatomic,retain) NSString *queryIndicator;

@end
