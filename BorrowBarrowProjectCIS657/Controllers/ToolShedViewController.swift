//
//  ToolShedViewController.swift
//  BorrowBarrowProjectCIS657
//
//  Created by Zachary Arens on 5/25/19.
//  Copyright © 2019 BarrelBox. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FirebaseUI
import SDWebImage
import EventKit;

protocol ToolShedViewControllerDelegate
{
    func selectEntry(item: ToolShedItem, index: Int);
}

class ToolShedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LendItemDelegation, EditItemViewControllerDelegate, AddItemControllerDelegate {

    @IBOutlet weak var addItem: UIBarButtonItem!
    
    @IBOutlet weak var tsItemTableView: UITableView!
    @IBOutlet weak var loginStatusLbl: UILabel!
    
    var tsItems : [ToolShedItem]?
    
    fileprivate var ref : DatabaseReference?
    fileprivate var userId : String = ""
    
    var selectedToolItem: ToolShedItem!
    var selectedToolIndex: Int?
    var localPhotos: Dictionary<Int,UIImage?> = [:]
    
    var lendItemDelegate: LendItemDelegation?;
    
    var toolShedDelegate: ToolShedViewControllerDelegate?;
    
    var lendViewCtrl: LendItemViewController?;
    
    var editViewCtrl: EditItemViewController?;
    
    @IBOutlet weak var logoutBtnRef: UIButton!
    
    //TODO - need to create alternating button to add function

    @IBAction func logoutBtn(_ sender: UIButton) {
        do { try Auth.auth().signOut()
            print ("Logged out")
            tsItems?.removeAll()
            self.tsItemTableView.reloadData();

            } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            }
        
        logoutBtnRef.isUserInteractionEnabled = false;
        logoutBtnRef.isHidden = true;
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tsItemTableView.delegate = self
        self.tsItemTableView.dataSource = self
        
        self.tsItems = [ToolShedItem]();
        
        if(self.loginStatusLbl.text == "Not Logged In")
        {
            logoutBtnRef.isUserInteractionEnabled = false;
            logoutBtnRef.isHidden = true;
        }
        else
        {
            logoutBtnRef.isUserInteractionEnabled = true;
            logoutBtnRef.isHidden = false;
        }
        
        self.tsItemTableView.reloadData()
//        let model: TSItemModel = TSItemModel()
//        self.tsItems = model.getTSItems()

        
//        if DEBUG {
//            print("new TSItems from model")
//            for item in tsItems! {
//                print(item.itemName ?? "")
//            }
//        }
        Auth.auth().addStateDidChangeListener { auth, user in if let user = user {
                self.userId = user.uid
                self.ref = Database.database().reference()
                self.loginStatusLbl.text = user.email
                self.registerForFireBaseUpdates()
            
                self.logoutBtnRef.isHidden = false;
            self.logoutBtnRef.isUserInteractionEnabled = true;
            } else {
                self.loginStatusLbl.text = "Not Logged In"
            }
        }

        ref?.child(self.userId).child("toolshed").observeSingleEvent(of: .value, with: { (snapshot) in
            
        })
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let lend = segue.destination as? LendItemViewController
        {
            lendViewCtrl = lend;
            lend.selectedToolItem = selectedToolItem;
            lend.lendItemDelegate = self;

        } else if let addItems = segue.destination as? AddItemController {
            addItems.delegate = self;
            
        } else if let edit = segue.destination as? EditItemViewController {
            //attached ToolShedItem to pass to EditItemVC
            edit.item = selectedToolItem;
            edit.itemIndex = selectedToolIndex
            edit.editItemDelegate = self;
            //editViewCtrl = edit;

            //Check for edit segue and if so, initiate the editItemView variables.
        }
    }
    
    
    func addItem(newTSItem: ToolShedItem, localPhoto: UIImage?) {
        //DEBUG
        if DEBUG {
            print("added item to TSItems array")
            if tsItems != nil {
                for item in tsItems! {
                    print(item.itemName ?? "")
                }
            }
        }
        let keyedTSItem = self.addItemToDB(newTSItem: newTSItem)
        tsItems?.append(keyedTSItem)
        let photoIndex: Int = tsItems!.count - 1
        if photoIndex >= 0 {
            localPhotos[photoIndex] = localPhoto
        }
        
    }
    
    
    func returnEditedItemDelegation(item: ToolShedItem, index: Int?) {
        self.editItemInDB(newTSItem: item)
        if index != nil {
            tsItems?[index!] = item
        } else {
            tsItems?.append(item)
        }
    }
    
    
    func lendItemDelegate(item: ToolShedItem, index: Int?) {
        //Perhaps change the status of item here
        self.editItemInDB(newTSItem: item)
        if index != nil {
            tsItems?[index!] = item
        } else {
            tsItems?.append(item)
        }
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction = UIContextualAction(style: .normal, title: "Edit", handler: {(action, view, completionHandler) in
            //Move to edit page here
            self.selectedToolItem = self.tsItems![indexPath.row];
            self.editViewCtrl?.item = self.tsItems![indexPath.row];
            //self.editViewCtrl
            self.performSegue(withIdentifier: "editItemSegue", sender: nil);
            
            completionHandler(true);
        })
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: {(action, view, deletionHandler) in
            self.deleteItemFromDB(tsItemToDelete: self.tsItems![indexPath.row])
            //Code to delete item here
            self.findAndRemoveReminder();
            deletionHandler(true);
        })
        
        editAction.backgroundColor = .green;
        deleteAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [editAction, deleteAction]);
        return configuration;
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let returnAction = UIContextualAction(style: .normal, title: "Item Return", handler: {(action, view, completionHandler) in
            //Move to edit page here
            if(self.selectedToolItem.lentTo != "in Shed")
            {
                self.selectedToolItem = self.tsItems![indexPath.row];
                //self.editViewCtrl?.item = self.tsItems![indexPath.row];
                //self.performSegue(withIdentifier: "editItemSegue", sender: nil);
                self.tsItems![indexPath.row].lentTo = "in Shed";
                self.tsItemTableView.reloadData();
                
                self.findAndRemoveReminder();
            }

            
            
            completionHandler(true);
        })
        
        returnAction.backgroundColor = .blue
        
        let configuration = UISwipeActionsConfiguration(actions: [returnAction]);
        return configuration;
    }
    
    func findAndRemoveReminder(){
        let eventStore = EKEventStore();
        //print("\(selectedToolItem?.itemName! ?? "Tool") - \(selectedToolItem.lentTo!)");
        //        NSPredicate pred = eventStore.predicateForReminders(in: [eventStore.calendars(for: .reminder)]);
        let predicate = eventStore.predicateForReminders(in: [eventStore.defaultCalendarForNewReminders()!]);
        
        let identifier: String = "\(selectedToolItem?.itemName! ?? "Tool") - Andy";
        
        var reminder: EKReminder?;
        
        let listOfReminders = eventStore.fetchReminders(matching: predicate, completion: {reminders in
            for reminded in reminders!{
                print(reminded.title);
                
                if(reminded.title == identifier)
                {
                    reminder = reminded;
                    do{
                        try eventStore.remove(reminded, commit: true)
                    } catch let error {
                        print("Error occurred when deleting the reminder - \(error.localizedDescription)");
                    }
                    // self.removeReminder(eventStore: eventStore, reminder: reminded);
                }
            }
        })
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let items = self.tsItems {
            return items.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        lendViewCtrl?.selectedToolItem = tsItems![indexPath.row];
//        if let d = self.lendItemDelegate{
//            print("Delegating...")
//            d.lendItemDelegate(item: nil);
//        }
 
  
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let cell = self.tsItemTableView.dequeueReusableCell(withIdentifier: "tsItemCell", for: indexPath) as! TSItemTableViewCell
            
            if let item = self.tsItems?[indexPath.row] {
                cell.itemName?.text = item.itemName
                //TODO need logic to select user lent to or place "in Shed"
                let personLentTo = item.lentTo ?? "in Shed"
                cell.userThatHas?.text = personLentTo
//                if item.photoURL != nil {
//                    cell.itemPicture?.image = UIImage(named: item.photoURL!)
//                } else {
//                    cell.itemPicture?.image = UIImage(named: "emptyPhoto")
//                }
                var placeholderImage = UIImage(named: "emptyPhoto")
                if localPhotos.count > 0 {
                    placeholderImage = localPhotos[indexPath.row] ?? UIImage(named:"emptyPhoto")
                }
            
                if item.photoURL!.isValidStorageURL() && item.photoURL != nil {
                    let imageRef = Storage.storage().reference(forURL: item.photoURL!)
                    cell.itemPicture?.sd_setImage(with: imageRef, placeholderImage: placeholderImage)
                } else {
                    cell.itemPicture?.image = placeholderImage
                }
                cell.itemDetails?.text = item.itemDescription
                if personLentTo == "in Shed" {
                    cell.signalImage?.image = UIImage(named: "greenSignal")
                } else {
                    cell.signalImage?.image = UIImage(named: "redSignal")
                }
                
//                Image by OpenClipart-Vectors
//                "https://pixabay.com/users/OpenClipart-Vectors-30363/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=147232"
//                 from Pixabay
//                "https://pixabay.com/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=147232"
                
                
                //Set global variable to selected item so we can delegate it properly
                selectedToolItem = item;
             }
            
            
            return cell
    }
    
    fileprivate func registerForFireBaseUpdates()
    {
        self.ref!.child(self.userId).child("toolshed").observe(.value, with: { snapshot in
            if let postDict = snapshot.value as? [String : AnyObject] {
                var tmpItems = [ToolShedItem]()
                for (_,val) in postDict.enumerated() {
                    let dbID = val.key
                    let item = val.1 as! Dictionary<String,AnyObject>
                    let itemName = item["itemName"] as! String?
                    let owner = item["owner"] as! String?
                    let itemDescription = item["itemDescription"] as! String?
                    let reqYesNo = item["reqYesNo"] as! Bool?
                    let requirements = item["requirements"] as! String?
                    let photoURL = item["photoURL"] as! String?
                    let thumbnailURL = item["thumbnailURL"] as! String?
                    let lentTo = item["lentTo"] as! String?
                    
                    
                    var tmpTSItem = ToolShedItem(itemName: itemName, owner: owner, itemDescription: itemDescription, reqYesNo: reqYesNo, requirements: requirements, photoURL: photoURL, thumbnailURL: thumbnailURL, lentTo: lentTo)
                    tmpTSItem.addDBID(dbId: dbID)
                    tmpItems.append(tmpTSItem)
                }
                self.tsItems = tmpItems
                
                self.tsItemTableView.reloadData()
//                if DEBUG {
//                    print("new TSItems from model")
//                    for item in self.tsItems! {
//                        print(item.itemName ?? "")
//                    }
//                }
            }
        })
        
    }
    
    func toDictionary(itms: ToolShedItem) -> NSDictionary {
        return [
            "itemName": NSString(string: itms.itemName ?? ""),
            "owner": NSString(string: itms.owner ?? ""),
            "itemDescription": NSString(string: itms.itemDescription ?? ""),
            "reqYesNo": Bool(booleanLiteral: itms.reqYesNo!),
            "requirements": NSString(string: itms.requirements ?? ""),
            "photoURL": NSString(string: itms.photoURL ?? ""),
            "thumbnailURL": NSString(string: itms.thumbnailURL ?? ""),
            "lentTo": NSString(string: itms.lentTo ?? "")
        ]
    }
    
    func addItemToDB(newTSItem : ToolShedItem) -> ToolShedItem {
        let newChild = self.ref?.child(self.userId).child("toolshed").childByAutoId()
        newChild?.setValue(self.toDictionary(itms: newTSItem))
        if let key = newChild?.key {
            var returnTSItem = newTSItem
            returnTSItem.addDBID(dbId: key)
            return returnTSItem
        } else {
            return newTSItem
        }
        self.tsItemTableView.reloadData()
    }
    
    func editItemInDB(newTSItem : ToolShedItem) {
        if let newChild = self.ref?.child(self.userId).child("toolshed").child(newTSItem.dbId!) {
            newChild.setValue(self.toDictionary(itms: newTSItem))
//            if let key = newChild?.key {
//                var returnTSItem = newTSItem
//                returnTSItem.addDBID(dbId: key)
//                return returnTSItem
//            } else {
//                return newTSItem
//            }
        } else {
            //TODO - add error code
            print("Item not edited: something went wrong")
        }
        self.tsItemTableView.reloadData()
    }
    
    func deleteItemFromDB(tsItemToDelete: ToolShedItem) {
        if let childToDelete = self.ref?.child(self.userId).child("toolshed").child(tsItemToDelete.dbId!) {
            childToDelete.removeValue()
        } else {
            //TODO - add error code
            print("Item not deleted: something went wrong")
        }
        self.tsItemTableView.reloadData()
    }
    
    @IBAction func createToToolshedUnwind(segue: UIStoryboardSegue)
    {
        //Store user account information from new account here
    }
    
    @IBAction func loginToToolshedUnwind(segue: UIStoryboardSegue)
    {
        //Obtain user information of new account here
    }

}


