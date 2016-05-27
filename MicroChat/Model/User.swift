//
//  Person.swift
//  MicroChat
//
//  Created by Daniel Li on 5/25/16.
//  Copyright © 2016 dantheli. All rights reserved.
//

import Foundation
import SwiftyJSON

class User {
    
    var id: Int
    var name: String
    var email: String
    
    init(json: JSON) {
        name = json[ParameterKey.Name].string!
        email = json[ParameterKey.Email].string!
        id = json[ParameterKey.Id].int!
    }
}