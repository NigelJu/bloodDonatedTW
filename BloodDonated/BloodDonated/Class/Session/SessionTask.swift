//
//  SessionTask.swift
//  BloodDonated
//
//  Created by Nigel on 2017/3/12.
//  Copyright © 2017年 Nigel. All rights reserved.
//

import UIKit
import AlamofireObjectMapper
import Alamofire

class SessionTask {
    //
    // http://nigelju.github.io/blood/blood.json
    let SERVER_HTTP = "https://g0v.github.io/blood/blood.json"
    /*
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
    */
    
    func fetchBloodInfo(){
    
        Alamofire.request(SERVER_HTTP).responseObject { (response: DataResponse<BloodResponse>) in
            
            let bloodResponse = response.result.value
            print(bloodResponse?.tainan?.typeA)
            
//            if let threeDayForecast = weatherResponse?.threeDayForecast {
//                for forecast in threeDayForecast {
//                    print(forecast.day)
//                    print(forecast.temperature)
//                }
//            }
            

        }
        
        
        
        
    }
}
