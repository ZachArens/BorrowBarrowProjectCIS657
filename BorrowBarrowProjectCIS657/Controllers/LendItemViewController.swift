//
//  LendItemViewController.swift
//  BorrowBarrowProjectCIS657
//
//  Created by Zachary Arens on 6/2/19.
//  Copyright © 2019 BarrelBox. All rights reserved.
//

import UIKit
import EventKit

protocol LendItemDelegation{
    func lendItemDelegate(item: ToolShedItem?);
}

class LendItemViewController: UIViewController, ToolShedViewControllerDelegate
{

    
    @IBOutlet weak var LendImageView: UIImageView!
    
    
    @IBOutlet weak var itemNameLabel: UILabel!
    var item: ToolShedItem?;
    
    @IBOutlet weak var itemStatusLabel: UILabel!
    
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    @IBOutlet weak var friendPickerView: UIPickerView!
    
    
    @IBAction func toggleReminder(_ sender: UISwitch) {
        sender.isOn = selectedToolItem?.reqYesNo ?? false;
        toggledReminder = sender.isOn;
    }
    
    
    @IBAction func datePicker(_ sender: UIDatePicker) {
        reminderDate = sender.date;
        
    }
    
    @IBAction func lendItemBtn(_ sender: UIButton) {
        
        requestCalendarAccess(store: store);
        navigationController?.popViewController(animated: true);

    }
    
    var pickerData: [String] = [String]()
    
    var toggledReminder: Bool!;
    
    var reminderDate: Date?;
    
    var store: EKEventStore!;
    
    var friendName: String?;
    
    var selectedToolItem: ToolShedItem?;
    
    var toolShedDelegate: ToolShedViewControllerDelegate?;
    
    var lendItemDelegate: LendItemDelegation?;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.pickerData = ["Barack", "Darth", "Luke", "Jude"]
        self.refreshPicker();
        setInfo();
        
        self.store = EKEventStore();
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
        
        self.friendName = self.pickerData[row];
        
        //return self.pickerData[row]
        
        
    }
    
//    func setupCalendar()
//    {
//        let eventStore = EKEventStore();
//
//        switch EKEventStore.authorizationStatus(for: .event) {
//        case .authorized:
//            //Create calendar and access it
//            print("Authorized");
//        case .denied:
//            print("Access Denied")
//        case .notDetermined:
//            requestCalendarAccess(store: eventStore)
//        default:
//            print("Default");
//        }
//    }
    
    func requestCalendarAccess(store: EKEventStore)
    {
        store.requestAccess(to: EKEntityType.reminder, completion: {
            (accessGranted: Bool, error: Error?) in
            if accessGranted == true {
                DispatchQueue.main.async(execute: {
                    //do things
                    self.addReminder(store: store);
                })
            }
            else
            {
                //Need permission
            }
        })
    }
    
    /*
     Reminder code based on the following sources:
     https://stackoverflow.com/questions/42821348/swift-3-create-reminder-ekeventstore
     https://stackoverflow.com/questions/31235356/set-a-reminder-in-ios-swift
     https://www.ioscreator.com/tutorials/add-event-calendar-ios-tutorial
     */
    
    func addReminder(store: EKEventStore)
    {
        let reminder = EKReminder(eventStore: store);
        
        reminder.title = "\(selectedToolItem?.itemName! ?? "Tool") is due on this date";
        reminder.priority = 2; //I think this means low priority
        
        reminder.notes = "\(selectedToolItem?.itemName! ?? "Tool") should be returning to you today from \(self.friendName!)"; //Add friend name here
        
        reminder.calendar = store.defaultCalendarForNewReminders();
        
//        let alarmTime = Date().addingTimeInterval(1*60*24*3);
//
//        let dateAlarm = NSDate.init().
//
//        let alarm = EKAlarm(absoluteDate: alarmTime);
        
        reminder.addAlarm(EKAlarm(absoluteDate: reminderDate!));
//
//        reminder.addAlarm(alarm);
        do{
            try store.save(reminder, commit: true)
        } catch let error {
            print("Error occurred when creating and adding the reminder - \(error.localizedDescription)");
        }
        
    }
}
