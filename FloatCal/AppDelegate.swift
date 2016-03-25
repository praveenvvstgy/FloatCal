//
//  AppDelegate.swift
//  FloatCal
//
//  Created by Praveen Gowda I V on 1/24/16.
//  Copyright © 2016 Praveen Gowda I V. All rights reserved.
//

import Cocoa
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSPopoverDelegate {

    @IBOutlet weak var window: NSWindow!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    
    let popover = NSPopover()
    
    var eventMonitor: EventMonitor?

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let launcherAppIdentifier = "com.praveengowda.app.LauncherApplication"
        
        SMLoginItemSetEnabled(launcherAppIdentifier, true)
        
        var startedAtLogin = false
        for app in NSWorkspace.sharedWorkspace().runningApplications {
            if app.bundleIdentifier == launcherAppIdentifier {
                startedAtLogin = true
                break
            }
        }
        
        if startedAtLogin {
            NSDistributedNotificationCenter.defaultCenter().postNotificationName("killme", object: NSBundle.mainBundle().bundleIdentifier!)
        }
        
        if let button = statusItem.button {
            let today = NSCalendar.currentCalendar().components(.Day, fromDate: NSDate())
            button.image = NSImage(named: "Calendar \(today.day)")
            button.action = Selector("toggleCalendar:")
            button.target = self
        }
        
        let calendar = CalendarContentViewController()
        
        popover.contentViewController = calendar
        calendar.popover = self.popover
        popover.contentSize = calendar.view.frame.size
        popover.appearance = NSAppearance(named: NSAppearanceNameAqua)
        
        popover.animates = true
        popover.behavior = .ApplicationDefined
        popover.delegate = self
        
        eventMonitor = EventMonitor(mask: [NSEventMask.LeftMouseDownMask, NSEventMask.RightMouseDownMask], handler: { [unowned self](event) -> () in
            if self.popover.shown {
                self.toggleCalendar(self.statusItem.button!)
            }
            })
        eventMonitor?.start()
        
        NSNotificationCenter.defaultCenter().addObserverForName(NSCalendarDayChangedNotification, object: nil, queue: nil) { (notification) -> Void in
            let today = NSCalendar.currentCalendar().components(.Day, fromDate: NSDate())
            self.statusItem.button?.image = NSImage(named: "Calendar \(today.day)")
        }
        
        NSEvent.addLocalMonitorForEventsMatchingMask(NSEventMaskFromType(.LeftMouseDown)) { (eventreq) -> NSEvent? in
            if eventreq.window == self.statusItem.button?.window {
                self.toggleCalendar(self.statusItem.button!)
                return nil
            }
            return eventreq
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
            button.highlighted = true
        }

    }
    
    func hideCalendar(sender: AnyObject) {
        statusItem.button?.highlighted = false
        popover.performClose(sender)
        
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

