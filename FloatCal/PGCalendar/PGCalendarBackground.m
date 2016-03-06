//
//  PGCalendarBackground.m
//  FloatCal
//
//  Created by Praveen Gowda I V on 1/24/16.
//  Copyright © 2016 Praveen Gowda I V. All rights reserved.
//

#import "PGCalendarBackground.h"

@implementation PGCalendarBackground

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
	self.backgroundColor = [NSColor whiteColor];
}

- (void)drawRect:(NSRect)dirtyRect {
	[self.backgroundColor set];
	NSRectFill(self.bounds);
}

@end
