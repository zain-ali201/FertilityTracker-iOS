//
//  MedicationDetail.h
//  Fertility IVF
//
//  Created by Tconnect on 12/23/14.
//  Copyright (c) 2014 Tconnect. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FrequencyDetail.h"

@interface MedicationDetail : NSObject

@property int medID;
@property(nonatomic,retain) NSString *medName;
@property(nonatomic,retain) NSString *strength;
@property(nonatomic,retain) NSString *notes;
@property(nonatomic,retain) NSString *personName;
@property int reminderStatus;
@property(nonatomic,retain) NSString *dose;
@property(nonatomic,retain) NSString *time;
@property(nonatomic,retain) NSString *startDate;
@property(nonatomic,retain) NSString *endDate;
@property(nonatomic,retain) FrequencyDetail *freqDetail;
@property int frequencyCount;
@property NSString *lastUpdatedDate;

@end
