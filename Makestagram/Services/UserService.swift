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
            let dispatchGroup = DispatchGroup()
            
           
            //return failable because if data doesnt come through dont grab it
            let posts: [Post] = snapshot.reversed().compactMap {
                guard let post = Post(snapshot: $0)
                    else { return nil }
                
                dispatchGroup.enter()
                
                LikeService.isPostLiked(post) { (isLiked) in
                    post.isLiked = isLiked
                    
                   dispatchGroup.leave()
                }
                
                return post
            }
            
            dispatchGroup.notify(queue: .main, execute: {
                completion(posts)
            })
        }
    }
    static func usersExcludingCurrentUser(completion: @escaping ([User])-> ()){
        let currentUser = User.current
        let ref = Database.database().reference().child("users")
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else {return completion([]) }
            
            //Get all the users that your following, $0.id said return the ones that are the same id
            //as current uid
            let users = snapshot.compactMap(User.init).filter{$0.uid != currentUser.uid}
            
            let dispatchGroup = DispatchGroup()
                users.forEach{ (user) in
                    dispatchGroup.enter()
                    
                    
                    //Check the users follows these other users
                    FollowService.isUserFollowed(user, byCurrentUserWithCompletion: { (isFollowed) in
                        user.isFollowed = isFollowed
                        dispatchGroup.leave()
                    })
                }
            
            //return all of users that are followed or not followed
            dispatchGroup.notify(queue: .main, execute: {
                completion(users)
            })
        }
    }
}

