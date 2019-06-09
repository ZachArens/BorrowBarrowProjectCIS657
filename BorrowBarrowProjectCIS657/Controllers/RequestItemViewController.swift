//
//  RequestItemViewController.swift
//  BorrowBarrowProjectCIS657
//
//  Created by Zachary Arens on 6/2/19.
//  Copyright © 2019 BarrelBox. All rights reserved.
//

import UIKit

protocol RequestItemViewControllerDelegate{
    func requestItemDelegate(friend: CommunityFriend);
}

class RequestItemViewController: UIViewController {
    

    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    
    @IBOutlet weak var itemNameLabel: UILabel!
    
    @IBOutlet weak var itemPicker: UIPickerView!
    
    @IBOutlet weak var specialRequestsTxt: UITextView!
    
    
    var communityFriend: CommunityFriend?;
    
    @IBAction func requestItemBtn(_ sender: UIButton) {
        
        //Request Item action here
    }
    
    var requestDelegation: RequestItemViewControllerDelegate?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setContactInfo();
        // Do any additional setup after loading the view.
    }
    
    
    func setContactInfo(){
        
        contactNameLabel.text = communityFriend?.firstName!;
        
        contactImageView.image = UIImage(named: (communityFriend?.friendPhoto)!) ?? UIImage(named: "emptyPhoto");
        
      
        
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
