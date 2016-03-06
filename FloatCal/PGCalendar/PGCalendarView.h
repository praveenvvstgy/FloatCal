//
//  PGCalendarView.h
//  FloatCal
//
//  Created by Praveen Gowda I V on 1/24/16.
//  Copyright © 2016 Praveen Gowda I V. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol PGCalendarViewDelegate <NSObject>

- (void) didSelectDate:(NSDate*)selectedDate;

@end

@interface PGCalendarView : NSViewController

@property (nonatomic, copy) NSColor* backgroundColor;
@property (nonatomic, copy) NSColor* textColor;
@property (nonatomic, copy) NSColor* selectionColor;
@property (nonatomic, copy) NSColor* selectedTextColor;
@property (nonatomic, copy) NSColor* todayMarkerColor;
@property (nonatomic, copy) NSColor* dayMarkerColor;

@property (nonatomic, weak) id<PGCalendarViewDelegate> delegate;

@property (nonatomic, strong) NSDate* date;
@property (nonatomic, strong) NSDate* selectedDate;

+ (BOOL) isSameDate:(NSDate*)d1 date:(NSDate*)d2;

@end
