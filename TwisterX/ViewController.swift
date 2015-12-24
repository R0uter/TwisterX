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
    var twisterRpc:Twisterd!
    var backgroundQueue = NSOperationQueue()
    
    let twisterDir:String = NSBundle.mainBundle().bundlePath + "/Contents/Resources/twister"  //Dir for twister
    var twisterdDir = String()
    var htmldir = String()
    var configPath = String() //config file path for args
    var configFilePath = String() //config file path
    var configDict = Dictionary<String,String>()
    var args:[String] = []
    
    var shell = String() {
        didSet { //there is a lockdown for twisterd thread.
            shellField.stringValue += shell
            lockStatTo(.off)
        }
    }

    
    @IBOutlet weak var spinning: NSProgressIndicator!
    @IBOutlet weak var proxyIP: NSTextField!
    @IBOutlet weak var openTwister: NSButton!
    @IBOutlet weak var rpcPortField: NSTextField!
    @IBOutlet weak var usernameField: NSTextField!
    @IBOutlet weak var passwordField: NSTextField!
    @IBOutlet weak var versionField: NSTextField!
    @IBOutlet weak var shellField: NSTextField!

    @IBAction func toggle (sender: NSButton) {
        if sender.title == "Twister Server: 🔴" {
            spinning.startAnimation(self)
            shellField.stringValue = "Starting Twisterd...\n"
            setConfig()
            go()
            backgroundQueue.addOperationWithBlock{self.shell = self.twisterd.runTwisterd()}
            shellField.stringValue += "Twisterd started!\n"
            lockStatTo(.on)
            spinning.stopAnimation(self)
            sender.title = "Twister Server: 🌍"
        } else  {
            spinning.startAnimation(self)
            shellField.stringValue += "Stoping Twisterd...\n"
            twisterd.killTwisterd()
            spinning.stopAnimation(self)
            sender.title = "Twister Server: 🔴"
        }
        
    }
    @IBAction func open(sender: AnyObject) {
        let url = "http://localhost:" + rpcPortField.stringValue
        
        NSWorkspace.sharedWorkspace().openURL(NSURL( string:url)!)
       
           }

    @IBAction func test(sender: NSButton) {
        twisterRpc = Twisterd(launchPath: twisterdDir)
        var data = NSData()
        
        backgroundQueue.addOperationWithBlock {
        
        data = self.twisterRpc.getJson(arguments: ["dhtget","adm1n","profile","s"])
            let json = JSON(data:data)
            let str = json[0,"p","target","n"].string
            NSLog(str!)
        }
        
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
        
        
        versionField.stringValue = getTwisterdVersion()
        do {
            try getConfig()
        } catch {
            let alert = NSAlert()
            alert.addButtonWithTitle("ok")
            alert.runModal()
        }

        
        usernameField.stringValue = configDict["rpcuser"] ?? "error!"
        passwordField.stringValue = configDict["rpcpassword"] ?? "error!"
        rpcPortField.stringValue = configDict["rpcport"] ?? "error!"
        proxyIP.stringValue = configDict["proxy"] ?? ""
        
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
        if proxyIP.stringValue.isEmpty {
            configDict["proxy"] = nil
        } else {
        configDict.updateValue(proxyIP.stringValue, forKey: "proxy")
        }
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
            proxyIP.enabled = false
            
            return
        }
            
            openTwister.enabled = false
            rpcPortField.enabled = true
            usernameField.enabled = true
            passwordField.enabled = true
            proxyIP.enabled = true
   
    }
    
    func getConfig() throws {
        let rowConfigFile = try String(contentsOfFile: configFilePath)
        let config = rowConfigFile.characters.split { (char) -> Bool in
            if char == "\n" {
                return true
            }
            return false
        }
        for str in config {
            let result = str.split{$0 == "="}
            
            let cmd = String(result[0])
            
            let value = String(result[1])
            
            configDict.updateValue(value, forKey: cmd)
        }
    }
    enum LockStat {
        case on,off
    }
    
  
}

