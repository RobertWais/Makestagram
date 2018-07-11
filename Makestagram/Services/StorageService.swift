//
//  StorageService.swift
//  Makestagram
//
//  Created by Robert Wais on 7/11/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import UIKit
import Foundation
import FirebaseStorage

struct StorageService {
    
    
    
    
    static func uploadImage(_ image: UIImage, at reference: StorageReference, completion: @escaping (URL?)-> Void){
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.1) else {
            return completion(nil)
        }
        
        
        reference.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                assertionFailure("<<<<Error: \(error.localizedDescription) >>>>>")
                return completion(nil)
            }
            
            reference.downloadURL(completion: { (url, error) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    return completion(nil)
                }
                completion(url)
            })
        }
        
    }
}
