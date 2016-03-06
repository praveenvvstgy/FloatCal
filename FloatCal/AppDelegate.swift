//
//  AppDelegate.swift
//  FloatCal
//
//  Created by Praveen Gowda I V on 1/24/16.
//  Copyright © 2016 Praveen Gowda I V. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, PGCalendarViewDelegate, NSPopoverDelegate {

    @IBOutlet weak var window: NSWindow!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    
    let popover = NSPopover()
    
    var eventMonitor: EventMonitor?

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        if let button = statusItem.button {
            let today = NSCalendar.currentCalendar().components(.Day, fromDate: NSDate())
            button.image = NSImage(named: "Calendar \(today.day)")
            button.action = Selector("toggleCalendar:")
        }
        
        let calendar = PGCalendarView()
        calendar.delegate = self
        calendar.date  = NSDate()
        calendar.selectionColor = NSColor.lightGrayColor()
        calendar.todayMarkerColor = NSColor(red:0.67, green:0.24, blue:0.24, alpha:1)
        
        popover.contentViewController = calendar
        popover.contentSize = calendar.view.frame.size
        popover.appearance = NSAppearance(named: NSAppearanceNameAqua)
        
        popover.animates = true
        popover.behavior = .Transient
        popover.delegate = self
        
        eventMonitor = EventMonitor(mask: [NSEventMask.LeftMouseDownMask, NSEventMask.RightMouseDownMask], handler: { [unowned self](event) -> () in
            if self.popover.shown {
                self.popover.close()
            }
            })
        eventMonitor?.start()
        
        NSNotificationCenter.defaultCenter().addObserverForName(NSCalendarDayChangedNotification, object: nil, queue: nil) { (notification) -> Void in
            let today = NSCalendar.currentCalendar().components(.Day, fromDate: NSDate())
            self.statusItem.button?.image = NSImage(named: "Calendar \(today.day)")
        }
    }
    
    func toggleCalendar(sender: NSStatusBarButton) {
        if popover.shown {
            hideCalendar(sender)
        } else {
            showCalendar(sender)
        }
    }
    
    func showCalendar(sender: AnyObject) {
        if let button = statusItem.button {
            let today = NSCalendar.currentCalendar().components(.Day, fromDate: NSDate())
            button.image = NSImage(named: "Calendar \(today.day)")
            popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: .MinY)
        }
    }
    
    func didSelectDate(selectedDate: NSDate!) {
        //        print(selectedDate)
    }
    
    func hideCalendar(sender: AnyObject) {
        popover.performClose(sender)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

