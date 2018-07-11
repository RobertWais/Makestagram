//
//  LoginVC.swift
//  Makestagram
//
//  Created by Robert Wais on 7/9/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseUI

typealias FIRUser = FirebaseAuth.User
class LoginVC: UIViewController {

    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - IBActions
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let authUI = FUIAuth.defaultAuthUI() else {return}
        
        authUI.delegate = self
        
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
    }
}




extension LoginVC: FUIAuthDelegate {
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        
        if let error = error {
            print("Error logging in: \(error.localizedDescription)")
            return
        }
        print("Sign up/Login: \(user?.displayName)")
        
        guard let user = user else {return}
        
        UserService.show(forUID: user.uid) { (user) in
            if let user = user {
                User.setCurrent(user, writeToUserDefaults: true)
                let initialViewController = UIStoryboard.initialViewController(for: .main)
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            }else{
                self.performSegue(withIdentifier: Constants.Segue.toCreateUsername, sender: self)
            }
    }
}

}
