//
//  Shell.swift
//  TwisterX
//
//  Created by R0uter on 15/8/30.
//  Copyright © 2015年 R0uter. All rights reserved.
//

import Foundation


struct Twisterd {
   
    
    
    private let task = NSTask()
    private let pipe = NSPipe()
    
    
    init(launchPath path:String, arguments args:[String]) {
        task.arguments = args
        task.launchPath = path
        task.standardOutput = pipe
    }
    
    func runTwisterd()->String {
        task.launch()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: String = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
        guard output != "" else { return "Twisterd is started!" }
        return output
    }
    func killTwisterd() {
      
        task.terminate()
    }
    
  
  
    
   
}