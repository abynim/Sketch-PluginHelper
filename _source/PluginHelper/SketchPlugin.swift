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
    }
    
    class var params:[String:AnyObject]! {
        get {
            if StaticVars.skParams == nil {
                StaticVars.skParams = [String:AnyObject]()
            }
            return StaticVars.skParams
        }
    }
    
    class var launcherFilePath:String {
        return StaticVars.launcherFilePath
    }
    
    class var workingFolderPath:String {
        return StaticVars.launcherFilePath.stringByDeletingLastPathComponent
    }
    
    class var manifestJSON:[String:AnyObject]! {
        get  {
            if let scriptFolder = params["scriptFolder"] as? String {
                let filePath = "\(scriptFolder)/manifest.json"
                let errorPointer = NSErrorPointer()
                if let fileData = NSData(contentsOfFile: filePath, options: NSDataReadingOptions.allZeros, error: errorPointer)
                {
                    let jsonDict: AnyObject! = NSJSONSerialization.JSONObjectWithData(fileData, options: NSJSONReadingOptions.allZeros, error: errorPointer)
                    return jsonDict as? [String:AnyObject]
                }
            }
            return nil
        }
    }
    
    class var manifestFilePath:String! {
        if let scriptFolder = params["scriptFolder"] as? String {
            return "\(scriptFolder)/manifest.json"
        }
        return nil
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
        StaticVars.skParams = jsonDict as? [String:AnyObject]
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
    
    class func enableCommandWithIdentifier(identifier:String) {
        
        if var manifest = self.manifestJSON {
            if var menu = manifest["menu"] as? [String:AnyObject] {
                // check if command exists
                if let commands = manifest["commands"] as? [[String:String]] {
                    for command in commands {
                        if command["identifier"] == identifier {
                            if var menuItems = menu["items"] as? [String] {
                                if find(menuItems, identifier) == nil {
                                    menuItems.append(identifier)
                                    menu["items"] = menuItems
                                    manifest["menu"] = menu
                                    
                                    writeJSONToFile(manifest, filePath: manifestFilePath)
                                }
                            }
                            break
                        }
                    }
                    
                }
                
            }
        }
        
    }
    
    class func disableCommandWithIdentifier(identifier:String) {
        
        if var manifest = self.manifestJSON {
            if var menu = manifest["menu"] as? [String:AnyObject] {
                // check if command exists
                
                if var menuItems = menu["items"] as? [String]
                {
                    if let itemIndex = find(menuItems, identifier)
                    {
                        menuItems.removeAtIndex(itemIndex)
                        menu["items"] = menuItems
                        manifest["menu"] = menu
                        
                        writeJSONToFile(manifest, filePath: manifestFilePath)
                    }
                }
                
            }
        }
        
    }
    
    class func isCommandEnabled(identifier:String) -> Bool {
        if var manifest = self.manifestJSON
        {
            if var menu = manifest["menu"] as? [String:AnyObject]
            {
                if var menuItems = menu["items"] as? [String]
                {
                    return find(menuItems, identifier) != nil
                }
            }
        }
        return false
    }
    
    
    class func bringSketchInFocus() {
        if let appName = params["appName"] as? String {
            NSWorkspace.sharedWorkspace().launchApplication(appName)
        } else {
            NSWorkspace.sharedWorkspace().launchApplication("Sketch")
        }
    }
    
    
    class func writeJSONToFile(jsonObject:AnyObject, filePath:String) {
        let errorPointer = NSErrorPointer()
        let jsonData = NSJSONSerialization.dataWithJSONObject(jsonObject, options: NSJSONWritingOptions.PrettyPrinted, error: errorPointer)
        if let jsonString = NSString(data: jsonData!, encoding: NSUTF8StringEncoding) {
            jsonString.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
        }
    }
    
    
}