//
//  BloodInfo.swift
//  BloodDonated
//
//  Created by Nigel on 2017/3/12.
//  Copyright © 2017年 Nigel. All rights reserved.
//

import UIKit


enum StoreType: String {
    
    case full = "BloodFull"     // 7天+
    case low = "BloodLow"       // 4天 -
    case normal = "BloodMed"    // 4-7天

}



class BloodInfo {

    var areaName = ""   // 地區名稱
    var storeTypes = [StoreType]() // 庫存類型

    
}
