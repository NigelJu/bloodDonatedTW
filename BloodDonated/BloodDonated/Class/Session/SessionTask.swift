//
//  SessionTask.swift
//  BloodDonated
//
//  Created by Nigel on 2017/3/12.
//  Copyright © 2017年 Nigel. All rights reserved.
//

import UIKit

class SessionTask {

    let bloodOpenDataWebSite = "http://nigelju.github.io/blood/blood.json"
    
    func fetchBloodInfo() {
        if let url = URL(string: bloodOpenDataWebSite) {
            let session = URLSession.shared
            let task = session.dataTask(with: url,
                             completionHandler: { (data, response, error) in
                                

                                if let data = data {
                                   let json = JSON(data: data)
                                    
                                    for (title, subJson): (String, JSON) in json {
                                        print("index = \(title), subJson = \(subJson)")
                                    }
                                    
                                    
                                    
                                }
                                
            })
            task.resume()
        }
        
        
    }
    
    
    
}
