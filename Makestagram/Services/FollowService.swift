//
//  FollowService.swift
//  Makestagram
//
//  Created by Robert Wais on 7/12/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import Foundation
import FirebaseDatabase


struct FollowService {
    
    
    private static func followUser(_ user: User, forCurrentUserWithSuccess success: @escaping (Bool)->()){
        
        
        let currentUID = User.current.uid
        let followData = ["followers/\(user.uid)/\(currentUID)" : true,
                          "following/\(currentUID)/\(user.uid)" : true]
        
        let ref = Database.database().reference()
        ref.updateChildValues(followData) { (error, _) in
            if let error = error {
                assertionFailure("Error in folllowers update \(error.localizedDescription)")
            }
            
            success(error==nil)
        }
    }
    
    private static func unFollowUser(_ user: User, forCurrentUserWithSuccess success: @escaping (Bool)->()){
        let currentUID = User.current.uid
        
        let followData = ["followers/\(user.uid)/\(currentUID)" : NSNull(),
                          "following/\(currentUID)/\(user.uid)" : NSNull()]
        
        let ref = Database.database().reference()
        ref.updateChildValues(followData) { (error, _) in
            if let error = error {
                assertionFailure("Error in folllowers update \(error.localizedDescription)")
            }
            
            success(error==nil)
        }
        
    }
    
    static func setisFollowing( _ isFollowing: Bool, fromCurrentUserTo followee: User, success: @escaping (Bool)->Void){
        if isFollowing {
            followUser(followee, forCurrentUserWithSuccess: success)
        }else{
            unFollowUser(followee, forCurrentUserWithSuccess: success)
        }
    }
    
    static func setIsFollowing(_ isFollowing: Bool, fromCurrentUserTo followee: User, success: @escaping (Bool) -> Void) {
        if isFollowing {
            followUser(followee, forCurrentUserWithSuccess: success)
        } else {
            followUser(followee, forCurrentUserWithSuccess: success)
        }
    }
    
    static func isUserFollowed(_ user: User, byCurrentUserWithCompletion completion: @escaping (Bool)->()) {
        
        let currentUID = User.current.uid
        let ref = Database.database().reference().child("followers").child(user.uid)
        
        ref.queryEqual(toValue: nil, childKey: currentUID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? [String: Bool] {
                completion(true)
            }else {
                completion(false)
            }
        })
    }
}

