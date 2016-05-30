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

let HostURL = "http://10.129.0.81:3000"

enum Router: URLStringConvertible {
    
    case SignIn
    case SignUp
    case SignOut
    case FetchUsers
    case FetchChats
    case NewChat
    
    var URLString: String {
        let path: String = {
            switch self {
            case .SignIn:
                return "/users/sign_in"
            case .SignOut:
                return "/users/sign_out"
            case .SignUp:
                return "/users/sign_up"
            case .FetchUsers:
                return "/users/index"
            case .FetchChats:
                return "/chats/index"
            case .NewChat:
                return "/chats/create"
            }
        }()
        return HostURL + path
    }
}

struct ParameterKey {
    static let Data         = "data"
    
    static let Session      = "session"
    static let SessionCode  = "sessionCode"
    
    static let Id           = "id"
    static let FirstName    = "firstName"
    static let LastName     = "lastName"
    static let Email        = "email"
    static let Password     = "password"
    
    static let Name         = "name"
    
    static let Users        = "users"
    static let User         = "user"
    
    static let Chats        = "chats"
    static let Chat         = "chat"
    
    static let Participants = "participants"
}

struct HeaderKey {
    static let SessionCode  = "session_code"
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
    
    static func signUp(firstName: String, lastName: String, email: String, password: String, completion: (error: NSError?) -> Void) {
        let params = [
            ParameterKey.User : [
                ParameterKey.FirstName : firstName,
                ParameterKey.LastName : lastName,
                ParameterKey.Email : email,
                ParameterKey.Password : password
            ]
        ]
        request(.POST, params: params, router: .SignUp, encoding: .JSON) { data, error in
            completion(error: error)
        }
    }
    
    static func signIn(email: String, password: String, completion: (error: NSError?) -> Void) {
        let headers = [HeaderKey.Email : email, HeaderKey.Password : password]
        request(.POST, headers: headers, router: .SignIn, encoding: .JSON) { data, error in
            if error == nil {
                SessionCode = data![ParameterKey.SessionCode].string!
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
        let headers = [HeaderKey.SessionCode : SessionCode!]
        request(.GET, headers: headers, router: .FetchUsers, encoding: .URL) { data, error in
            completion(users: data?[ParameterKey.Users].array?.map { User(json: $0) }, error: error)
        }
    }
    
    // MARK: - Chats
    
    static func fetchChats(completion: (chats: [Chat]?, error: NSError?) -> Void) {
        let headers = [HeaderKey.SessionCode : SessionCode!]
        request(.GET, headers: headers, router: .FetchChats, encoding: .URL) { data, error in
            completion(chats: data?[ParameterKey.Chats].array?.map { Chat(json: $0) }, error: error)
        }
    }
    
    static func newChat(userIds: [Int], completion: (chat: Chat?, error: NSError?) -> Void) {
        let headers = [HeaderKey.SessionCode : SessionCode!]
        let parameters = [ParameterKey.Participants : userIds]
        request(.POST, headers: headers, params: parameters, router: .NewChat, encoding: .JSON) { data, error in
            var chat: Chat? = nil
            if error != nil {
                chat = Chat(json: data![ParameterKey.Data][ParameterKey.Chat])
            }
            completion(chat: chat, error: error)
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
                
                completion(data: json[ParameterKey.Data], error: nil)
            }
    }
    
}

