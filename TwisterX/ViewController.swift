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
    
    let a:String = NSBundle.mainBundle().bundlePath
    var twisterdDir = String()
    var htmldir = String()
    var proxy = String()
    var rpcuser = String()
    var rpcpassword = String()
    var rpcport = String()
    var args:[String] = []
    
    var shell = String() {
        didSet {
            shellField.stringValue += shell
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
            go()
            backgroundQueue.addOperationWithBlock{self.shell = self.twisterd.runTwisterd()}
            shellField.stringValue += "Twisterd started!\n"
            lockStatTo(.on)
            sender.title = "Twister Server: 🌍"
        } else  {
            shellField.stringValue += "Stoping Twisterd...\n"
            twisterd.killTwisterd()
            lockStatTo(.off)
            sender.title = "Twister Server: 🔴"
        }
        
    }
    @IBAction func open(sender: AnyObject) {
        let url = "http://localhost:" + rpcPortField.stringValue
        
        NSWorkspace.sharedWorkspace().openURL(NSURL( string:url)!)
       
           }

    override func viewDidLoad() {
        super.viewDidLoad()
        twisterdDir = a + "/Contents/Resources/twister/twisterd"
        htmldir = "-htmldir=" + a + "/Contents/Resources/twister/html"

        
        versionField.stringValue = getTwisterdVersion()
        
        // Do any additional setup after loading the view.
      
        
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    func go () {
        
        rpcuser = "-rpcuser=" + usernameField.stringValue
        rpcpassword = "-rpcpassword=" + passwordField.stringValue
        rpcport = "-rpcport=" + rpcPortField.stringValue
        args = [htmldir,rpcuser,rpcpassword,rpcport]
        twisterd = Twisterd(launchPath: twisterdDir, arguments: args )
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

