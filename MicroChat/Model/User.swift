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
    var firstName: String
    var lastName: String
    var fullName: String {
        return firstName + " " + lastName
    }
    var email: String
    
    init(json: JSON) {
        firstName = json[ParameterKey.FirstName].string!
        lastName = json[ParameterKey.LastName].string!
        email = json[ParameterKey.Email].string!
        id = json[ParameterKey.Id].int!
    }
}