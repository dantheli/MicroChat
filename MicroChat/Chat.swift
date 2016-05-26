//
//  Chat.swift
//  MicroChat
//
//  Created by Daniel Li on 5/26/16.
//  Copyright © 2016 dantheli. All rights reserved.
//

import Foundation
import SwiftyJSON

class Chat {
    var name: String?
    var users: [User]
    var messages: [Message] = []
    
    init(json: JSON) {
        fatalError("init(json:) not implemented")
    }
    init(name: String? = nil, users: [User]) {
        self.name = name
        self.users = users
    }
}