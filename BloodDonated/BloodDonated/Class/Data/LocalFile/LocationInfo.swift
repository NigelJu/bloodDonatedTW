//
//  LocationInfo.swift
//  BloodDonated
//
//  Created by Nigel on 2017/8/1.
//  Copyright © 2017年 Nigel. All rights reserved.
//

import UIKit
import ObjectMapper
import CoreLocation

class LocationInfo: Mappable {

    var name: String?
    var address: String?
    var phone: String?
    var time: String?
    var comment: String?
    var geoCode: String?

    required init?(map: Map) {
        
    }

    func location() -> CLLocation? {
        guard let geoCodes = self.geoCode?.components(separatedBy: ","),
            let lat = Double(geoCodes[0]),
            let lng = Double(geoCodes[1]) else { return nil }
        return CLLocation(latitude: lat, longitude: lng)
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

