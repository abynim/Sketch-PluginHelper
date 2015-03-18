//
//  AppDelegate.swift
//  PluginHelper
//
//  Created by Aby Nimbalkar on 3/15/15.
//  Copyright (c) 2015 Aby Nimbalkar. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    // The initial WindowController
    var _helloWindowController:NSWindowController?

    
    // MARK: - Handle opening the launcher file
    func application(sender: NSApplication, openFile filename: String) -> Bool {
        println("Open file named: \(filename)")
        
        // After calling this method the parameters you send from Sketch will be available via SketchPlugin.params
        SketchPlugin.parseLauncherFile(filename, completion: {[unowned self] () -> Void in
            
            // For this example, we initialize and show HelloWindowController from Main.storyboard
            if self._helloWindowController == nil {
                if let sb = NSStoryboard(name: "Main", bundle: NSBundle.mainBundle()) {
                    self._helloWindowController = sb.instantiateControllerWithIdentifier("HelloWindow") as? NSWindowController
                }
            }
            
            self._helloWindowController!.window?.center()
            self._helloWindowController!.showWindow(nil)
            // Make the window float above everything else
            self._helloWindowController!.window?.level = Int(CGWindowLevelForKey(Int32(kCGFloatingWindowLevelKey)))
            
        })
        
        return true
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    
}

