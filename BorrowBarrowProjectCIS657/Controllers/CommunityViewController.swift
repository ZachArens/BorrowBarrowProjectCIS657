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

class CommunityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    
    @IBOutlet weak var addFriend: UIBarButtonItem!
    
    @IBOutlet weak var communityTableView: UITableView!
    
    var communityFriends : [CommunityFriend]?
    
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
}
