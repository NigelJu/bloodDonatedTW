//
//  LocationInfo.swift
//  BloodDonated
//
//  Created by Nigel on 2017/8/1.
//  Copyright © 2017年 Nigel. All rights reserved.
//

import UIKit
import CoreLocation

class LocationInfo : JsonCodable {

    var name: String?
    var address: String?
    var phone: String?
    var time: String?
    var comment: String?
    var geoCode: String?


    func location() -> CLLocation? {
        guard let geoCodes = self.geoCode?.components(separatedBy: ","),
            let lat = Double(geoCodes[0]),
            let lng = Double(geoCodes[1]) else { return nil }
        return CLLocation(latitude: lat, longitude: lng)
    }
    
}

