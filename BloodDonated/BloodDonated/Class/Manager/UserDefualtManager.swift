//
//  UserDefualtManager.swift
//  一起捐血趣
//
//  Created by Nigel on 2018/3/27.
//  Copyright © 2018年 Nigel. All rights reserved.
//

import UIKit

fileprivate let LAST_UPDATE_TIME = "lastUpdateTime"

class UserDefualtManager {

    static let shareInstance = UserDefualtManager()
    
    
    
    func lastUpdateTime() -> String? {
        return UserDefaults.standard.object(forKey: LAST_UPDATE_TIME) as? String
    }
    
    @discardableResult func updateLastUpdateTime(time: String) -> Bool {
        UserDefaults.standard.setValue(time, forKey: LAST_UPDATE_TIME)
        return UserDefaults.standard.synchronize()
    }
    
    
}
