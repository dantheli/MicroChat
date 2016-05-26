//
//  Message.swift
//  MicroChat
//
//  Created by Daniel Li on 5/25/16.
//  Copyright © 2016 dantheli. All rights reserved.
//

import Foundation

class Message {
    
    var content: String
    
    init?(data: [AnyObject]) {
        if let dict = data.first as? NSDictionary,
            message = dict["lol"] as? String {
            content = message
//        } else if let dict = data as? NSDictionary,
//            message = dict["lol"] as? String {
//            content = message
        } else {
            return nil
        }
    }
    
    init(content: String) {
        self.content = content
    }
}