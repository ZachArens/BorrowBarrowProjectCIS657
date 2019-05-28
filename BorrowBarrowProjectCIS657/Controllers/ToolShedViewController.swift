//
//  ToolShedViewController.swift
//  BorrowBarrowProjectCIS657
//
//  Created by Zachary Arens on 5/25/19.
//  Copyright © 2019 BarrelBox. All rights reserved.
//

import UIKit

protocol toolShedDelegate: class{
    func usernamePassing(passedUsername: String?);
}



class ToolShedViewController: UIViewController {
    
    var username: String?;

    @IBOutlet weak var addItem: UIBarButtonItem!
    
    weak var toolshedDelegation: toolShedDelegate?;

    
    override func viewDidLoad() {
        super.viewDidLoad();

        print(username);        // Do any additional setup after loading the view.
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
