//
//  NearInfoTableViewController.swift
//  捐血趣
//
//  Created by Nigel on 2018/2/23.
//  Copyright © 2018年 Nigel. All rights reserved.
//

import UIKit

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
    var infos: (distance: String, locationInfos: AreaLocationInfo )? {
        didSet {
            guard let title = infos?.locationInfos.title,
            let distance =  infos?.distance else { return }
            areaButton.setTitle(title + ", " + distance, for: .normal)
            nearTableView.reloadData()
        }
        
    }
    
    // 搜尋條按的按鈕由外部資料決定
    var userSelectCondition: (title: String, distance: String)? {
        didSet {
            guard let title = userSelectCondition?.title,
            let distance = userSelectCondition?.distance else { return }
            areaButton.setTitle(title + ", " + distance, for: .normal)
        }
        
    }
    
    
    @IBAction func areaButtonDidSelect(_ sender: UIButton) {
        delegate?.areaButtonDidTap(sender: sender)
    }
}



// MARK:- UITableViewDelegate, UITableViewDataSource
extension NearInfoTableViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infos?.locationInfos.infos?.count ?? 0
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell") as! NearBloodStationInfoTableViewCell
        if let info = infos?.locationInfos.infos?[indexPath.row] {
            cell.titleLabel.text = info.name
        }
        return cell
    }
    
   
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let info = infos?.locationInfos.infos?[indexPath.row] else { return }
        delegate?.cellDidSelect(cellInfo: info)
    }
    
    
    
    
}
