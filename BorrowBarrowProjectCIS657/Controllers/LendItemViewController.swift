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
    
    var pickerData: [String] = [String]()
    
    var selectedToolItem: ToolShedItem?;
    
    var toolShedDelegate: ToolShedViewControllerDelegate?;
    
    var lendItemDelegate: LendItemDelegation?;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.pickerData = ["Barack", "Darth", "Luke", "Jude"]
        self.refreshPicker();
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
    
    func refreshPicker () {
        self.friendPickerView.delegate = self
        self.friendPickerView.dataSource = self
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


extension LendItemViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    // The number of columns of data
    func numberOfComponents(in: UIPickerView) -> Int
    {
        return 1
    }
    
    //The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return self.pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
//        if activeSetting == "Distance" {
//            distanceUnitLabel.text = self.pickerData[row]
//            self.selectionDistance = self.pickerData[row]
//        } else if activeSetting == "Bearing" {
//            bearingUnitLabel.text = self.pickerData[row]
//            self.selectionBearing = self.pickerData[row]
//        } else {
//            print("Active setting invalid")
//        }
        
    }
}
