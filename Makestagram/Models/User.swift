//
//  User.swift
//  Makestagram
//
//  Created by Robert Wais on 7/9/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot


private var _current: User?

class User {
    
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
