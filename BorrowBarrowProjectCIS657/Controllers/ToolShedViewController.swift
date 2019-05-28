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
            let cell = self.tsItemTableView.dequeueReusableCell(withIdentifier: "tsItemCell", for: indexPath)
            
            if let item = self.TSItems?[indexPath.row] {
                cell.textLabel?.text = item.itemName
                cell.detailTextLabel?.text = item.owner
//                cell.detal? = item.itemDescription
//                cell.reqYesNo = item.reqYesNo
//                cell.requirements = item.requirements
//                cell.photo = item.photo
//                if let defaultImage = UIImage(named: "logo") {
//                    cell.imageView?.image = defaultImage
//                }
            }
            return cell
    }
}
