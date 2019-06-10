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

class ToolShedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LendItemDelegation, EditItemViewControllerDelegate, AddItemControllerDelegate {

    
    

    @IBOutlet weak var addItem: UIBarButtonItem!
    
    @IBOutlet weak var tsItemTableView: UITableView!
    
    var tsItems : [ToolShedItem]?
    
    fileprivate var ref : DatabaseReference?
    var selectedToolItem: ToolShedItem!
    
    var lendItemDelegate: LendItemDelegation?;
    
    var toolShedDelegate: ToolShedViewControllerDelegate?;
    
    var lendViewCtrl: LendItemViewController?;
    
    var editViewCtrl: EditItemViewController?;
    
//    var tsItemTableViewData: [(sectionHeader: String,  tsItems: [ToolShedItem])]? {
//        didSet {
//            DispatchQueue.main.async {
//                self.tsItemTableView.reloadData()
//            }
//        }
//    }
    
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
        
        self.ref = Database.database().reference()
        self.registerForFireBaseUpdates()
        ref?.child("toolshed").observeSingleEvent(of: .value, with: { (snapshot) in
            
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
        else
        {
            //Check for edit segue and if so, initiate the editItemView variables.
        }
    }
    
    
    func addItem(newTSItem: ToolShedItem) {
        tsItems?.append(newTSItem)
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
            "photo": NSString(string: itms.photo ?? ""),
            "lentTo": NSString(string: itms.lentTo ?? "")
        ]
    }
    
    func addItemToDB(newTSItem : ToolShedItem) {
        // save history to firebase
        //let addedItem = ToolShedItem(itemName: itemName, owner: owner, itemDescription: itemDescription, reqYesNo: reqYesNo, requirements: requirements, photo: photo, lentTo: lentTo))
        let newChild = self.ref?.child("toolshed").childByAutoId()
        newChild?.setValue(self.toDictionary(itms: newTSItem))
    }

}


