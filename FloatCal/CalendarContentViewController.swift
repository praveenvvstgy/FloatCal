//
//  CalendarContentViewController.swift
//  FloatCal
//
//  Created by Praveen Gowda I V on 3/11/16.
//  Copyright © 2016 Praveen Gowda I V. All rights reserved.
//

import Cocoa
import EventKit

class CalendarContentViewController: NSViewController, PGCalendarViewDelegate, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var calendarContainer: NSView!
    @IBOutlet weak var toolbar: NSView!
    let calendar = PGCalendarView()
    
    @IBOutlet weak var eventScrollView: NSScrollView!
    @IBOutlet weak var eventTable: NSTableView!
    weak var popover: NSPopover!
    
    var preferencesWindow: PreferencesWindow!
    
    var eventsPanelHeight = 0 {
        didSet {
            NSAnimationContext.runAnimationGroup({ (context) -> Void in
                context.duration = 2
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if self.eventsPanelHeight == 0 {
                        self.view.frame.size.height = min(CGFloat(350 + self.eventsPanelHeight), 550)
                    } else {
                        self.view.frame.size.height = min(CGFloat(350 + self.eventsPanelHeight) + 3, 550)
                    }
                    self.popover.contentSize = self.view.frame.size
                })
                }, completionHandler: { () -> Void in
            })
        }
    }
    var currentDate = NSDate()
    
    var events = [EKEvent]() {
        didSet {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.eventTable.reloadData()
            })
        }
    }
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
        
        self.toolbar.layer?.backgroundColor =  NSColor(red:0.93, green:0.93, blue:0.93, alpha:1).CGColor
        
        self.didSelectDate(currentDate)
        self.calendar.selectedDate = currentDate
        
        preferencesWindow = PreferencesWindow()
        
        NSNotificationCenter.defaultCenter().addObserverForName(NSCalendarDayChangedNotification, object: nil, queue: nil) { (notification) -> Void in
            let date = NSDate()
            self.calendar.date = date
            self.calendar.selectedDate = date
            self.didSelectDate(date)
        }
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return events.count
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let result = tableView.makeViewWithIdentifier((tableColumn?.identifier)!, owner: self) as! CustomEventCell
        let event = self.events[row]
        result.titleLabel.stringValue = event.title
        result.titleLabel.toolTip = event.title
        if event.allDay {
            result.secondaryLabel.stringValue = "All Day"
        } else {
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.LongStyle
            formatter.timeStyle = .MediumStyle
            
            let dateString = formatter.stringFromDate(event.startDate)
            result.secondaryLabel.stringValue = String(dateString)
            result.secondaryLabel.toolTip = "Starts: \(self.events[row].startDate), \nEnds: \(self.events[row].endDate)"
        }
        return result
    }
    
    func tableView(tableView: NSTableView, selectionIndexesForProposedSelection proposedSelectionIndexes: NSIndexSet) -> NSIndexSet {
        return NSIndexSet()
    }
    
//    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
//        return self.events[row]
//    }
    
//    func tableView(tableView: NSTableView, toolTipForCell cell: NSCell, rect: NSRectPointer, tableColumn: NSTableColumn?, row: Int, mouseLocation: NSPoint) -> String {
//        return "Hello"
//    }
    
    init() {
        super.init(nibName: "CalendarContentViewController", bundle: NSBundle(forClass: self.dynamicType))!
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError()
    }
    
    func didSelectDate(selectedDate: NSDate!) {
        if selectedDate == nil {
            self.eventsPanelHeight = 0
            return
        }
        let eventStore = EKEventStore()
        self.events.removeAll()
        eventStore.requestAccessToEntityType(EKEntityType.Event, completion:
            {(granted, error) in
                if !granted
                {
                    print("Access to store not granted")
                }
                else
                {
                    let calendar = NSCalendar.currentCalendar()
                    let startOfDay = calendar.startOfDayForDate(selectedDate)
                    let startOfNextDay = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: startOfDay, options: NSCalendarOptions.MatchStrictly)!
                    let predicate = eventStore.predicateForEventsWithStartDate(startOfDay, endDate:startOfNextDay, calendars: nil)
                    let events = NSMutableArray(array:eventStore.eventsMatchingPredicate(predicate))
                    for event in events{
                        let calevent = event as! EKEvent
                        self.events.append(calevent)
                    }
                }
                if selectedDate == self.currentDate && self.eventsPanelHeight != 0 {
                    self.eventsPanelHeight = 0
                } else {
                    self.eventsPanelHeight = self.events.count * 40
                }
                self.currentDate = selectedDate
        })
        
    }
    
    @IBAction func terminate(sender: NSButton) {
        NSApplication.sharedApplication().terminate(sender)
    }
    @IBAction func today(sender: NSButton) {
        let date = NSDate()
        self.calendar.date = date
        self.calendar.selectedDate = date
        self.didSelectDate(date)
    }
    
    @IBAction func showPreferences(sender: NSButton) {
        preferencesWindow.showWindow(nil)
    }
    
}
