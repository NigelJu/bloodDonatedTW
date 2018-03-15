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

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    fileprivate var bloodInfos = [BloodData?]()
    fileprivate let SERVER_HTTP = "https://g0v.github.io/blood/blood.json"

    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicatorView.startAnimating()
        
        tableView.rowHeight = 130
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        
        /*
        Alamofire.request(SERVER_HTTP).responseObject { (response: DataResponse<BloodResponse>) in
            
            if let bloodResponse = response.result.value {
                
                self.bloodInfos.append(bloodResponse.taipei)
                self.bloodInfos.append(bloodResponse.hsinchu)
                self.bloodInfos.append(bloodResponse.taichun)
                self.bloodInfos.append(bloodResponse.tainan)
                self.bloodInfos.append(bloodResponse.kaohsiung)

                DispatchQueue.main.async {
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                    if let oriDate = bloodResponse.updateTime,
                        let date = dateFormatter.date(from: oriDate) {
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        self.navigationItem.title = "最後更新日期: " + dateFormatter.string(from: date)
                    }else {
                        self.navigationItem.title = "無法更新資料"
                    }
                    
                    
                    print(bloodResponse.updateTime)
                    
                    self.tableView.reloadData()
                    self.activityIndicatorView.stopAnimating()
                }
            }
        }

        */
        
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
        if let name = bloodInfo?.name {
            let nameIndex = name.index(name.startIndex, offsetBy: 2)
                    cell.areaLabel.text = name.substring(to: nameIndex)
        }
        


        cell.typeOImageView.image = UIImage(named: bloodInfo?.typeO?.imageName() ?? "")
        cell.typeBImageView.image = UIImage(named: bloodInfo?.typeB?.imageName() ?? "")
        cell.typeABImageView.image = UIImage(named: bloodInfo?.typeAB?.imageName() ?? "")
        cell.typeAImageView.image = UIImage(named: bloodInfo?.typeA?.imageName() ?? "")
        
        return cell
    }
}
