//
//  Shell.swift
//  TwisterX
//
//  Created by R0uter on 15/8/30.
//  Copyright © 2015年 R0uter. All rights reserved.
//

import Foundation
import SwiftyJSON

class Twisterd {
   
    
    
    private let task = NSTask()
    private let pipe = NSPipe()
    private let rpc = NSTask()
    private let rpcPipe = NSPipe()

    
    /**
     Init Twisterd class
     
     - parameter path: twisterd file path
     - parameter args: shell args
     
     - returns: void
     */
    init(launchPath path:String, arguments args:[String]) {
        task.arguments = args
        task.launchPath = path + "/twisterd"
        task.standardOutput = pipe
    }
    
     init (launchPath path:String) {
        rpc.launchPath = path + "/twisterd"
        rpc.standardOutput = rpcPipe
    }
    /**
     Run twisterd and wait until it die.
     
     - returns: console output if needed.
     */
    func runTwisterd() -> String {
        task.launch()
        task.waitUntilExit()
        let debugData = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = NSString(data: debugData, encoding: NSUTF8StringEncoding) as! String
        guard !output.isEmpty else { return "Twisterd stoped." }
        return output
       
    }
    /**
     Use shell killall to kill twisterd task quickly!
     */
    func killTwisterd() {

        let task = NSTask()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c",
            "killall twisterd"]
        task.launch()
    }
    
    class func RPC (params : JSON, RPCCompleted : (succeeded: Bool, msg: String, data:JSON) -> ()) {
        let configFile = ConfigSet.getConfigSet()
        
        let session = NSURLSession.sharedSession()
        let port = configFile.config["rpcport"]!
        let user = configFile.config["rpcuser"]!
        let password = configFile.config["rpcpassword"]!
        let url = "http://" + user + ":" + password + "@127.0.0.1:" + port
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        request.HTTPMethod = "POST"
        
        do {
            request.HTTPBody = try params.rawData()
        } catch (let e) {
            print(e)
            return
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            guard error == nil else {
                RPCCompleted(succeeded: false, msg:String(response),data: JSON(["Error":"Connection error"]))
                print(error)
                return
            }
            
            guard let jsonData = data else {
                RPCCompleted(succeeded: false, msg:String(response),data: JSON(["Error":"Data error"]))
                return

            }
            let json = JSON(data: jsonData)
            
                
                RPCCompleted(succeeded: true, msg:String(response),data:json)
            
        }).resume()
    }

  
  
    
   
}