//
//  HelloViewController.swift
//  PluginHelper
//
//  Created by Aby Nimbalkar on 3/15/15.
//  Copyright (c) 2015 Aby Nimbalkar. All rights reserved.
//

import Cocoa

class HelloViewController: NSViewController {

    
    @IBOutlet weak var helloLabel: NSTextField!
    
    @IBOutlet weak var redButton: NSButton!
    @IBAction func handleRedButton(sender: AnyObject) {
        
        var script  = "#import 'lib/helperMethods.js'\n"
            script += "applyColorToSelection('FF654E')"
        
        // Save this script to a .js file
        if let scriptPath = SketchPlugin.createScriptWithText(script, scriptName: "makeRed") {
            // execute the script
            SketchPlugin.executeScriptAtPath(scriptPath)
            
            // Delete the .js file after it has executed
            NSFileManager.defaultManager().removeItemAtPath(scriptPath, error: nil)
        }
        
        // Call terminate to close the helper app when you're done.
        SketchPlugin.terminate()
    }
    
    @IBAction func handleCancelButton(sender: AnyObject) {
        SketchPlugin.terminate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set a button as default, triggered on pressing Return
        redButton.bezelStyle = NSBezelStyle.RoundedBezelStyle
        redButton.keyEquivalent = "\r"
        
        // Use variables sent from Sketch by accessing SketchPlugin.params
        if let numberOfLayers = SketchPlugin.params["numberOfLayers"] as? Int {
            helloLabel.stringValue = "Hello, you have \(numberOfLayers) layers selected."
        }
        
    }
    
}
