//
//  TwisterX.swift
//  TwisterX
//
//  Created by R0uter on 16/3/9.
//  Copyright © 2016年 R0uter. All rights reserved.
//

import Cocoa
import WebKit

class TwisterX: NSViewController {

    @IBOutlet weak var content: WebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        let config = ConfigSet.getConfigSet().config
        
        let url = NSURL(string: "http://" + config["rpcuser"]! + ":" + config["rpcpassword"]! + "@localhost:" + config["rpcport"]!)

        let request = NSURLRequest(URL: url!)
        
        content.mainFrame.loadRequest(request)

    }
    
   
    
    
}
