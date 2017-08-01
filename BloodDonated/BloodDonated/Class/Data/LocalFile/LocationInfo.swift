//
//  LocationInfo.swift
//  BloodDonated
//
//  Created by Nigel on 2017/8/1.
//  Copyright © 2017年 Nigel. All rights reserved.
//

import UIKit
import ObjectMapper

class LocationInfo: Mappable {

    var name: String?
    var address: String?
    var phone: String?
    var time: String?
    var comment: String?
    var geoCode: String?

    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        name                <- map["name"]
        address             <- map["address"]
        phone               <- map["phone"]
        time                <- map["time"]
        comment             <- map["comment"]
        geoCode             <- map["geoCode"]
    }
    
}
