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
        if let dict = data.first as? NSDictionary {
            guard let message = dict["lol"] as? String else { return nil }
            content = message
        } else {
            return nil
        }
    }
    
    init(content: String) {
        self.content = content
    }
}