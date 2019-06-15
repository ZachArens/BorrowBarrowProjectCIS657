//
//  CommunityFriend.swift
//  BorrowBarrowProjectCIS657
//
//  Created by Andy V. Vuong on 5/28/19.
//  Copyright © 2019 BarrelBox. All rights reserved.
//

import Foundation

struct CommunityFriend {
    var key : String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var phoneNum: String?
    var address1: String?
    var address2: String?
    var city: String?
    var state: String?
    var zipcode: String?
    var trustYesNo: Bool?
    var friendPhoto: String?
    var numLends: Int
    var numItems: Int

    
    init(key: String?, firstName: String?, lastName: String?, email: String?, phoneNum: String?, address1: String?, address2: String?, city: String?, state: String?, zipcode: String?, trustYesNo: Bool?, friendPhoto: String?, numLends: Int, numItems: Int)
    {
        self.key = key;
        self.firstName = firstName;
        self.lastName = lastName;
        self.email = email;
        self.phoneNum = phoneNum;
        self.address1 = address1;
        self.address2 = address2;
        self.city = city;
        self.state = state;
        self.zipcode = zipcode;
        self.trustYesNo = trustYesNo;
        self.friendPhoto = friendPhoto;
    }
    
    init(firstName: String?, lastName: String?, email: String?, phoneNum: String?, address1: String?, address2: String?, city: String?, state: String?, zipcode: String?, trustYesNo: Bool?, friendPhoto: String?, numLends: Int, numItems: Int)
    {
        self.init(key: nil, firstName: firstName, lastName: lastName, email: email, phoneNum: phoneNum, address1: address1, address2: address2, city: city, state: state, zipcode: zipcode, trustYesNo: trustYesNo, friendPhoto: friendPhoto, numLends: numLends, numItems: numItems)
    }
    
    init() {
        self.init(key: nil, firstName: nil, lastName: nil, email: nil, phoneNum: nil, address1: nil, address2: nil, city: nil, state: nil, zipcode: nil, trustYesNo: nil, friendPhoto: nil, numLends: 0, numItems: 0);
    }
    
}
