//
//  PreferencesWindow.swift
//  FloatCal
//
//  Created by Praveen Gowda I V on 3/25/16.
//  Copyright © 2016 Praveen Gowda I V. All rights reserved.
//

import Cocoa
import ServiceManagement


class PreferencesWindow: NSWindowController {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let launcherAppIdentifier = "com.praveengowda.app.LauncherApplication"
    let loginController = StartAtLoginController(identifier: "com.praveengowda.app.LauncherApplication")

    @IBOutlet weak var launchAtLoginBtn: NSButton!
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activateIgnoringOtherApps(true)
        launchAtLoginBtn.state = defaults.valueForKey("launchAtLogin") as? Int ?? 0
        
    }
    @IBAction func launchAtLoginClicked(sender: NSButton) {
        switch sender.state {
        case 0:
            defaults.setValue(sender.state, forKey: "launchAtLogin")
            loginController.startAtLogin = true
        case 1:
            defaults.setValue(sender.state, forKey: "launchAtLogin")
            loginController.enabled = false
        default:
            defaults.setValue(0, forKey: "launchAtLogin")
        }
    }
    
    override var windowNibName : String! {
        return "PreferencesWindow"
    }
    
}
