//
//  LendItemViewController.swift
//  BorrowBarrowProjectCIS657
//
//  Created by Zachary Arens on 6/2/19.
//  Copyright © 2019 BarrelBox. All rights reserved.
//

import UIKit
import EventKit
import FirebaseUI
import SDWebImage
import Firebase
<<<<<<< HEAD
=======

>>>>>>> 78c989ee82df69b6acf16fd9ecdd67d286177b04

protocol LendItemDelegation{
    func lendItemDelegate(item: ToolShedItem, index: Int?);
}

class LendItemViewController: UIViewController, ToolShedViewControllerDelegate
{

    
    @IBOutlet weak var LendImageView: UIImageView!
    
    
    @IBOutlet weak var itemNameLabel: UILabel!
    var item: ToolShedItem?;
    
    @IBOutlet weak var itemStatusLabel: UILabel!
    
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var friendPickerText: UILabel!
    
    @IBOutlet weak var friendPickerView: UIPickerView!
    
    
    @IBAction func toggleReminder(_ sender: UISwitch) {
        //sender.isOn = selectedToolItem?.reqYesNo ?? false;
        toggledReminder = sender.isOn;
    }
    
    
    @IBAction func datePicker(_ sender: UIDatePicker) {
        reminderDate = sender.date;
        
    }
    
    @IBAction func lendItemBtn(_ sender: UIButton) {
        
        if(toggledReminder)
        {
            requestCalendarAccess(store: store);
        }
        
        selectedToolItem?.lentTo = friendName;
        lendItemDelegate?.lendItemDelegate(item: selectedToolItem!);
        navigationController?.popViewController(animated: true);

    }
    
    @IBOutlet weak var lendBtn: UIButton!
    
    var pickerData: [String] = [String]()
    
    var toggledReminder: Bool!;
    
    var reminderDate: Date?;
    
    var store: EKEventStore!;
    
    var friendName: String?;
    
    var selectedToolItem: ToolShedItem?;
    
    var toolShedDelegate: ToolShedViewControllerDelegate?;
    
    var lendItemDelegate: LendItemDelegation?;
    
    var listOfFriends: [String] = [String]();
    
    fileprivate var userId : String? = ""

    fileprivate var ref : DatabaseReference?

    
    override func viewDidLoad() {
        super.viewDidLoad();
        listOfFriends = [String]();
        self.pickerData = ["You have no friends! Go and add some!"];
        self.getFriends();
        
        toggledReminder = true;
        
        

        self.refreshPicker();
        setInfo();
        
        
        self.store = EKEventStore();
        // Do any additional setup after loading the view.
                
        if (selectedToolItem?.lentTo != "in Shed")
        {
            lendBtn.isEnabled = false;
            lendBtn.titleLabel?.text = "Item is not in shed";
            lendBtn.setTitle("Item is not in the shed", for: .normal);
            lendBtn.backgroundColor = .red;
            
            friendPickerView.isUserInteractionEnabled = false;
            friendPickerText.text = "Item is currently lent to: ";
            let friendLentTo = selectedToolItem?.lentTo;
            self.pickerData = [friendLentTo] as! [String];
            self.refreshPicker();
        }
        
            self.pickerData = self.listOfFriends;
        
    }
    
    func setInfo() -> Void
    {
        LendImageView.sd_setImage(with: URL(string: (selectedToolItem?.photoURL!)!), placeholderImage: UIImage(named: "emptyPhoto"));
        itemNameLabel.text = selectedToolItem?.itemName!;
        itemStatusLabel.text = selectedToolItem?.lentTo; //Need to inditcate who it is lent to.
        //LendImageView.image = UIImage(named: (selectedToolItem?.photoURL)!) ?? UIImage(named: "emptyPhoto")\
        
        ////Below is the SDWebImage code that just needs to be customized for this page
//        let placeholderImage = UIImage(named: "emptyPhoto")
//        if item.photoURL!.isValidStorageURL() && item.photoURL != nil {
//            let imageRef = Storage.storage().reference(forURL: item.photoURL!)
//            cell.itemPicture?.sd_setImage(with: imageRef, placeholderImage: placeholderImage)
//        } else {
//            cell.itemPicture?.image = placeholderImage
//        }
<<<<<<< HEAD
=======

>>>>>>> 78c989ee82df69b6acf16fd9ecdd67d286177b04
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
        
        reminder.title = "\(selectedToolItem?.itemName! ?? "Tool") - \(self.friendName!)";
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
    
    func getFriends(){
        userId = Auth.auth().currentUser?.uid;
        ref = Database.database().reference();
        registerForFireBaseUpdates();

    }
    
    fileprivate func registerForFireBaseUpdates()
    {
        self.ref!.child(self.userId!).child("community").observe(.value, with: { snapshot in
            if let postDict = snapshot.value as? [String : AnyObject] {
                var tmpItems = [ToolShedItem]()
                for (_,val) in postDict.enumerated() {
//                    let item = val.1 as! Dictionary<String,AnyObject>
//                    let itemName = item["itemName"] as! String?
//                    let owner = item["owner"] as! String?
//                    let itemDescription = item["itemDescription"] as! String?
//                    let reqYesNo = item["reqYesNo"] as! Bool?
//                    let requirements = item["requirements"] as! String?
//                    let photoURL = item["photoURL"] as! String?
//                    let thumbnailURL = item["thumbnailURL"] as! String?
//                    let lentTo = item["lentTo"] as! String?
                    
                    let friend = val.1 as! Dictionary<String, AnyObject>;
//                    let address1 = friend["address1"];
//                    let address2 = friend["address2"];
//                    let city = friend["city"];
//                    let email = friend["email"];
                    let firstName = friend["firstName"];
//                    let lastName = friend["lastName"];
//                    let numItems = friend["numItems"];
//                    let numLends = friend["numLends"];
//                    let phoneNum = friend["phoneNum"];
//                    let state = friend["state"];
//                    let trustYesNo = friend["trustYesNo"];
//                    let zipcode = friend["zipcode"];
                    self.listOfFriends.append(firstName as! String? ?? "John Doe");
                }
               // self.tsItems = tmpItems
                if(self.listOfFriends.count < 1)
                {
                    self.pickerData = ["You have no friends. Go add some!"];
                    self.friendPickerView.isUserInteractionEnabled = false;
                }
                else
                {
                    self.pickerData = self.listOfFriends;
                    self.friendName = self.listOfFriends[0];
                }
                self.friendPickerView.reloadAllComponents();
                self.refreshPicker();

                
                

               // self.tsItemTableView.reloadData()
                //                if DEBUG {"
                //                    print("new TSItems from model")
                //                    for item in self.tsItems! {
                //                        print(item.itemName ?? "")
                //                    }
                //                }
            }

        })
        

        
    }
    
}
