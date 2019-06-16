//
//  ToolShedItem.swift
//  BorrowBarrowProjectCIS657
//
//  Created by Zachary Arens on 5/27/19.
//  Copyright © 2019 BarrelBox. All rights reserved.
//

import Foundation

struct ToolShedItem {
    var key : String?
    var itemName : String?
    var owner: String?
    var itemDescription: String?
    var reqYesNo: Bool?
    var requirements: String?
    var photoURL: String?
    var thumbnailURL: String?
    var lentTo: String?
    var dbId: String?
    
    init(key: String?, itemName: String?, owner: String?, itemDescription: String?, reqYesNo: Bool?, requirements: String?, photoURL: String?, thumbnailURL: String?, lentTo: String?)
    {
        self.key = key
        self.itemName = itemName
        self.owner = owner
        self.itemDescription = itemDescription
        self.reqYesNo = reqYesNo
        self.requirements = requirements
        self.photoURL = photoURL
        self.thumbnailURL = thumbnailURL
        self.lentTo = lentTo
    }
    
    init(itemName: String?, owner: String?, itemDescription: String?, reqYesNo: Bool?, requirements: String?, photoURL: String?, thumbnailURL: String?, lentTo: String?)
    {
        self.init(key: nil, itemName: itemName, owner: owner, itemDescription: itemDescription, reqYesNo: reqYesNo, requirements: requirements, photoURL: photoURL, thumbnailURL: thumbnailURL, lentTo: lentTo)
    }
    
    init() {
        self.init(key: nil, itemName: nil, owner: nil, itemDescription: nil, reqYesNo: nil, requirements: nil, photoURL: nil, thumbnailURL: nil, lentTo: nil)
    }
    
    mutating func addDBID(dbId: String?) {
        self.dbId = dbId
    }
    
}
