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
    func selectEntry(item: ToolShedItem);
}

class ToolShedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LendItemDelegation, EditItemViewControllerDelegate, AddItemControllerDelegate {

    
    

    @IBOutlet weak var addItem: UIBarButtonItem!
    
    @IBOutlet weak var tsItemTableView: UITableView!
    @IBOutlet weak var loginStatusLbl: UILabel!
    
    var tsItems : [ToolShedItem]?
    
    fileprivate var ref : DatabaseReference?
    fileprivate var userId : String? = ""
    
    var selectedToolItem: ToolShedItem!
    
    var lendItemDelegate: LendItemDelegation?;
    
    var toolShedDelegate: ToolShedViewControllerDelegate?;
    
    var lendViewCtrl: LendItemViewController?;
    
    var editViewCtrl: EditItemViewController?;
    
    
    //TODO - need to create alternating button to add function
    @IBAction func logoutBtn(segue: UIStoryboardSegue) {
        do { try Auth.auth().signOut()
            print ("Logged out")
            } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tsItemTableView.delegate = self
        self.tsItemTableView.dataSource = self
        
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
            } else {
                self.loginStatusLbl.text = "Not Logged In"
            }
        }

        ref?.child(self.userId!).child("toolshed").observeSingleEvent(of: .value, with: { (snapshot) in
            
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
        }
        else if segue.identifier == "editItemSegue"
        {
            let edit = segue.destination as? EditItemViewController;            
            edit?.item = selectedToolItem;
            edit?.editItemDelegate = self;
            editViewCtrl = edit;

            //Check for edit segue and if so, initiate the editItemView variables.
        }
    }
    
    
    func addItem(newTSItem: ToolShedItem) {
        tsItems?.append(newTSItem)
        
        //DEBUG
        if DEBUG {
            print("added item to TSItems array")
            for item in tsItems! {
                print(item.itemName ?? "")
            }
        }
        self.addItemToDB(newTSItem: newTSItem)
    }
    
    
    func editItemViewControllerDelegation(item: ToolShedItem) {
        
    }
    
    
    func lendItemDelegate(item: ToolShedItem?) {
        //Perhaps change the status of item here
        
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction = UIContextualAction(style: .normal, title: "Edit", handler: {(action, view, completionHandler) in
            //Move to edit page here
            self.selectedToolItem = self.tsItems![indexPath.row];
            self.editViewCtrl?.item = self.tsItems![indexPath.row];
            self.performSegue(withIdentifier: "editItemSegue", sender: nil);
            
            completionHandler(true);
        })
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: {(action, view, deletionHandler) in
            //Code to delete item here
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
            self.selectedToolItem = self.tsItems![indexPath.row];
            //self.editViewCtrl?.item = self.tsItems![indexPath.row];
            //self.performSegue(withIdentifier: "editItemSegue", sender: nil);
            self.tsItems![indexPath.row].lentTo = "in Shed";
            self.tsItemTableView.reloadData();
            
            
            
            
            completionHandler(true);
        })
        
        returnAction.backgroundColor = .blue
        
        let configuration = UISwipeActionsConfiguration(actions: [returnAction]);
        return configuration;
    }
    
    func findAndRemoveReminder(){
        let eventStore = EKEventStore();
        let reminder = eventStore.calendarItem(withIdentifier: "\(selectedToolItem.itemName) - \(selectedToolItem.lentTo)") as! EKReminder?;
        eventStore.requestAccess(to: EKEntityType.reminder, completion: { (accessGranted: Bool, error: Error?) in
            
                if(accessGranted)
                {
                    DispatchQueue.main.async(execute:
                    {
                        self.removeReminder(eventStore: eventStore, reminder: reminder!)
                    })
                }
            }
        
)}
    
    func removeReminder(eventStore: EKEventStore, reminder: EKReminder)
    {
        do{
            try eventStore.remove(reminder, commit: true)
        } catch let error {
            print("Error occurred when deleting the reminder - \(error.localizedDescription)");
        }
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
                let placeholderImage = UIImage(named: "emptyPhoto")
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
        self.ref!.child(self.userId!).child("toolshed").observe(.value, with: { snapshot in
            if let postDict = snapshot.value as? [String : AnyObject] {
                var tmpItems = [ToolShedItem]()
                for (_,val) in postDict.enumerated() {
                    let item = val.1 as! Dictionary<String,AnyObject>
                    let itemName = item["itemName"] as! String?
                    let owner = item["owner"] as! String?
                    let itemDescription = item["itemDescription"] as! String?
                    let reqYesNo = item["reqYesNo"] as! Bool?
                    let requirements = item["requirements"] as! String?
                    let photoURL = item["photoURL"] as! String?
                    let thumbnailURL = item["thumbnailURL"] as! String?
                    let lentTo = item["lentTo"] as! String?
                    
                    
                    tmpItems.append(ToolShedItem(itemName: itemName, owner: owner, itemDescription: itemDescription, reqYesNo: reqYesNo, requirements: requirements, photoURL: photoURL, thumbnailURL: thumbnailURL, lentTo: lentTo))
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
    
    func addItemToDB(newTSItem : ToolShedItem) {
        //let addedItem = ToolShedItem(itemName: itemName, owner: owner, itemDescription: itemDescription, reqYesNo: reqYesNo, requirements: requirements, photo: photo, lentTo: lentTo))
        let newChild = self.ref?.child(self.userId!).child("toolshed").childByAutoId()
        newChild?.setValue(self.toDictionary(itms: newTSItem))
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


