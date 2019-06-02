//
//  CommunityViewController.swift
//  BorrowBarrowProjectCIS657
//
//  Created by Zachary Arens on 5/25/19.
//  Copyright © 2019 BarrelBox. All righcommunity reserved.
//

import UIKit

class CommunityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    
    @IBOutlet weak var addFriend: UIBarButtonItem!
    
    @IBOutlet weak var communityTableView: UITableView!
    
    var communityFriends : [CommunityFriend]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        
        self.communityTableView.delegate = self
        self.communityTableView.dataSource = self
        let model = ComItemModel()
        self.communityFriends = model.getComItems()
        self.setNeedsStatusBarAppearanceUpdate()
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
}
