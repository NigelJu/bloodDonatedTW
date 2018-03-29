//
//  Encodable+Extenstion.swift
//  一起捐血趣
//
//  Created by Nigel on 2018/3/29.
//  Copyright © 2018年 Nigel. All rights reserved.
//

import UIKit

// 轉成dictionary
extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
    var array: [Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [Any]
        
    }
    
}
