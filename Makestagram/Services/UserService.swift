//
//  UserService.swift
//  Makestagram
//
//  Created by Robert Wais on 7/9/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct UserService {
    
    
    static func show(forUID uid: String, completion: @escaping (User?) -> Void){
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let user = User(snapshot: snapshot) else {
                return completion(nil)
            }
            completion(user)
        }
    }
    
    
    static func create(_ firUser: FIRUser, username: String, completion: @escaping (User?)->Void) {
        
        let userAttrs = ["username" : username]
        let ref = Database.database().reference().child("users").child(firUser.uid)
        ref.setValue(userAttrs){ (error,ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
            
        }
    }
    
    static func posts(for user: User, completion: @escaping ([Post])->Void){
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            
            //return failable because if data doesnt come through dont grab it
            let posts = snapshot.reversed().compactMap(Post.init)
            completion(posts)
        }
    }
    
}


