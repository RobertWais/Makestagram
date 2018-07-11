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
        let imageRef = Storage.storage().reference().child("test_image.jpg")
        
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                return
            }
            
            let urlString = downloadURL.absoluteString
            print("Image: \(urlString)")
        }
    }
}
