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
    case SignOut
    case FetchUsers
    case FetchChats
    case MakeChat(Int)
    
    var URLString: String {
        let path: String = {
            switch self {
            case .SignIn:
                return "/mchat/users/sign_in"
            case .SignOut:
                return "/mchat/users/sign_out"
            case .SignUp:
                return "/mchat/users/sign_up"
            case .FetchUsers:
                return "/mchat/users/index"
            case .FetchChats:
                return "/mchat/chats/index"
            case .MakeChat(let userId):
                return "/mchat/chats/make_chat/\(userId)"
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
    
    static let Id           = "id"
    static let Name         = "name"
    static let Email        = "email"
    static let Password     = "password"
    
    static let Users        = "users"
    
    static let Chats        = "chats"
}

struct HeaderKey {
    static let SessionCode  = "SessionCode"
    static let Email        = "E"
    static let Password     = "P"
}

let Defaults = NSUserDefaults.standardUserDefaults()

class Network {
    
    // MARK: - Authorization/Authentication
    
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
        request(.POST, params: params, router: .SignUp, encoding: .JSON) { data, error in
            completion(error: error)
        }
    }
    
    static func signIn(email: String, password: String, completion: (error: NSError?) -> Void) {
        let headers = [HeaderKey.Email : email, HeaderKey.Password : password]
        request(.POST, headers: headers, router: .SignIn, encoding: .JSON) { data, error in
            if error == nil {
                SessionCode = data![ParameterKey.Session][ParameterKey.SessionCode].string!
            }
            completion(error: error)
        }
    }
    
    static func signOut(completion: (error: NSError?) -> Void) {
        let headers = [HeaderKey.SessionCode : SessionCode!]
        request(.POST, headers: headers, router: .SignOut, encoding: .JSON) { data, error in
            if error == nil {
                SessionCode = nil
            }
            completion(error: error)
        }
    }
    
    // MARK: - Users
    
    static func fetchUsers(completion: (users: [User]?, error: NSError?) -> Void) {
        request(.GET, router: .FetchUsers, encoding: .URL) { data, error in
            completion(users: data?[ParameterKey.Users].array?.map { User(json: $0) }, error: error)
        }
    }
    
    // MARK: - Chats
    
    static func fetchChats(completion: (chats: [Chat]?, error: NSError?) -> Void) {
        let headers = [HeaderKey.SessionCode : SessionCode!]
        request(.GET, headers: headers, router: .FetchChats, encoding: .JSON) { data, error in
            completion(chats: data?[ParameterKey.Chats].array?.map { Chat(json: $0) }, error: error)
        }
    }
    
    private static func request(method: Alamofire.Method, headers: [String : String] = [:], params: [String : AnyObject] = [:], router: Router, encoding: ParameterEncoding, completion: (data: JSON?, error: NSError?) -> Void) {
        Alamofire.request(method, router, parameters: params, encoding: encoding, headers: headers)
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

