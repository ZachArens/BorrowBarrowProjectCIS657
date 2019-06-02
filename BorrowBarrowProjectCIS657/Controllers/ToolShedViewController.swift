//
//  ToolShedViewController.swift
//  BorrowBarrowProjectCIS657
//
//  Created by Zachary Arens on 5/25/19.
//  Copyright © 2019 BarrelBox. All rights reserved.
//

import UIKit

class ToolShedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var addItem: UIBarButtonItem!
    
    @IBOutlet weak var tsItemTableView: UITableView!
    
    var TSItems : [ToolShedItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        


        
        self.tsItemTableView.delegate = self
        self.tsItemTableView.dataSource = self
        let model = TSItemModel()
        self.TSItems = model.getTSItems()
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
        if let items = self.TSItems {
            return items.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let cell = self.tsItemTableView.dequeueReusableCell(withIdentifier: "tsItemCell", for: indexPath) as! TSItemTableViewCell
            
            if let item = self.TSItems?[indexPath.row] {
                cell.itemName?.text = item.itemName
                //TODO need logic to select user lent to or place "in Shed"
                cell.userThatHas?.text = "in Shed"
                cell.itemPicture?.image = UIImage(named: "Kayak")
                cell.itemDetails?.text = item.itemDescription
                
//                Image by OpenClipart-Vectors
//                "https://pixabay.com/users/OpenClipart-Vectors-30363/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=147232"
//                 from Pixabay
//                "https://pixabay.com/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=147232"
                
                cell.signalImage?.image = UIImage(named: "greenSignal")
                
             }
            return cell
    }
}
