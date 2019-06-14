//
//  UIViewController+Validation.swift
//  BorrowBarrowProjectCIS657
//
//  Created by Zachary Arens on 6/10/19.
//  Copyright © 2019 BarrelBox. All rights reserved.
//

import Foundation
import FirebaseAuth

extension UIViewController {
    func reportError(msg: String) {
        let alert = UIAlertController(title: "Failed", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func isEmptyOrNil(password: String?) -> Bool {
        if password == nil {
            return true
        } else if password == "" {
            return true
        } else {
            return false
        }
    }
    
    func isValidEmail(email: String?) -> Bool {
        if email != nil || email != "" {
            return true
        } else {
            return false
        }
    }

}

extension String {
    func isValidStorageURL() -> Bool {
        if self.starts(with: "gs://") {
            return true
        } else if self.starts(with: "http://") {
            return true
        } else if self.starts(with: "https://") {
            return true
        } else {
            return false
        }
    }
}


