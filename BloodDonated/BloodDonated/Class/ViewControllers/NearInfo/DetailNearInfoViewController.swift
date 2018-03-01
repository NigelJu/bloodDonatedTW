//
//  DetailNearInfoViewController.swift
//  捐血趣
//
//  Created by Nigel on 2018/2/27.
//  Copyright © 2018年 Nigel. All rights reserved.
//

import UIKit
import CoreLocation

class DetailNearInfoViewController: UIViewController {
    
    @IBOutlet weak var stationTitleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    
    // 由外部傳遞資料
    var info: LocationInfo?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stationTitleLabel.text = info?.name
        addressLabel.text = info?.address
        commentLabel.text = info?.comment
        phoneLabel.text = info?.phone
        timeLabel.text = info?.time
    }
    
    
    @IBAction func dialButtonDidSelect(_ sender: Any) {
        
        guard let phone = info?.phone,
            phone.count > 0
            else {
                UIAlertController.alert(title: "警告", message: "無此站號碼").otherHandle(alertAction: nil).show(currentVC: self)
                return
        }
        
        let phoneUrl = "tel://" + phone
        
        if !successOpenUrl(withString: phoneUrl) {
            print("GG")
        }
        
    }
    
    
    @IBAction func navigationButtonDidSelect(_ sender: Any) {
        
        UIAlertController.alert(title: "請選擇導航app", message: "若無法開啟您所選擇的app, 將為您導至appStore", style: .actionSheet)
            .otherHandle(title: "AppleMap") { (action) in
                guard let geoCode = self.info?.geoCode else { return }
                self.successOpenUrl(withString: "http://maps.apple.com/?daddr=" + geoCode)
            }.otherHandle(title: "GoogleMap", alertAction: { (action) in
                 guard let geoCode = self.info?.geoCode else { return }
                // 導至appleStore
                if !self.successOpenUrl(withString: "comgooglemaps://?saddr=&daddr=" + geoCode) {
                    self.successOpenUrl(withString: "itms-apps://itunes.apple.com/app/id585027354")
                }
            }).cancleHandle(alertAction: nil)
            .show(currentVC: self)
        
        
        
        
        
    }
    
}


extension DetailNearInfoViewController {
    // 是否成功開啟url
    @discardableResult fileprivate func successOpenUrl(withString urlString: String) -> Bool {
        guard let url = URL(string: urlString),
            UIApplication.shared.canOpenURL(url)
            else { return false }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        return true
    }    
}
