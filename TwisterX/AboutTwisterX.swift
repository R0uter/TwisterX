//
//  AboutTwisterX.swift
//  TwisterX
//
//  Created by R0uter on 15/8/31.
//  Copyright © 2015年 R0uter. All rights reserved.
//

import Cocoa

class AboutTwisterX: NSViewController {

    @IBAction func goTwisterX(sender: NSButton) {
        jumpWebPageTo("https://github.com/R0uter/TwisterX")
    }
    @IBAction func goTwisterCore(sender: NSButton) {
         jumpWebPageTo("https://github.com/miguelfreitas/twister-core")
    }
    @IBAction func goTwisterHtml(sender: NSButton) {
        jumpWebPageTo("https://github.com/miguelfreitas/twister-html")
    }
    @IBAction func goIssuse(sender: NSButton) {
        jumpWebPageTo("https://github.com/R0uter/TwisterX/issues")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func close(sender: AnyObject?) {
       self.view.window?.close()
    }
    
    func jumpWebPageTo (url:String) {
       let u = NSURL(string: url)
        NSWorkspace.sharedWorkspace().openURL(u!)
    }
}
