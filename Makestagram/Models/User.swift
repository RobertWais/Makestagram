//
//  User.swift
//  Makestagram
//
//  Created by Robert Wais on 7/9/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot




class User: Codable {
    
    //STATIC
    private static var _current: User?
    
    static var current: User {
        guard let currentUser = _current else{
            fatalError("Error we might be in trouble")
        }
        return currentUser
    }
    
    static func setCurrent(_ user: User, writeToUserDefaults: Bool = false){
        
        if writeToUserDefaults {
            if let data = try? JSONEncoder().encode(user){
                UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
            }
        }
        
        _current = user
    }
    
    //Properties
    let uid: String
    let username: String
    
    //Initializers
    init(uid: String, username: String){
        self.uid = uid
        self.username = username
    }
    
    init?(snapshot: DataSnapshot){
        guard let dict = snapshot.value as? [String: Any],
        let username = dict["username"] as? String
            else {return nil}
        self.uid = snapshot.key
        self.username = username
    }
}
