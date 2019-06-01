//
//  CommunityViewController.swift
//  BorrowBarrowProjectCIS657
//
//  Created by Zachary Arens on 5/25/19.
//  Copyright © 2019 BarrelBox. All rights reserved.
//

import UIKit

protocol CommunityDelegation{
    func usernameDelegate(username: String?)
    func friendsListDelegate(friends: Array<String>?)
}

class CommunityViewController: UIViewController {


    
    @IBOutlet weak var addFriend: UIBarButtonItem!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Do any additional setup after loading the view.
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
