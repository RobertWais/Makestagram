//
//  PostService.swift
//  Makestagram
//
//  Created by Robert Wais on 7/11/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import UIKit
import Foundation
import FirebaseStorage
import FirebaseDatabase

struct PostService {
    
    static func createImage(for image: UIImage){
        let imageRef = StorageReference.newPostReference()
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                return
            }
            
            let urlString = downloadURL.absoluteString
            let aspectHeight = image.aspectHeight
            create(forURLString: urlString, aspectHeight: aspectHeight)
            print("Image: \(urlString)")
        }
    }
    
    private static func create(forURLString urlString: String, aspectHeight: CGFloat){
        //
        let currentUser = User.current
        let post = Post(imageURL: urlString, imageHeight: aspectHeight)
        let dict = post.dictValue
        
        let postRef = Database.database().reference().child("posts").child(currentUser.uid).childByAutoId()
        postRef.updateChildValues(dict)
    }
}
