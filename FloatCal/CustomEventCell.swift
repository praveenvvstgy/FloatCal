//
//  CustomEventCell.swift
//  FloatCal
//
//  Created by Praveen Gowda I V on 3/25/16.
//  Copyright © 2016 Praveen Gowda I V. All rights reserved.
//

import Cocoa

class CustomEventCell: NSTableCellView {
    
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var secondaryLabel: NSTextField!

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
}
