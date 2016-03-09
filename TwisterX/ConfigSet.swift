//
//  ConfigSet.swift
//  TwisterX
//
//  Created by R0uter on 16/2/12.
//  Copyright © 2016年 R0uter. All rights reserved.
//

import Cocoa

/// This is the set of config infomation
class ConfigSet {
    private var twisterDir:String
    private var configFile = Dictionary<String,String>()
    private static var cs:ConfigSet?
    
     var htmlDir:String {return twisterDir + "/html"}
     var configFilePath:String {return twisterDir + "/twister.conf"}

    
    init (twisterDir:String) {
        self.twisterDir = twisterDir
        readConfig()
        ConfigSet.cs = self
    }
    
    var config:Dictionary<String,String> {
        return configFile
    }
    
    class func getConfigSet () -> ConfigSet {
        return cs!
    }
    func readConfig() {
        
        let rowConfigFile = try? String(contentsOfFile: configFilePath)
        
        guard rowConfigFile != nil else {
        let alert = NSAlert()
        alert.addButtonWithTitle("ok")
        alert.runModal()
            return
        }

        let config = rowConfigFile!.characters.split { (char) -> Bool in
            if char == "\n" {
                return true
            }
            return false
        }
        for str in config {
            let result = str.split{$0 == "="}
            
            let cmd = String(result[0])
            
            let value = String(result[1])
            
            configFile.updateValue(value, forKey: cmd)
        }
    }
    func updateConfig(value:String,key:String) {
        
        configFile.updateValue(value, forKey: key)
    }
    func removeConfig(forKey key:String) {
        configFile[key] = nil
    }
    
    func writeConfig() {
        var str = ""
        var content:[String] = []
        for (cmd,value) in configFile {
            let row = cmd + "=" + value
            content.append(row)
        }
        str = content.joinWithSeparator("\n")
        
        do {
            try str.writeToFile(configFilePath, atomically: true, encoding: NSUTF8StringEncoding)
        } catch {
            NSLog("save error~")
        }
//        readConfig()
        
    }

    
}