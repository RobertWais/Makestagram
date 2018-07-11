//
//  Post.swift
//  Makestagram
//
//  Created by Robert Wais on 7/11/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import UIKit
import FirebaseDatabase.FIRDataSnapshot
class Post {
    
    
    var key: String?
    let imageURL: String
    let imageHeight: CGFloat
    let creationDate: Date
    
    
    init(imageURL: String, imageHeight:CGFloat){
        self.imageURL = imageURL
        self.imageHeight = imageHeight
        self.creationDate = Date()
        
    }
}
