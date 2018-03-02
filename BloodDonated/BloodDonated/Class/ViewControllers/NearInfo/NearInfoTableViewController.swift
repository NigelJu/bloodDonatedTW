//
//  NearInfoTableViewController.swift
//  捐血趣
//
//  Created by Nigel on 2018/2/23.
//  Copyright © 2018年 Nigel. All rights reserved.
//

import UIKit
import CoreLocation

// MARK:- Protocol
protocol NearInfoTableViewControllerDelegate {
    func cellDidSelect(cellInfo: LocationInfo)
    func areaButtonDidTap(sender: UIButton)
}

class NearInfoTableViewController: UIViewController {
    @IBOutlet weak var areaButton: UIButton!
    @IBOutlet weak var nearTableView: UITableView!
    var delegate: NearInfoTableViewControllerDelegate?
    
    // 由外部決定資料
    var infos: (distance: String, title: String?, locationInfos: [LocationInfo] )? {
        didSet {
            guard let title = infos?.title,
            let distance =  infos?.distance else { return }
            areaButton.setTitle(title + ", " + distance, for: .normal)
            nearTableView.reloadData()
        }
    }
    
    // 由外部更新使用者位址
    var userLocation: CLLocation? {
        didSet {
            nearTableView.reloadData()
        }
    }

    @IBAction func areaButtonDidSelect(_ sender: UIButton) {
        delegate?.areaButtonDidTap(sender: sender)
    }
}



// MARK:- UITableViewDelegate, UITableViewDataSource
extension NearInfoTableViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infos?.locationInfos.count ?? 0
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell") as! NearBloodStationInfoTableViewCell
        if let info = infos?.locationInfos[indexPath.row] {
            cell.titleLabel.text = info.name
            if let userLocation = userLocation,
                let infoLocation = info.location(){
                let differMeter = userLocation.distance(from: infoLocation)
                var distance = ""
                // 超過1km 用km單位, 否則為m單位
                if differMeter >= 1000 {
                    
                    distance = String(format: "%.2f", differMeter / 1000 )
                    cell.distanceLabel.text = distance + "公里"
                    
                }else {
                    distance = String(format: "%.2f", differMeter  )
                    cell.distanceLabel.text = distance + "公尺"
                }
        }
    }
    return cell
}
    
   
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let info = infos?.locationInfos[indexPath.row] else { return }
        delegate?.cellDidSelect(cellInfo: info)
    }
    
    
    
    
}
