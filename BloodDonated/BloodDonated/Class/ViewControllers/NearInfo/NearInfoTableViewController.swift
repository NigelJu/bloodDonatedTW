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
    func cellDidSelect(cellInfo: Any)
}

class NearInfoTableViewController: UIViewController {
    var delegate: NearInfoTableViewControllerDelegate?
}

// MARK:- UITableViewDelegate, UITableViewDataSource
extension NearInfoTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell") as! UITableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "areaHeaderCell") 
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        delegate?.cellDidSelect(cellInfo: "123")
    }
    
    
}
