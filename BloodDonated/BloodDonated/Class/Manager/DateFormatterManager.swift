//
//  DateFormatterManager.swift
//  一起捐血趣
//
//  Created by Nigel on 2018/3/27.
//  Copyright © 2018年 Nigel. All rights reserved.
//

import UIKit

class DateFormatterManager: DateFormatter {

    static let shareInstance = DateFormatterManager()
    
    func dateFromFormate(date: String ,style: String) -> Date? {
        self.dateFormat = style
        return self.date(from: date)
    }
    
    func stringFromDateFormate(date: Date) -> String {
        self.dateFormat = "YYYY-MM-dd"
        return self.string(from: date)

    }
    
}
