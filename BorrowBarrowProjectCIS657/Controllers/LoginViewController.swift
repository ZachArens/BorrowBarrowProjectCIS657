//
//  LoginViewController.swift
//  BorrowBarrowProjectCIS657
//
//  Created by Zachary Arens on 5/23/19.
//  Copyright © 2019 BarrelBox. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, toolShedDelegate {
    func usernamePassing(passedUsername: String?) {
        
    }
    
    
    var toolshedViewController: ToolShedViewController?;
    
    var username: String?;

    override func viewDidLoad() {
        super.viewDidLoad();
        self.title = "Sign In"
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        username = "Andy";
        if let dest = segue.destination as? UINavigationController, let toolshed = dest.topViewController as? ToolShedViewController
        {
            toolshed.username = self.username;
        }
        
    }
    
    


    @IBAction func SignIn(_ sender: UIButton) {
        
        performSegue(withIdentifier: "LoginToToolShed", sender: nil);
        
        
        
    }
}

