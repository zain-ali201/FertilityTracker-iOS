//
//  FrequencyViewController.h
//  Fertility IVF
//
//  Created by Zain Ali on 1/7/15.
//  Copyright (c) 2015 Tconnect. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "FrequencyDetail.h"

@interface FrequencyViewController : UIViewController
{
    AppDelegate *appDelegate;
    
    IBOutlet UIScrollView *mainScrollView;
    
    NSMutableArray *frequencyChildArray;
}
@property(nonatomic,retain) FrequencyDetail *detail;

@end
