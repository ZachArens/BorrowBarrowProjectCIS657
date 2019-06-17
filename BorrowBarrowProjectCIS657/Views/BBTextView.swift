//
//  BBTextView.swift
//  BorrowBarrowProjectCIS657
//
//  Created by Zachary Arens on 6/16/19.
//  Copyright © 2019 BarrelBox. All rights reserved.
//

import UIKit

class BBTextView: UITextView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        //TODO - add placehoder text in greyed out text.
        //Code from https://www.ios-blog.com/tutorials/swift/how-to-change-the-placeholder-color-using-swift-extensions-or-user-defined-runtime-attributes/
        //    self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: BACKGROUND_COLOR]);
        
        self.layer.borderWidth = 1.0
    }


}
