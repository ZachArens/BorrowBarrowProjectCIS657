//
//  UnderlinedTextField.swift
//  BorrowBarrowProjectCIS657
//
//  Created by Andy Vong on 5/24/19.
//  Copyright © 2019 BarrelBox. All rights reserved.
//

import UIKit

class UnderlinedTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    /*
     The following subclass is based on and from the following source. Credit to author:
     https://blog.haloneuro.com/uitextfield-with-focus-underline-in-ios-14da1d9203d9
     */
    
     @IBOutlet weak var underlineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        underlineView.backgroundColor = UIColor.lightGray
        
        // Highlight/unhighlight the underlined view when it's being edited.
        reactive.controlEvents(.editingDidBegin).map { _ in
            return UIColor.green
            }.bind(to: underlineView.reactive.backgroundColor).dispose(in: reactive.bag)
        
        reactive.controlEvents(.editingDidEnd).map { _ in
            return UIColor.lightGray
            }.bind(to: underlineView.reactive.backgroundColor).dispose(in: reactive.bag)
    }
    

}
