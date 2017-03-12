//
//  BloodStoreViewController.swift
//  BloodDonated
//
//  Created by Nigel on 2017/3/12.
//  Copyright © 2017年 Nigel. All rights reserved.
//

import UIKit

/*
 庫存量VC
*/

class BloodStoreViewController: UIViewController {

    var bloodInfos = [BloodInfo]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let session = SessionTask()
        session.fetchBloodInfo()
    }
    
    
}


// MARK:- TableViewDelegate, TableDataSourceDelegate
extension BloodStoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bloodInfos.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bloodStoreCell", for: indexPath) as! BloodStoreCellTableViewCell
        
        let bloodInfo = bloodInfos[indexPath.row]
        
        let stackViews = cell.bloodInfoStackView.subviews
        
        for (index, stackView) in stackViews.enumerated() {
            (stackView as? UILabel)?.text = bloodInfo.areaName
            (stackView as? UIImageView)?.image = UIImage(named: bloodInfo.storeTypes[index - 1].rawValue)
        }
        
        return cell
    }
}
