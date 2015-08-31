//
//  ViewController.swift
//  TwisterX
//
//  Created by R0uter on 15/8/30.
//  Copyright © 2015年 R0uter. All rights reserved.
//




import Cocoa

class ViewController: NSViewController {
    var twisterd:Twisterd!
    var backgroundQueue = NSOperationQueue()
    
    @IBAction func run(sender: AnyObject) {
        go()
        backgroundQueue.addOperationWithBlock { twisterd.runTwisterd() }
        
    }
    @IBAction func stop(sender: AnyObject) {
        twisterd.killTwisterd()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
        
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    func go () {
        let a:String = NSBundle.mainBundle().bundlePath
        let twisterdDir = a + "/Contents/Resources/twister/twisterd"
        let htmldir = "-htmldir=" + a + "/Contents/Resources/twister/html"
        let proxy = "-proxy=" + "ip:port"
        let rpcuser = "-rpcuser=" + "user"
        let rpcpassword = "-rpcpassword" + "pwd"
        let args = [htmldir,rpcuser,rpcpassword]
        twisterd = Twisterd(launchPath: twisterdDir, arguments: args )
    }

}

