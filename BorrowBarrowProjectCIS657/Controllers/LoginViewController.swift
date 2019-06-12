//
//  LoginViewController.swift
//  BorrowBarrowProjectCIS657
//
//  Created by Zachary Arens on 5/23/19.
//  Copyright © 2019 BarrelBox. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    func usernamePassing(passedUsername: String?) {
        
    }
    
    @IBOutlet weak var usernameTxtFld: UITextField!
    
    @IBAction func signInBtn(_ sender: Any) {
    }
    

    
    var toolshedViewController: ToolShedViewController?;
    
    var username: String?;

    override func viewDidLoad() {
        super.viewDidLoad();
        self.title = "Sign In"
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //username = "Andy";
        if let dest = segue.destination as? UINavigationController, let toolshed = dest.topViewController as? ToolShedViewController
        {
            //toolshed.username = self.username;
        }
        
    }
    
    


    @IBAction func SignIn(_ sender: UIButton) {
        
//        //performSegue(withIdentifier: "LoginToToolShed", sender: nil);
//        if self.validateFields() {
//            Auth.auth().createUser(withEmail: self.usernameTxtFld.text!, password: self.passwordTxtFld.text!) { (user, error) in
//                if let _ = user {
//                    self.dismiss(animated: false, completion: nil)
//                } else {
//                    self.passwordTxtFld.text = ""
//                    self.confirmPswdTxtFld.text = ""
//                    self.passwordTxtFld.becomeFirstResponder()
//                    self.reportError(msg: self.validationErrors)
//                }
//            }
//        }
        
        
    }
    
//    func validateFields() -> Bool {
//        
//        let pwOk = self.isEmptyOrNil(password: self.passwordTxtFld.text)
//        if !pwOk {
//            self.validationErrors += "Password cannot be blank. "
//        }
//        
//        let pwMatch = self.passwordTxtFld.text == self.confirmPswdTxtFld.text
//        if !pwMatch {
//            self.validationErrors += "Passwords do not match. "
//        }
//        
//        let emailOk = self.isValidEmail(email: self.usernameTxtFld.text)
//        if !emailOk {
//            self.validationErrors += "Invalid email address."
//        }
//        
//        return emailOk && pwOk && pwMatch
//    }
}

