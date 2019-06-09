//
//  EditFriendViewController.swift
//  BorrowBarrowProjectCIS657
//
//  Created by Andy Vuong on 6/8/19.
//  Copyright © 2019 BarrelBox. All rights reserved.
//

import UIKit

protocol EditFriendViewControllerDelegate{
    func editFriendViewControllerDelegation(friend: CommunityFriend);
}

class EditFriendViewController: UIViewController {
    
    
    @IBOutlet weak var friendImageView: UIImageView!
    
    @IBOutlet weak var firstNameTxtView: UITextField!
    
    @IBOutlet weak var lastNameTxtView: UITextField!
    
    
    @IBOutlet weak var emailTxtView: UITextField!
    
    
    @IBOutlet weak var phoneNumTxtView: UITextField!
    
    
    @IBOutlet weak var cityTxtView: UITextField!
    
    
    @IBOutlet weak var addressTxtView: UITextField!
    
    
    @IBOutlet weak var address2TxtView: UITextField!
    
    @IBOutlet weak var stateTxtView: UITextField!
    
    @IBOutlet weak var zipCodeTxtView: UITextField!
    
    @IBOutlet weak var friendDescriptionTxtView: UITextView!
    
    @IBAction func saveFriendBtn(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true);
    }
    
    
    @IBAction func deleteFriend(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true);
    }
    
    
    var friend: CommunityFriend?;
    
    var editFriendDelegation: EditItemViewControllerDelegate?;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func setFriendInfo(){
        
        firstNameTxtView.text = friend?.firstName;
        lastNameTxtView.text = friend?.lastName;
        emailTxtView.text = friend?.email;
        addressTxtView.text = friend?.address1;
        address2TxtView.text = friend?.address2;
        cityTxtView.text = friend?.friendPhoto;
        stateTxtView.text = friend?.state;
        zipCodeTxtView.text = friend?.zipcode;
        
        
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
