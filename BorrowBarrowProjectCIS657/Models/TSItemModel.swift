//
//  TSItemModel.swift
//  BorrowBarrowProjectCIS657
//
//  Created by Zachary Arens on 5/27/19.
//  Copyright © 2019 BarrelBox. All rights reserved.
//

import Foundation

class TSItemModel {
    fileprivate var items : [ToolShedItem] = [ToolShedItem]()
    
    init() {
        createTSItems()
    }
    
    func getTSItems() -> [ToolShedItem]
    {
        return self.items
    }
    
    fileprivate func createTSItems()
    {
        items.append(ToolShedItem(itemName: "Kayak", owner: "Barrel Box", itemDescription: "River kayak, 250 lb capacity, 10' long", reqYesNo: true, requirements: "Must provide transportation to/from water, responsible for fixing any damage or replacement if needed.", photo: "ChIJAxoZu9ZlaYcRDKzKqbeYlts"))
        items.append(ToolShedItem(itemName: "Leaf Blower", owner: "Barrel Box", itemDescription: "gas powered backpack leaf blower", reqYesNo: true, requirements: "Must provide own gasoline, responsible for fixing any damage or replacement if needed.", photo: "ChIJAxoZu9ZlaYcRDKzKqbeYlts"))
        items.append(ToolShedItem(itemName: "Cordless Drill", owner: "Barrel Box", itemDescription: "Lithium charging, charger provided", reqYesNo: true, requirements: "Must provide pick up/drop off, does not come with bits, responsible for fixing any damage or replacement if needed.", photo: "ChIJAxoZu9ZlaYcRDKzKqbeYlts"))
        items.append(ToolShedItem(itemName: "Tile Saw", owner: "Barrel Box", itemDescription: "I will show you how to operate, 110v, up to 10\" tile", reqYesNo: true, requirements: "Requires water hookup, responsible for fixing any damage or replacement if needed.", photo: "ChIJAxoZu9ZlaYcRDKzKqbeYlts"))
    }
}
