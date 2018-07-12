//
//  LikeService.swift
//  Makestagram
//
//  Created by Robert Wais on 7/11/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import Foundation
import FirebaseDatabase


struct LikeService {
    
    
    
    static func setIsLiked(_ isLiked: Bool, for post: Post, success: @escaping (Bool)->()){
        if isLiked{
            create(for: post, success: success)
        }else{
            delete(for: post, success: success)
        }
        
    }
    static func create(for post: Post, success: @escaping (Bool)->Void){
        guard let key = post.key else {
            return success(false)
        }
        
        let currentUID = User.current.uid
        
        let likesRef = Database.database().reference().child("postLikes").child(currentUID)
        likesRef.setValue(true) { (error, _) in
            if let error = error {
                assertionFailure("Error in posting likes: \(error.localizedDescription)")
                return success(false)
            }
        
            
        let likesCountRef = Database.database().reference().child("posts").child(post.poster.uid).child(key).child("like_count")
            
            likesCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
                let currentCount = mutableData.value as? Int ?? 0
                mutableData.value = currentCount+1
                
                return TransactionResult.success(withValue: mutableData)
            }, andCompletionBlock: { (error, bool, snapShot) in
                if let error = error {
                    assertionFailure("Error in likesCountRef: \(error.localizedDescription)")
                    return success(false)
                }else{
                    return success(true)
                }
            })
            
        }
    }
    
    
    
    static func delete(for post: Post, success: @escaping (Bool)->(Void)){
        guard let key = post.key else {
            return success(false)
        }
        
        let currentUID = User.current.uid
        
        let likesRef = Database.database().reference().child("postLikes").child(currentUID)
        likesRef.setValue(nil) { (error, _) in
            if let error = error {
                assertionFailure("Error in deleting likes:\(error.localizedDescription)" )
               return success(false)
            }
            return success(true)
        }
    }
    
    static func isPostLiked(_ post: Post, byCurrentUserWithCompletion completion: @escaping (Bool)->()){
        guard let postKey = post.key else {
            assertionFailure("Error in Post liked: Must have akey")
            return completion(false)
        }
        
        let likesRef = Database.database().reference().child("postLikes").child(postKey)
        likesRef.queryEqual(toValue: nil, childKey: User.current.uid).observeSingleEvent(of: .value) { (snapshot) in
            if let _ = snapshot.value as? [String: Any]{
               return completion(true)
            }else{
                return completion(false)
            }
        }
    }
}
