//
//  BloodResponse.swift
//  BloodDonated
//
//  Created by Nigel on 2017/8/1.
//  Copyright © 2017年 Nigel. All rights reserved.
//

import UIKit
import ObjectMapper

class BloodResponse: Mappable {
   
    var updateTime: String?
    var taipei: BloodData?
    var hsinchu: BloodData?
    var taichun: BloodData?
    var tainan: BloodData?
    var kaohsiung: BloodData?
    
    
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        updateTime      <- map["time"]
        taipei          <- map["台北捐血中心"]
        hsinchu         <- map["新竹捐血中心"]
        taichun         <- map["台中捐血中心"]
        tainan          <- map["台南捐血中心"]
        kaohsiung       <- map["高雄捐血中心"]
    }

}

class BloodData: Mappable {

    var typeA: bloodStorage?
    var typeB: bloodStorage?
    var typeAB: bloodStorage?
    var typeO: bloodStorage?
    var name: String?
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        typeA           <- map["StorageA"]
        typeB           <- map["StorageB"]
        typeAB          <- map["StorageAB"]
        typeO           <- map["StorageO"]
        name            <- map["name"]
    }
}
enum bloodStorage: String {
    case medium = "medium"
    case full = "full"
    case low = "low"
    
    func imageName() -> String {
        switch self {
        case .medium:
            return "BloodMed"
        case .full:
            return "BloodFull"
        case .low:
            return "BloodLow"
     
            
        }
        
    }
}

class bloodStorage2: Mappable {
    
    var medium: String?
    var full: String?
    var low: String?
  
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        medium          <- map["medium"]
        full            <- map["full"]
        low             <- map["low"]
    }
}
