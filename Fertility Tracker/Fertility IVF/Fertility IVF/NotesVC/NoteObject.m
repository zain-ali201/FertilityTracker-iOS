//
//  NoteObject.m
//  Fertility IVF
//
//  Created by Zain Ali on 1/5/15.
//  Copyright (c) 2015 Tconnect. All rights reserved.
//

#import "NoteObject.h"

@implementation NoteObject

@synthesize noteID,descp,date;

-(void)dealloc
{
    descp = nil;
    date = nil;
}

@end
