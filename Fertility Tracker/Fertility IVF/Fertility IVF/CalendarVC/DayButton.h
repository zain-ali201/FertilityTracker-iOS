//
//  DayButton.h
//  Fertility IVF
//
//  Created by Tconnect on 12/29/14.
//  Copyright (c) 2014 Tconnect. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MedicationDetail.h"

@protocol DayButtonDelegate <NSObject>
- (void)dayButtonPressed:(id)sender;
@end

@interface DayButton : UIButton {
	id <DayButtonDelegate> delegate;
	NSDate *buttonDate;
}

@property (nonatomic, assign) id <DayButtonDelegate> delegate;
@property (nonatomic, copy) NSDate *buttonDate;
@property (nonatomic,retain) NSMutableArray *medicationsArray;
@property BOOL isFirstTime;

- (id)buttonWithFrame:(CGRect)buttonFrame;

@end
