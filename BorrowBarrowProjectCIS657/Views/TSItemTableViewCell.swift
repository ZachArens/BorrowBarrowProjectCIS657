//
//  TSItemTableViewCell.swift
//  BorrowBarrowProjectCIS657
//
//  Created by Zachary Arens on 5/27/19.
//  Copyright © 2019 BarrelBox. All rights reserved.
//

import UIKit

class TSItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPicture: UIImageView!
    @IBOutlet weak var userThatHas: UILabel!
    @IBOutlet weak var itemDetails: UILabel!
    @IBOutlet weak var signalImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
