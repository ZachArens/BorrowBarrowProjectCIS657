//
//  RequestItemViewController.swift
//  BorrowBarrowProjectCIS657
//
//  Created by Zachary Arens on 6/2/19.
//  Copyright © 2019 BarrelBox. All rights reserved.
//

import UIKit
import FirebaseUI

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
    
    var itemPickerData: [String] = [String]()
    
    var communityFriend: CommunityFriend?;
    
    @IBAction func requestItemBtn(_ sender: UIButton) {
        
        //Request Item action here
    }
    
    var requestDelegation: RequestItemViewControllerDelegate?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.itemPickerData = ["Cordless Drill", "Kayak", "Lightsaber", "Tile Saw", "Leafblower"]
        self.refreshPicker();
        
        setContactInfo();
        // Do any additional setup after loading the view.
    }
    
    
    func setContactInfo(){
        
        contactNameLabel.text = communityFriend?.firstName!;
        
        //contactImageView.image = UIImage(named: (communityFriend?.friendPhoto)!) ?? UIImage(named: "emptyPhoto");
        
        ////Below is the SDWebImage code that just needs to be customized for this page
//        let placeholderImage = UIImage(named: "emptyPhoto")
//        if item.photoURL!.isValidStorageURL() && item.photoURL != nil {
//            let imageRef = Storage.storage().reference(forURL: item.photoURL!)
//            cell.contactImageView?.sd_setImage(with: imageRef, placeholderImage: placeholderImage)
//        } else {
//            cell.itemPicture?.image = placeholderImage
//        }
      
        
    }
    
    func refreshPicker () {
        self.itemPicker.delegate = self
        self.itemPicker.dataSource = self
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

extension RequestItemViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    // The number of columns of data
    func numberOfComponents(in: UIPickerView) -> Int
    {
        return 1
    }
    
    //The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return itemPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return self.itemPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
//        if activeSetting == "Distance" {
//            distanceUnitLabel.text = self.itemPickerData[row]
//            self.selectionDistance = self.itemPickerData[row]
//        } else if activeSetting == "Bearing" {
//            bearingUnitLabel.text = self.itemPickerData[row]
//            self.selectionBearing = self.itemPickerData[row]
//        } else {
//            print("Active setting invalid")
//        }
        
    }
}
