//
//  LendItemViewController.swift
//  BorrowBarrowProjectCIS657
//
//  Created by Zachary Arens on 6/2/19.
//  Copyright © 2019 BarrelBox. All rights reserved.
//

import UIKit

protocol LendItemDelegation{
    func lendItemDelegate(item: ToolShedItem?);
}

class LendItemViewController: UIViewController, ToolShedViewControllerDelegate {

    @IBOutlet weak var LendImageView: UIImageView!
    
    @IBOutlet weak var itemNameLabel: UILabel!
    var item: ToolShedItem?;
    
    @IBOutlet weak var itemStatusLabel: UILabel!
    
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    @IBOutlet weak var friendPickerView: UIPickerView!
    
    
    @IBAction func toggleReminder(_ sender: UISwitch) {
        sender.isOn = selectedToolItem?.reqYesNo ?? false;
    }
    
    @IBOutlet weak var dateTextField: UITextField!
    
    
    @IBAction func lendItemBtn(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true);

    }
    
    var selectedToolItem: ToolShedItem?;
    
    var toolShedDelegate: ToolShedViewControllerDelegate?;
    
    var lendItemDelegate: LendItemDelegation?;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        setInfo();
        // Do any additional setup after loading the view.
    }
    
    func setInfo() -> Void
    {
        
        
        itemNameLabel.text = selectedToolItem?.itemName!;
        itemStatusLabel.text = selectedToolItem?.lentTo; //Need to inditcate who it is lent to.
        LendImageView.image = UIImage(named: (selectedToolItem?.photo!)!) ?? UIImage(named: "emptyPhoto")
        descriptionTextView.text = selectedToolItem?.itemDescription;
        
        //Picker view here or function that populates picker here
        
        
        
    }
    
    func selectEntry(item: ToolShedItem) {
        selectedToolItem = item;
        setInfo();
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
