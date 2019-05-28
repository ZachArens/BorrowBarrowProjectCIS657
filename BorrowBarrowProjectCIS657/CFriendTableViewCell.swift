//
//  CFriendTableViewCell.swift
//  BorrowBarrowProjectCIS657
//
//  Created by Andy V. Vuong on 5/28/19.
//  Copyright © 2019 BarrelBox. All rights reserved.
//

import UIKit

class CFriendTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel! //Concat first and last name
    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet weak var numOfItems: UILabel!
    @IBOutlet weak var numOfLends: UILabel! //Number of successful lends
    @IBOutlet weak var userDetails: UILabel!
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
