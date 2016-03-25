//
//  PGCalendarCell.m
//  FloatCal
//
//  Created by Praveen Gowda I V on 1/24/16.
//  Copyright © 2016 Praveen Gowda I V. All rights reserved.
//


#import "PGCalendarCell.h"
#import "PGCalendarView.h"

@interface PGCalendarCell ()
- (void) commonInit;
- (BOOL) isToday;
@end

@implementation PGCalendarCell

- (instancetype)initWithFrame: (NSRect)frameRect
{
	self = [super initWithFrame: frameRect];
	if (self != nil) {
		[self commonInit];
	}
	
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
	self = [super initWithCoder:coder];
	if(self) {
		[self commonInit];
	}
	return self;
}

- (void) commonInit {
	self.bordered = NO;
	self.representedDate = nil;
}

- (BOOL) isToday {
	if(self.representedDate) {
		return 	[PGCalendarView isSameDate:self.representedDate date:[NSDate date]];
	} else {
		return NO;
	}
}

- (void) setSelected:(BOOL)selected {
	_selected = selected;
	self.needsDisplay = YES;
}

- (void) setRepresentedDate:(NSDate *)representedDate {
	_representedDate = representedDate;
	if(_representedDate) {
		NSCalendar *cal = [NSCalendar currentCalendar];
		cal.timeZone = [NSTimeZone localTimeZone];
		unsigned unitFlags = NSCalendarUnitDay;// | NSCalendarUnitYear | NSCalendarUnitMonth;
		NSDateComponents *components = [cal components:unitFlags fromDate:_representedDate];
		NSInteger day = components.day;
		self.title = [NSString stringWithFormat:@"%ld",day];
	} else {
		self.title = @"";
	}
}

- (void)drawRect:(NSRect)dirtyRect {
	if(self.owner) {
		[NSGraphicsContext saveGraphicsState];
		
		NSRect bounds = [self bounds];
		
//		if(self.isHighlighted) {
//			[[NSColor grayColor] set];
//		} else {
//		}
		
		[self.owner.backgroundColor set];
		NSRectFill(bounds);
		
		
		if(self.representedDate) {
			//selection
			if(self.selected) {
				NSRect circeRect = NSInsetRect(bounds, 3.5f, 3.5f);
				circeRect.origin.y += 1;
				NSBezierPath* bzc = [NSBezierPath bezierPathWithOvalInRect:circeRect];
				[self.owner.selectionColor set];
				[bzc fill];
			}
			
			NSMutableParagraphStyle * aParagraphStyle = [[NSMutableParagraphStyle alloc] init];
			[aParagraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
			[aParagraphStyle setAlignment:NSCenterTextAlignment];
			
			
			//title
			NSDictionary *attrs = @{NSParagraphStyleAttributeName: aParagraphStyle,NSFontAttributeName: self.font,NSForegroundColorAttributeName: self.owner.textColor};
            
            if (self.selected) {
                attrs = @{NSParagraphStyleAttributeName: aParagraphStyle,NSFontAttributeName: self.font,NSForegroundColorAttributeName: self.owner.selectedTextColor};
            }
			
			NSSize size = [self.title sizeWithAttributes:attrs];
			
			NSRect r = NSMakeRect(bounds.origin.x,// + (bounds.size.width - size.width)/2.0,
								  bounds.origin.y + ((bounds.size.height - size.height)/2.0) - 1,
								  bounds.size.width,
								  size.height);
			
			[self.title drawInRect:r withAttributes:attrs];
			
			
			//line
			NSBezierPath* topLine = [NSBezierPath bezierPath];
			[topLine moveToPoint:NSMakePoint(NSMinX(bounds), NSMinY(bounds))];
			[topLine lineToPoint:NSMakePoint(NSMaxX(bounds), NSMinY(bounds))];
			[self.owner.dayMarkerColor set];
			topLine.lineWidth = 0.3f;
//			[topLine stroke];
			if([self isToday]) {
				[self.owner.todayMarkerColor set];
                
				NSBezierPath* bottomLine = [NSBezierPath bezierPath];
				[bottomLine moveToPoint:NSMakePoint(NSMinX(bounds), NSMaxY(bounds))];
				[bottomLine lineToPoint:NSMakePoint(NSMaxX(bounds), NSMaxY(bounds))];
				bottomLine.lineWidth = 4.0f;
				[bottomLine stroke];
                
                NSBezierPath* topLine = [NSBezierPath bezierPath];
                [topLine moveToPoint:NSMakePoint(NSMinX(bounds), NSMinY(bounds))];
                [topLine lineToPoint:NSMakePoint(NSMaxX(bounds), NSMinY(bounds))];
                topLine.lineWidth = 4.0f;
                [topLine stroke];
                
                NSBezierPath* leftLine = [NSBezierPath bezierPath];
                [leftLine moveToPoint:NSMakePoint(NSMinX(bounds), NSMaxY(bounds))];
                [leftLine lineToPoint:NSMakePoint(NSMinX(bounds), NSMinY(bounds))];
                leftLine.lineWidth = 4.0f;
                [leftLine stroke];
                
                NSBezierPath* rightLine = [NSBezierPath bezierPath];
                [rightLine moveToPoint:NSMakePoint(NSMaxX(bounds), NSMaxY(bounds))];
                [rightLine lineToPoint:NSMakePoint(NSMaxX(bounds), NSMinY(bounds))];
                rightLine.lineWidth = 4.0f;
                [rightLine stroke];
			}
		}
		[NSGraphicsContext restoreGraphicsState];
	}
}

@end
