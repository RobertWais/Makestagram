//
//  MainTabBarController.swift
//  Makestagram
//
//  Created by Robert Wais on 7/10/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    let photoHelper = MGPhotoHelper()

    override func viewDidLoad() {
        super.viewDidLoad()

        photoHelper.completionHandler = { image in
            print("handle image")
        }
        delegate = self
        tabBar.unselectedItemTintColor = .black
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        
        if viewController.tabBarItem.tag == 1 {
            print("take photo")
            photoHelper.presentActionSheet(from: self)
            
            return false
        }else{
            return true
        }
    }
}
