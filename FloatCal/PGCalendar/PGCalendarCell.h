//
//  PGCalendarCell.h
//  FloatCal
//
//  Created by Praveen Gowda I V on 1/24/16.
//  Copyright © 2016 Praveen Gowda I V. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PGCalendarView;

@interface PGCalendarCell : NSButton

@property (weak) PGCalendarView* owner;
@property (nonatomic, strong) NSDate* representedDate;
@property (nonatomic) BOOL selected;

@end
