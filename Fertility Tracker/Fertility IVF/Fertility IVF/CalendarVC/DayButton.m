//
//  DayButton.m
//  Fertility IVF
//
//  Created by Tconnect on 12/29/14.
//  Copyright (c) 2014 Tconnect. All rights reserved.
//

#import "DayButton.h"


@implementation DayButton
@synthesize delegate, buttonDate, medicationsArray;

- (id)buttonWithFrame:(CGRect)buttonFrame {
	self = [DayButton buttonWithType:UIButtonTypeCustom];
	
	self.frame = buttonFrame;
	self.titleLabel.textAlignment = NSTextAlignmentCenter;
	self.backgroundColor = [UIColor clearColor];
	[self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	[self addTarget:delegate action:@selector(dayButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	return self;
}

@end
