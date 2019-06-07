//
//  ToolShedViewController.swift
//  BorrowBarrowProjectCIS657
//
//  Created by Zachary Arens on 5/25/19.
//  Copyright © 2019 BarrelBox. All rights reserved.
//

import UIKit

protocol ToolShedViewControllerDelegate
{
    func selectEntry(item: ToolShedItem);
}

class ToolShedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var toolShedDelegate: ToolShedViewControllerDelegate?;

    @IBOutlet weak var addItem: UIBarButtonItem!
    
    @IBOutlet weak var tsItemTableView: UITableView!
    
    var TSItems : [ToolShedItem]?
    
    var selectedToolItem: ToolShedItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tsItemTableView.delegate = self
        self.tsItemTableView.dataSource = self
        let model: TSItemModel = TSItemModel()
        self.TSItems = model.getTSItems()
        self.setNeedsStatusBarAppearanceUpdate();
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toolshedToLendItem")
        {
            let lendViewCtrl = segue.destination as? LendItemViewController;
            
            
//            lendViewCtrl?.selectedToolItem = selectedToolItem;
//            lendViewCtrl?.lendItemDelegate = self;
          
            
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
        
        if let del = self.toolShedDelegate
        {
            let tempItem = TSItems![indexPath.row];
            //lendItemDelegate?.lendItemDelegate(item: tempItem);
            del.selectEntry(item: tempItem)
        }
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
    
    
}


