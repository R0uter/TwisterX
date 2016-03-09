//
//  ViewController.swift
//  TwisterX
//
//  Created by R0uter on 15/8/30.
//  Copyright © 2015年 R0uter. All rights reserved.
//
//next move : track twisterd pid


import SwiftyJSON
import Cocoa

class ViewController: NSViewController {
    var twisterd:Twisterd!
    var backgroundQueue = NSOperationQueue()
    
    let twisterDir:String = NSBundle.mainBundle().bundlePath + "/Contents/Resources/twister"  //Dir for twister
    var configSet:ConfigSet!
    
    var args:[String] = []
    
    var shell = String() {
        didSet { //there is a lockdown for twisterd thread.
            
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                self.shellField.stringValue += self.shell
                self.spinning.stopAnimation(self)
                self.toggle.enabled = true
                self.lockStatTo(.off)
            }
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

    @IBOutlet weak var toggle: NSButton!
    @IBAction func toggle (sender: NSButton) {
        //spinning.usesThreadedAnimation = true
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
            sender.title = "Twister Server: 🔴"
            sender.enabled = false
        }
        
    }
    @IBAction func open(sender: AnyObject) {
        let window = view.window!
        window.close()
       
           }

    @IBAction func test(sender: NSButton) {
       let json = JSON(["method":"getinfo","id":"1"])
        Twisterd.RPC(json) { (succeeded, msg, data) -> () in
            print(data)
        }
        
 
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        configSet = ConfigSet(twisterDir: twisterDir)
        
        versionField.stringValue = getTwisterdVersion()
       
        
        usernameField.stringValue = configSet.config["rpcuser"] ?? "error!"
        passwordField.stringValue = configSet.config["rpcpassword"] ?? "error!"
        rpcPortField.stringValue = configSet.config["rpcport"] ?? "error!"
        proxyIP.stringValue = configSet.config["proxy"] ?? ""
        
        // Do any additional setup after loading the view.
        
        
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    func go () {

        args = ["-conf=" + configSet.configFilePath]
        twisterd = Twisterd(launchPath: twisterDir, arguments: args )
    }
    
     func setConfig() {
        
        configSet.updateConfig(usernameField.stringValue, key: "rpcuser")
        configSet.updateConfig(passwordField.stringValue, key: "rpcpassword")
        configSet.updateConfig(rpcPortField.stringValue, key: "rpcport")
        if proxyIP.stringValue.isEmpty {
            configSet.removeConfig(forKey: "proxy")
        } else {
        configSet.updateConfig(proxyIP.stringValue, key: "proxy")
        }
        configSet.writeConfig()
    }
    
    func getTwisterdVersion()->String {
        let version = Twisterd(launchPath: twisterDir, arguments: ["--help"])
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
    
    enum LockStat {
        case on,off
    }
    
  
}

