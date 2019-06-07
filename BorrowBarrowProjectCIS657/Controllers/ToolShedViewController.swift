//
//  ToolShedViewController.swift
//  BorrowBarrowProjectCIS657
//
//  Created by Zachary Arens on 5/25/19.
//  Copyright © 2019 BarrelBox. All rights reserved.
//

import UIKit
import Firebase

protocol ToolShedViewControllerDelegate
{
    func selectEntry(item: ToolShedItem);
}

class ToolShedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LendItemDelegation {
    
    func lendItemDelegate(item: ToolShedItem?) {
        //Perhaps change the status of item here
        
        
    }
    
    

    @IBOutlet weak var addItem: UIBarButtonItem!
    
    @IBOutlet weak var tsItemTableView: UITableView!
    
    var TSItems : [ToolShedItem]?
    
    fileprivate var ref : DatabaseReference?
    var selectedToolItem: ToolShedItem!
    
    var lendItemDelegate: LendItemDelegation?;
    
    var toolShedDelegate: ToolShedViewControllerDelegate?;
    
    var lendViewCtrl: LendItemViewController?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tsItemTableView.delegate = self
        self.tsItemTableView.dataSource = self
        let model: TSItemModel = TSItemModel()
        self.TSItems = model.getTSItems()
        self.setNeedsStatusBarAppearanceUpdate()
        
        self.ref = Database.database().reference()
        self.registerForFireBaseUpdates()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let lend = segue.destination as? LendItemViewController
        {
            lendViewCtrl = lend;
            lend.selectedToolItem = selectedToolItem;
            lend.lendItemDelegate = self;

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
        if let items = self.TSItems {
            return items.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        lendViewCtrl?.selectedToolItem = TSItems![indexPath.row];
//        if let d = self.lendItemDelegate{
//            print("Delegating...")
//            d.lendItemDelegate(item: nil);
//        }
 
  
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let cell = self.tsItemTableView.dequeueReusableCell(withIdentifier: "tsItemCell", for: indexPath) as! TSItemTableViewCell
            
            if let item = self.TSItems?[indexPath.row] {
                cell.itemName?.text = item.itemName
                //TODO need logic to select user lent to or place "in Shed"
                let personLentTo = item.lentTo ?? "in Shed"
                cell.userThatHas?.text = personLentTo
                cell.itemPicture?.image = UIImage(named: item.photo!) ?? UIImage(named: "emptyPhoto")
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
        self.ref!.child("toolshed").observe(.value, with: { snapshot in
            if let postDict = snapshot.value as? [String : AnyObject] {
                var tmpItems = [ToolShedItem]()
                for (_,val) in postDict.enumerated() {
                    let item = val.1 as! Dictionary<String,AnyObject>
                    let itemName = item["itemName"] as! String?
                    let owner = item["owner"] as! String?
                    let itemDescription = item["itemDescription"] as! String?
                    let reqYesNo = item["reqYesNo"] as! Bool?
                    let requirements = item["requirements"] as! String?
                    let photo = item["photo"] as! String?
                    let lentTo = item["lentTo"] as! String?
                    
                    
                    tmpItems.append(ToolShedItem(itemName: itemName, owner: owner, itemDescription: itemDescription, reqYesNo: reqYesNo, requirements: requirements, photo: photo, lentTo: lentTo))
                }
                self.TSItems = tmpItems
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
            "photo": NSString(string: itms.photo ?? ""),
            "lentTo": NSString(string: itms.lentTo ?? "")
        ]
    }
    
    func addItemToDB() {
        // save history to firebase
        //let addedItem = ToolShedItem(itemName: itemName, owner: owner, itemDescription: itemDescription, reqYesNo: reqYesNo, requirements: requirements, photo: photo, lentTo: lentTo))
        let addedItem = ToolShedItem(itemName: "Kayak", owner: "Barrel Box", itemDescription: "River kayak, 250 lb capacity, 10' long", reqYesNo: true, requirements: "Must provide transportation to/from water, responsible for fixing any damage or replacement if needed.", photo: "kayak", lentTo: "Barack")
        let newChild = self.ref?.child("toolshed").childByAutoId()
        newChild?.setValue(self.toDictionary(itms: addedItem))
    }

}


