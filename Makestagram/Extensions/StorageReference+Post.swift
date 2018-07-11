//
//  StorageReference+Post.swift
//  Makestagram
//
//  Created by Robert Wais on 7/11/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import Foundation
import FirebaseStorage

extension StorageReference {
    static let dateFormatter = ISO8601DateFormatter()
    
    static func newPostReference() -> StorageReference {
        let uid = User.current.uid
        let timestamp =  dateFormatter.string(from: Date())
        
        return Storage.storage().reference().child("images/posts/\(uid)/\(timestamp).jpg")

    }
}
