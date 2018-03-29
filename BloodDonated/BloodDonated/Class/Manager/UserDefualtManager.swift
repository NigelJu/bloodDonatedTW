//
//  UserDefualtManager.swift
//  一起捐血趣
//
//  Created by Nigel on 2018/3/27.
//  Copyright © 2018年 Nigel. All rights reserved.
//

import UIKit

fileprivate let LAST_UPDATE_TIME = "lastUpdateTime"
fileprivate let BLOOD_INFOS = "bloodInfos"

class UserDefualtManager {

    static let shareInstance = UserDefualtManager()

    
  
    // 取得最後更新時間
    func lastUpdateTime() -> String? {
        return UserDefaults.standard.object(forKey: LAST_UPDATE_TIME) as? String
    }
    
    // 更新最後撈捐血資料的時間
    @discardableResult func updateLastUpdateTime(time: String) -> Bool {
        UserDefaults.standard.setValue(time, forKey: LAST_UPDATE_TIME)
        return UserDefaults.standard.synchronize()
    }
    
    // 取得本機捐血站資料
    func bloodInfos() -> [BloodData?]? {
        guard let dict = UserDefaults.standard.object(forKey: BLOOD_INFOS) as? [Dictionary<String, Any?>] else { return nil }
   
        return [BloodData](json: dict)
    }
    
    
    // 更新捐血站資料
    @discardableResult func updateBloodInfos(bloodInfos: [BloodData?]) -> Bool {
       
        if let array = bloodInfos.array {
            
            UserDefaults.standard.set(array, forKey: BLOOD_INFOS)
            
            return UserDefaults.standard.synchronize()
        }
        
        return false
    }
    
}
