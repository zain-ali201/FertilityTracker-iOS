//
//  MedicationDetail.m
//  Fertility IVF
//
//  Created by Tconnect on 12/23/14.
//  Copyright (c) 2014 Tconnect. All rights reserved.
//

#import "MedicationDetail.h"

@implementation MedicationDetail

@synthesize medID,medName,startDate,strength,endDate,reminderStatus,dose,notes,personName,time,freqDetail,frequencyCount,lastUpdatedDate;

-(void)dealloc
{
    medName = nil;
    startDate = nil;
    strength = nil;
    endDate = nil;
    dose = nil;
    notes = nil;
    personName = nil;
    time = nil;
    freqDetail = nil;
    lastUpdatedDate = nil;
}

@end
