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
    private let rpc = NSTask()
    private let rpcPipe = NSPipe()
    
    init(launchPath path:String, arguments args:[String]) {
        task.arguments = args
        task.launchPath = path
        task.standardOutput = pipe
    }
    
     init (launchPath path:String) {
        rpc.launchPath = path
        rpc.standardOutput = rpcPipe
    }
    
    func runTwisterd() -> String {
        task.launch()
        task.waitUntilExit()
        let debugData = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = NSString(data: debugData, encoding: NSUTF8StringEncoding) as! String
        guard !output.isEmpty else { return "Twisterd stoped." }
        return output
       
    }
    func killTwisterd() {
      
        task.terminate()
        task.interrupt()
    }
    func getJson(arguments arg:[String]) ->NSData {
        rpc.arguments = arg
        rpc.launch()
        let jsonData = rpcPipe.fileHandleForReading.readDataToEndOfFile()
        //let data = String(data:jsonData,encoding: NSUTF8StringEncoding)
        return jsonData
    }
  
  
    
   
}