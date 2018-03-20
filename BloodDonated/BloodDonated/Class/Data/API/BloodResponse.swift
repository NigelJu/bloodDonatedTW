//
//  BloodResponse.swift
//  BloodDonated
//
//  Created by Nigel on 2017/8/1.
//  Copyright © 2017年 Nigel. All rights reserved.
//

import UIKit

class BloodData {
    
    var typeA: BloodStorage?
    var typeB: BloodStorage?
    var typeAB: BloodStorage?
    var typeO: BloodStorage?
    var name = String()
    
}
enum BloodStorage: String {
    case medium = "images/StorageIcon002.png"      // 庫存量4到7日
    case low = "images/StorageIcon001.png"        // 庫存量4日以下
    case full = "images/StorageIcon003.png"         // 庫存量7日以上
    
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


