//
//  CreateAccountViewController.swift
//  BorrowBarrowProjectCIS657
//
//  Created by Zachary Arens on 6/2/19.
//  Copyright © 2019 BarrelBox. All rights reserved.
//
// Code instructions from p.259-261 of Mobile Application Development by Engelsma and ...

import UIKit
import FirebaseAuth

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var usernameTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var confirmPswdTxtFld: UITextField!
    
    var validationErrors = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func createAccountBtn(_ sender: Any) {
        if self.validateFields() {
            Auth.auth().createUser(withEmail: self.usernameTxtFld.text!, password: self.passwordTxtFld.text!) { (user, error) in
                if let _ = user {
                    //unwind segue need
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.passwordTxtFld.text = ""
                    self.confirmPswdTxtFld.text = ""
                    self.passwordTxtFld.becomeFirstResponder()
                    self.reportError(msg: self.validationErrors)
                }
            }
        }
        
    }
    

    
    func validateFields() -> Bool {
        
        let pwOk = !self.isEmptyOrNil(password: self.passwordTxtFld.text)
        if !pwOk {
            self.validationErrors += "Password cannot be blank. "
        }
        
        let pwMatch = self.passwordTxtFld.text == self.confirmPswdTxtFld.text
        if !pwMatch {
            self.validationErrors += "Passwords do not match. "
        }
        
        let emailOk = self.isValidEmail(email: self.usernameTxtFld.text)
        if !emailOk {
            self.validationErrors += "Invalid email address."
        }
        
        return emailOk && pwOk && pwMatch
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
