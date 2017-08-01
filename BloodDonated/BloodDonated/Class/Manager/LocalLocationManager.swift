//
//  LocalLocationManager.swift
//  BloodDonated
//
//  Created by Nigel on 2017/8/1.
//  Copyright © 2017年 Nigel. All rights reserved.
//

import UIKit
import ObjectMapper
class LocalLocationManager {

    func locationInfo(withFileName fileName: String) -> [LocationInfo]? {
        
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
           
            if let data = data {
                let jsonObj = JSON(data: data)
                return Mapper<LocationInfo>().mapArray(JSONString: jsonObj.description)
            }
        }
        return nil

    }
    
}
