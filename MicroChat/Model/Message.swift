//
//  Message.swift
//  MicroChat
//
//  Created by Daniel Li on 5/25/16.
//  Copyright © 2016 dantheli. All rights reserved.
//

import Foundation
import SwiftyJSON

class Message {
    
    var content: String
    
    init?(data: [AnyObject]) {
        if let dict = data.first as? NSDictionary,
            message = dict["lol"] as? [String] {
            self.content = message.first!
        } else {
            return nil
        }
    }
    
    init?(json: JSON) {
        fatalError("init(json:) not implemented")
    }
    
    init(content: String) {
        self.content = content
    }
}