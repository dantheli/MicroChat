//
//  Network.swift
//  MicroChat
//
//  Created by Daniel Li on 5/26/16.
//  Copyright © 2016 dantheli. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

let HostURL = "http://10.148.4.108:5000"

enum Router: URLStringConvertible {
    
    case SignIn
    case SignUp
    
    var URLString: String {
        let path: String = {
            switch self {
            case .SignIn:
                return "/mchat/users/sign_in"
            case .SignUp:
                return "/mchat/users/sign_up"
            }
        }()
        return HostURL + path
    }
}

struct ParameterKey {
    static let Success      = "success"
    static let Data         = "data"
    static let Errors       = "errors"
    
    static let Session      = "session"
    static let SessionCode  = "session_code"
    
    static let Name         = "name"
    static let Email        = "email"
    static let Password     = "password"
}

struct HeaderKey {
    static let SessionCode  = "SessionCode"
    static let Email        = "E"
    static let Password     = "P"
}

let Defaults = NSUserDefaults.standardUserDefaults()

class Network {
    
    private static var SessionCode: String? {
        get {
            return Defaults.stringForKey("SessionCode")
        }
        set {
            Defaults.setObject(newValue, forKey: "SessionCode")
        }
    }
    
    static func signUp(name: String, email: String, password: String, completion: (error: NSError?) -> Void) {
        let params = [
            ParameterKey.Name : name,
            ParameterKey.Email : email,
            ParameterKey.Password : password
        ]
        request(.POST, params: params, router: .SignUp) { data, error in
            completion(error: error)
        }
    }
    
    static func signIn(email: String, password: String, completion: (error: NSError?) -> Void) {
        let headers = [HeaderKey.Email : email, HeaderKey.Password : password]
        request(.POST, headers: headers, router: .SignIn) { data, error in
            if error == nil {
                SessionCode = data![ParameterKey.Session][ParameterKey.SessionCode].string!
            }
            completion(error: error)
        }
    }
    
    static func signOut(completion: (error: NSError?) -> Void) {
        guard let sessionCode = SessionCode else {
            completion(error: nil)
            print("***WARNING*** User was already signed out it seems. No session code was present.")
            return
        }
        let headers = [HeaderKey.SessionCode : sessionCode]
        request(.POST, headers: headers, router: .SignIn) { data, error in
            if error == nil {
                SessionCode = nil
            }
            completion(error: error)
        }
    }
    
    private static func request(method: Alamofire.Method, headers: [String : String] = [:], params: [String : AnyObject] = [:], router: Router, completion: (data: JSON?, error: NSError?) -> Void) {
        Alamofire.request(method, router, parameters: params, encoding: .JSON, headers: headers)
            .responseJSON { response in
                print()
                print("**************************************** NEW \(method) REQUEST *************************************")
                print()
                print("URL: " + router.URLString)
                print()
                print("HEADERS: \(headers)")
                print()
                print("PARAMETERS: \(params)")
                if let error = response.result.error {
                    print()
                    print("ERROR: (code: \(error.code)) \(error.localizedDescription)")
                    print()
                    completion(data: nil, error: error)
                    return
                }
                
                let json = JSON(data: response.data!)
                print()
                print("RESPONSE:")
                print()
                print(json)
                
                if json[ParameterKey.Success].bool! {
                    completion(data: json[ParameterKey.Data], error: nil)
                } else {
                    let error = json[ParameterKey.Data][ParameterKey.Errors].array?.first?.string
                    completion(data: nil, error: NSError(domain: "MicroChatDomain", code: -999999, userInfo: [kCFErrorLocalizedDescriptionKey : error ?? "Unknown Error"]))
                }
        }
    }
    
}

