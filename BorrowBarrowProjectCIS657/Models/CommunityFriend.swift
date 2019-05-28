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
    var zipcode: String?
    var trustYesNo: Bool?

    
    init(key: String?, firstName: String?, lastName: String?, email: String?, phoneNum: String?, address1: String?, address2: String?, city: String?, zipcode: String?, trustYesNo: Bool?)
    {
        self.key = key;
        self.firstName = firstName;
        self.lastName = lastName;
        self.email = email;
        self.phoneNum = phoneNum;
        self.address1 = address1;
        self.address2 = address2;
        self.city = city;
        self.zipcode = zipcode;
        self.trustYesNo = trustYesNo;
    }
    
    init(firstName: String?, lastName: String?, email: String?, phoneNum: String?, address1: String?, address2: String?, city: String?, zipcode: String?, trustYesNo: Bool?)
    {
        self.init(key: nil, firstName: firstName, lastName: lastName, email: email, phoneNum: phoneNum, address1: address1, address2: address2, city: city, zipcode: zipcode, trustYesNo: trustYesNo)
    }
    
    init() {
        self.init(key: nil, firstName: nil, lastName: nil, email: nil, phoneNum: nil, address1: nil, address2: nil, city: nil, zipcode: nil, trustYesNo: nil);
    }
    
}
