//
//  AppDelegate.swift
//  TwisterX
//
//  Created by R0uter on 15/8/30.
//  Copyright © 2015年 R0uter. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldHandleReopen(sender: NSApplication, hasVisibleWindows
        flag: Bool) -> Bool {
            if !flag{
                for window in sender.windows{
                    
                        window.makeKeyAndOrderFront(self)
                    
                }
            }
            return true
    }




    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
        let killTwisterd = Twisterd(launchPath: "/usr/bin/killall", arguments: ["twisterd"])
        killTwisterd.runTwisterd()
    }


}

