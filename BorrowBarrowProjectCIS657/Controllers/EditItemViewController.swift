//
//  EditItemViewController.swift
//  BorrowBarrowProjectCIS657
//
//  Created by Andy Vuong on 6/8/19.
//  Copyright © 2019 BarrelBox. All rights reserved.
//

import UIKit

protocol EditItemViewControllerDelegate{
    func editItemViewControllerDelegation(item: ToolShedItem);
}

class EditItemViewController: UIViewController {

    
    @IBOutlet weak var itemImageView: UIImageView!
    
    
    @IBAction func photoLibBtn(_ sender: UIButton) {
    }
    
    @IBAction func cameraBtn(_ sender: UIButton) {
    }
    
    
    @IBOutlet weak var itemNameTextView: UITextField!
    
    
    @IBOutlet weak var itemDetailsTextView: UITextView!
    
    
    @IBAction func toggleRequests(_ sender: UISwitch) {
    }
    
    
    @IBOutlet weak var restrictionsTextView: UITextView!
    
    var editItemDelegate: EditItemViewControllerDelegate?;
    
    var item: ToolShedItem?;
    
    
    @IBAction func saveBtn(_ sender: UIButton) {
        
        //Save to database and popViewCtrl
        
        _ = navigationController?.popViewController(animated: true);

    }
    
    
    @IBAction func deleteBtn(_ sender: UIButton) {
        
        //Remove item from database and popViewCtrl
        
        _ = navigationController?.popViewController(animated: true);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setItemInfo();
        // Do any additional setup after loading the view.
    }
    
    
    func setItemInfo() {
        
        itemImageView.image = UIImage(named: (item?.photo!)!) ?? UIImage(named: "emptyPhoto");
        itemNameTextView.text = item?.itemName;
        itemDetailsTextView.text = item?.itemDescription;

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
