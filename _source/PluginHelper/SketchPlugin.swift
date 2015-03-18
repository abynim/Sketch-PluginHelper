//
//  SketchPlugin.swift
//  PluginHelper
//
//  Created by Aby Nimbalkar on 3/15/15.
//  Copyright (c) 2015 Aby Nimbalkar. All rights reserved.
//

import Cocoa

class SketchPlugin:NSObject {
    
    
    struct StaticVars {
        static var skParams:[String:AnyObject]!
        static var launcherFilePath:String!
        static var scriptPath:String!
        static var scriptFolder:String!
    }
    
    class var params:[String:AnyObject]! {
        get {
            if StaticVars.skParams == nil {
                StaticVars.skParams = [String:AnyObject]()
            }
            return StaticVars.skParams
        }
    }
    
    class func terminate() {
        NSFileManager.defaultManager().removeItemAtPath(StaticVars.launcherFilePath, error: nil)
        NSApplication.sharedApplication().terminate(nil)
    }
    
    class func parseLauncherFile(filePath:String, completion: (() -> Void)?=nil) {
        // Read the file as json
        let errorPointer = NSErrorPointer()
        let fileData = NSData(contentsOfFile: filePath, options: NSDataReadingOptions.allZeros, error: errorPointer)
        let jsonDict: AnyObject! = NSJSONSerialization.JSONObjectWithData(fileData!, options: NSJSONReadingOptions.allZeros, error: errorPointer)
        
        // Save the variables sent via Sketch as a global Dictionary
        StaticVars.skParams = jsonDict as [String:AnyObject]
        
        StaticVars.scriptFolder = params["scriptFolder"] as? String
        StaticVars.launcherFilePath = filePath
        
        completion?()
    }
    
    class var sketchApp:NSFileManagerDelegate! {
        get {
            if let appName = params["appName"] as? String {
                return COScript.app(appName).delegate!
            }
            return COScript.app("Sketch").delegate!
        }
    }
    
    class func createPluginWithText(pluginText:String, pluginName:String="temp") -> String? {
        if let scriptFolder = params["scriptFolder"] as? String {
            let path = "\(scriptFolder)/\(pluginName).sketchplugin"
            pluginText.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
            return path
        }
        return nil
    }
    
    class func createScriptWithText(scriptText:String, scriptName:String="temp") -> String? {
        if let scriptFolder = params["scriptFolder"] as? String {
            let path = "\(scriptFolder)/\(scriptName).js"
            scriptText.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
            return path
        }
        return nil
    }
    
    class func executeScriptAtPath(scriptPath:String) {
        let url = NSURL.fileURLWithPath(scriptPath)
        let selector = Selector("runPluginAtURL:")
        if sketchApp.respondsToSelector(selector) {
            bringSketchInFocus()
            XPerformSelector.perform(sketchApp, selector: selector, withObject: url!)
        }
    }
    
    class func executeScript(scriptText:String) {
        
        let selector = Selector("runPluginScript:")
        if sketchApp.respondsToSelector(selector) {
            bringSketchInFocus()
            XPerformSelector.perform(sketchApp, selector: selector, withObject: scriptText)
        }
        
    }
    
    class func bringSketchInFocus() {
        if let appName = params["appName"] as? String {
            NSWorkspace.sharedWorkspace().launchApplication(appName)
        } else {
            NSWorkspace.sharedWorkspace().launchApplication("Sketch")
        }
    }
    
}