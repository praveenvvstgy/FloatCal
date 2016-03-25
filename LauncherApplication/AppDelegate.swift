//
//  AppDelegate.swift
//  LauncherApplication
//
//  Created by Praveen Gowda I V on 3/12/16.
//  Copyright © 2016 Praveen Gowda I V. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let mainAppIdentifier = "com.praveengowda.app.FloatCal"
        let running = NSWorkspace.sharedWorkspace().runningApplications
        var alreadyRunning = false
        
        for app in running {
            if app.bundleIdentifier == mainAppIdentifier {
                alreadyRunning = true
                break
            }
        }
        
        if !alreadyRunning {
            NSDistributedNotificationCenter.defaultCenter().addObserver(self, selector: "terminate", name: "killme", object: mainAppIdentifier)
            
            let path = NSBundle.mainBundle().bundlePath as NSString
            var components = path.pathComponents
            components.removeLast()
            components.removeLast()
            components.removeLast()
            components.append("MacOS")
            components.append("FloatCal")
            
            let newPath = NSString.pathWithComponents(components)
            NSWorkspace.sharedWorkspace().launchApplication(newPath)
        } else {
            self.terminate()
        }
    }
    
    func terminate() {
        NSApp.terminate(nil)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

