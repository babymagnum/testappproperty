//
//  LoginController.swift
//  Test Apps
//
//  Created by Arief Zainuri on 24/06/19.
//  Copyright © 2019 Arief Zainuri. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewSetting()
        
        userClick()
    }
    
    private func viewSetting() {
        inputEmail.tag = 1
        inputPassword.tag = 2
        inputEmail.delegate = self
        inputPassword.delegate = self
        loginButton.layer.cornerRadius = 7
    }
    
    private func userClick() {
        loginButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loginButtonClick)))
    }
    
}

// user click
extension LoginController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            inputEmail.resignFirstResponder()
            inputPassword.becomeFirstResponder()
        } else if textField.tag == 2 {
            inputPassword.resignFirstResponder()
        }
        
        return true
    }
    
    @objc func loginButtonClick() {
        SVProgressHUD.show()
        
        Networking.instance.login(email: (inputEmail.text?.trim())!, password: (inputPassword.text?.trim())!) { (error) in
            SVProgressHUD.dismiss()
            
            // show dialog if any error
            if let error = error {
                PublicFunction.instance.showUnderstandDialog(self, "Login Error", error, "Understand")
                return
            }
            
            // change to home screen if success
            let homeController = HomeController()
            self.present(homeController, animated: true)
        }
    }
}
