//
//  ViewController.swift
//  TwisterX
//
//  Created by R0uter on 15/8/30.
//  Copyright © 2015年 R0uter. All rights reserved.
//
//next move : track twisterd pid



import Cocoa




class ViewController: NSViewController {
    var twisterd:Twisterd!
    var backgroundQueue = NSOperationQueue()
    
    let twisterDir:String = NSBundle.mainBundle().bundlePath + "/Contents/Resources/twister"  //Dir for twister
    var twisterdDir = String()
    var htmldir = String()
    var configPath = String() //config file path for args
    var configFilePath = String() //config file path
    var proxy = String()
    var configDict = Dictionary<String,String>()
    var args:[String] = []
    
    var shell = String() {
        didSet {
            shellField.stringValue += shell
            lockStatTo(.off)
        }
    }

    
    @IBOutlet weak var openTwister: NSButton!
    @IBOutlet weak var rpcPortField: NSTextField!
    @IBOutlet weak var usernameField: NSTextField!
    @IBOutlet weak var passwordField: NSTextField!
    @IBOutlet weak var versionField: NSTextField!
    @IBOutlet weak var shellField: NSTextField!
    @IBAction func toggle (sender: NSButton) {
        if sender.title == "Twister Server: 🔴" {
            shellField.stringValue = "Starting Twisterd...\n"
            
            setConfig()
            go()
            backgroundQueue.addOperationWithBlock{self.shell = self.twisterd.runTwisterd()}
            shellField.stringValue += "Twisterd started!\n"
            lockStatTo(.on)
            sender.title = "Twister Server: 🌍"
        } else  {
            shellField.stringValue += "Stoping Twisterd...\n"
            twisterd.killTwisterd()
            
            sender.title = "Twister Server: 🔴"
        }
        
    }
    @IBAction func open(sender: AnyObject) {
        let url = "http://localhost:" + rpcPortField.stringValue
        
        NSWorkspace.sharedWorkspace().openURL(NSURL( string:url)!)
       
           }

    override func viewDidLoad() {
        super.viewDidLoad()
        //-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0
        //init this dir
        twisterdDir = twisterDir + "/twisterd"
        htmldir = "-htmldir=" + twisterDir + "/html"
        configPath = "-conf=" + twisterDir + "/twister.conf"
        configFilePath = twisterDir + "/twister.conf"
        //-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0
        let rowConfigFile = try! String(contentsOfFile: configFilePath)
        let config = rowConfigFile.characters.split { (char) -> Bool in
            if char == "\n" {
                return true
            }
            return false
        }
        for str in config {
            let result = str.split(isSeparator: { (char) -> Bool in
                if char == "=" {
                    return true
                }
                return false
            })
            let cmd = String(result[0])
            let value = String(result[1])
            configDict.updateValue(value, forKey: cmd)
        }
        
        versionField.stringValue = getTwisterdVersion()
        
        usernameField.stringValue = configDict["rpcuser"] ?? ""
        passwordField.stringValue = configDict["rpcpassword"] ?? ""
        rpcPortField.stringValue = configDict["rpcport"] ?? ""
        
        
        // Do any additional setup after loading the view.
      
        
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    func go () {

        args = [htmldir,configPath]
        twisterd = Twisterd(launchPath: twisterdDir, arguments: args )
    }
    
    func setConfig() {
        
        configDict.updateValue(usernameField.stringValue, forKey: "rpcuser")
        configDict.updateValue(passwordField.stringValue, forKey: "rpcpassword")
        configDict.updateValue(rpcPortField.stringValue, forKey: "rpcport")
        var str = ""
        var content:[String] = []
        for (cmd,value) in configDict {
            let row = cmd + "=" + value
            content.append(row)
        }
        str = content.joinWithSeparator("\n")
        
        do {
            try str.writeToFile(configFilePath, atomically: true, encoding: NSUTF8StringEncoding)
        } catch {
            NSLog("save error~")
        }
        
    }
    
    func getTwisterdVersion()->String {
        let version = Twisterd(launchPath: twisterdDir, arguments: ["--help"])
        let a = version.runTwisterd()
        let ver = a.characters.split(){$0 == "\n"}.map{String($0)}
        return ver[0]

    }
    
    func lockStatTo(loc:LockStat) {
        guard loc == .off else {
            openTwister.enabled = true
            rpcPortField.enabled = false
            usernameField.enabled = false
            passwordField.enabled = false
           
            
            return
        }
            
            openTwister.enabled = false
            rpcPortField.enabled = true
            usernameField.enabled = true
            passwordField.enabled = true
   
    }
    enum LockStat {
        case on,off
    }
    
  
}

