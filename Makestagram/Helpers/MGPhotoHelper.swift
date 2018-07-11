//
//  MGPhotoHelper.swift
//  Makestagram
//
//  Created by Robert Wais on 7/10/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import UIKit

class MGPhotoHelper: NSObject {
    
    var completionHandler: ((UIImage) -> Void)?

    func presentImagePickerController(with sourceType: UIImagePickerControllerSourceType, from viewController: UIViewController){
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        
        viewController.present(imagePickerController, animated: true)
    }
    
    func presentActionSheet(from viewController: UIViewController){
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your pictures from", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let capturePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { (action) in
                //Open camera
                self.presentImagePickerController(with: .camera, from: viewController)
            }
            
            alertController.addAction(capturePhotoAction)
            }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let uploadAction = UIAlertAction(title: "Upload from library", style: .default) { (action) in
                //Open Library
                self.presentImagePickerController(with: .photoLibrary, from: viewController)
            }
            alertController.addAction(uploadAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        viewController.present(alertController, animated: true )    }
}

extension MGPhotoHelper: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            completionHandler?(selectedImage)
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
