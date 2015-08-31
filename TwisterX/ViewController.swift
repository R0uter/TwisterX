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
    var rpcallowip = String()
    var args:[String] = []

    
    @IBOutlet weak var versionField: NSTextField!
    @IBAction func toggle (sender: NSButton) {
        if sender.title == "Run Twisterd" {
        go()
        backgroundQueue.addOperationWithBlock { twisterd.runTwisterd() }
        sender.title = "Stop Twisterd"
        } else  {
            twisterd.killTwisterd()
            sender.title = "Run Twisterd"
        }
        
    }
    @IBAction func stop(sender: AnyObject) {
        
       
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

        proxy = "-proxy=" + "ip:port"
        rpcuser = "-rpcuser=" + "user"
        rpcpassword = "-rpcpassword" + "pwd"
        rpcallowip = "-rpcallwoip" + "127.0.0.1"
        args = [htmldir,rpcuser,rpcpassword,rpcallowip]
        twisterd = Twisterd(launchPath: twisterdDir, arguments: args )
    }
    
    func getTwisterdVersion()->String {
        let version = Twisterd(launchPath: twisterdDir, arguments: ["--help"])
        let a =  version.runTwisterd()
        let ver = a.characters.split(){$0 == "\n"}.map{String($0)}
        return ver[0]

    }

}

