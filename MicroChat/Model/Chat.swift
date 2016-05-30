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
    var users: [User]?
    var messages: [Message] = []
    
    init(json: JSON) {
        name = json[ParameterKey.Name].string
        users = json[ParameterKey.Users].array?.map { User(json: $0) }
    }
}