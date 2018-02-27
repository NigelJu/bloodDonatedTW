//
//  SettingTableViewController.swift
//  BloodDonated
//
//  Created by Nigel on 2017/8/3.
//  Copyright © 2017年 Nigel. All rights reserved.
//

import UIKit
import CoreLocation

class SettingTableViewController: UITableViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        

        cell.accessoryType = CLLocationManager.authorizationStatus() == .authorizedWhenInUse ? .checkmark : .disclosureIndicator
        

        return cell
    }
    


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse,
            let settingUrl = URL(string: UIApplicationOpenSettingsURLString) {
            
            UIApplication.shared.open(settingUrl, options: [:], completionHandler: nil)
            
        }
    }

}
