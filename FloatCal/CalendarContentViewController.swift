//
//  CalendarContentViewController.swift
//  FloatCal
//
//  Created by Praveen Gowda I V on 3/11/16.
//  Copyright © 2016 Praveen Gowda I V. All rights reserved.
//

import Cocoa

class CalendarContentViewController: NSViewController, PGCalendarViewDelegate {

    @IBOutlet weak var calendarContainer: NSView!
    @IBOutlet weak var toolbar: NSView!
    let calendar = PGCalendarView()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        calendar.delegate = self
        calendar.date  = NSDate()
        calendar.todayMarkerColor = NSColor(red:0.67, green:0.24, blue:0.24, alpha:1)
        calendar.backgroundColor = NSColor(red:1, green:1, blue:1, alpha:1)
        calendar.selectionColor = NSColor(red:0.67, green:0.24, blue:0.24, alpha:1)
        calendar.selectedTextColor = NSColor.whiteColor()
        calendarContainer.addSubview(calendar.view)
        self.addChildViewController(calendar)
        
        NSColor.whiteColor().set()
        NSRectFill(toolbar.bounds)
        
        self.toolbar.wantsLayer = true
        self.toolbar.layer?.backgroundColor =  NSColor.whiteColor().CGColor
    }
    
    init() {
        super.init(nibName: "CalendarContentViewController", bundle: NSBundle(forClass: self.dynamicType))!
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError()
    }
    
    func didSelectDate(selectedDate: NSDate!) {
    }
    
    @IBAction func terminate(sender: NSButton) {
        NSApplication.sharedApplication().terminate(sender)
    }
    @IBAction func today(sender: NSButton) {
        calendar.date = NSDate()
    }
}
