//
//  BloodResponse.swift
//  BloodDonated
//
//  Created by Nigel on 2017/8/1.
//  Copyright © 2017年 Nigel. All rights reserved.
//

import UIKit

class BloodData {
    
    var typeA: bloodStorage?
    var typeB: bloodStorage?
    var typeAB: bloodStorage?
    var typeO: bloodStorage?
    var name: String?
    
}
enum bloodStorage: String {
    case medium = "medium"
    case full = "full"
    case low = "empty"
    
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


