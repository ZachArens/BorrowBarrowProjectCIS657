//
//  CommunityViewController.swift
//  BorrowBarrowProjectCIS657
//
//  Created by Zachary Arens on 5/25/19.
//  Copyright © 2019 BarrelBox. All righcommunity reserved.
//

import UIKit
import Firebase

protocol CommunityDelegation{
    func usernameDelegate(username: String?)
    func friendsListDelegate(friends: Array<String>?)
}

class CommunityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, RequestItemViewControllerDelegate, EditFriendViewControllerDelegate {
   
    func editFriendViewControllerDelegation(friend: CommunityFriend) {
        //Add code here to update item info
    }
    
    func requestItemDelegate(friend: CommunityFriend) {
        //Add code here to adjust anything that needs to be on the community page
    }
    


    
    @IBOutlet weak var addFriend: UIBarButtonItem!
    
    @IBOutlet weak var communityTableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var communityFriends : [CommunityFriend]?
    
    var selectedFriend: CommunityFriend?;
    
    var requestViewCtrl: RequestItemViewController?;
    
    var editViewCtrl: EditFriendViewController?;
    
    fileprivate var ref : DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        
        self.communityTableView.delegate = self
        self.communityTableView.dataSource = self
        let model = ComItemModel()
        self.communityFriends = model.getComItems()
        self.setNeedsStatusBarAppearanceUpdate()
        
        self.ref = Database.database().reference()
        self.registerForFireBaseUpdates()
        
        
        searchBar.delegate = self

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let request = segue.destination as? RequestItemViewController
        {
            requestViewCtrl = request;
            request.communityFriend = selectedFriend;
            request.requestDelegation = self;
            
        }
        else if segue.identifier == "editFriendSegue"
        {
           //Add else if statement to check if the edit segue is the one picked
            let editView = segue.destination as? EditFriendViewController;
            
            editView?.friend = selectedFriend;
            editView?.editFriendDelegation = self;
            
            editViewCtrl = editView;
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        requestViewCtrl?.communityFriend = communityFriends![indexPath.row];
        selectedFriend = communityFriends![indexPath.row];
        //        if let d = self.lendItemDelegate{
        //            print("Delegating...")
        //            d.lendItemDelegate(item: nil);
        //        }
        
        
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
        if let items = self.communityFriends {
            return items.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let cell = self.communityTableView.dequeueReusableCell(withIdentifier: "communityViewCell", for: indexPath) as! CFriendTableViewCell
            
            if let item = self.communityFriends?[indexPath.row] {
                cell.name?.text = "\(item.firstName ?? "First") \(item.lastName ?? "Last")"
                //TODO need to count number of items and lends from DBase
                cell.numOfItems?.text = "7 items"
                cell.numOfLends?.text = "5 lends"
                if item.trustYesNo! {
                    cell.signalImage?.image = UIImage(named: "greenSignal")
                } else {
                    cell.signalImage?.image = UIImage(named: "redSignal")
                }
                cell.userPicture?.image = UIImage(named: "luke")
                cell.userDetails?.text = "\(item.city ?? "City")"
                
                //                Image by OpenClipart-Vectors
                //                "https://pixabay.com/users/OpenClipart-Vectors-30363/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=147232"
                //                 from Pixabay
                //                "https://pixabay.com/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=147232"
                                
            }
            return cell
            
            
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction = UIContextualAction(style: .normal, title: "Edit", handler: {(action, view, completionHandler) in
            //Move to edit page here
            self.selectedFriend = self.communityFriends![indexPath.row];
            
            self.editViewCtrl?.friend = self.communityFriends![indexPath.row];
            self.performSegue(withIdentifier: "editFriendSegue", sender: nil);
            
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
    
    fileprivate func registerForFireBaseUpdates()
    {
        self.ref!.child("community").observe(.value, with: { snapshot in
            if let postDict = snapshot.value as? [String : AnyObject] {
                var tmpItems = [CommunityFriend]()
                for (_,val) in postDict.enumerated() {
                    let key = val.1 as! Dictionary<String,AnyObject>
                    let firstName = key["firstName"] as! String?
                    let lastName = key["lastName"] as! String?
                    let email = key["email"] as! String?
                    let phoneNum = key["phoneNum"] as! String?
                    let address1 = key["address1"] as! String?
                    let address2 = key["address2"] as! String?
                    let city = key["city"] as! String?
                    let state = key["state"] as! String?
                    let zipcode = key["zipcode"] as! String?
                    let trustYesNo = key["trustYesNo"] as! Bool?
                    let friendPhoto = key["friendPhoto"] as! String?
                    
                    
                    tmpItems.append(CommunityFriend(firstName: firstName, lastName: lastName, email: email, phoneNum: phoneNum, address1: address1, address2: address2, city: city, state: state, zipcode: zipcode, trustYesNo: trustYesNo, friendPhoto: friendPhoto))
                }
                self.communityFriends = tmpItems
            }
        })
        
    }
    
    func toDictionary(itms: CommunityFriend) -> NSDictionary {
        return [
            "firstName": NSString(string: itms.firstName ?? ""),
            "lastName": NSString(string: itms.lastName ?? ""),
            "email": NSString(string: itms.email ?? ""),
            "phoneNum": NSString(string: itms.phoneNum ?? ""),
            "address1": NSString(string: itms.address1 ?? ""),
            "address2": NSString(string: itms.address2 ?? ""),
            "city": NSString(string: itms.city ?? ""),
            "state": NSString(string: itms.state ?? ""),
            "zipcode": NSString(string: itms.zipcode ?? ""),
            "trustYesNo": Bool(booleanLiteral: itms.trustYesNo ?? false),
            "friendPhoto": NSString(string: itms.friendPhoto ?? ""),
            
        ]
    }
    
    func addItemToDB() {
        // save history to firebase
        //let addedItem = ToolShedItem(itemName: itemName, owner: owner, itemDescription: itemDescription, reqYesNo: reqYesNo, requirements: requirements, photo: photo, lentTo: lentTo))
        let addedItem = CommunityFriend(firstName: "Darth", lastName: "Vader", email: "darth@celebrity.com", phoneNum: "555-555-5555", address1: "555 Broadway Ave.", address2: "", city: "New York", state: "NY", zipcode: "99999",trustYesNo: true,friendPhoto: "darth")
        let newChild = self.ref?.child("community").childByAutoId()
        newChild?.setValue(self.toDictionary(itms: addedItem))
    }
    
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        
//        var filteredData: [String]!;
//        
//        filteredData = searchText.isEmpty ? data : data.filter { (item: String) -> Bool in
//            // If dataItem matches the searchText, return true to include it
//            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
//        }
        
        var filteredData: [CommunityFriend]?;
        
        
        communityTableView?.reloadData()
    }

    
    
}
