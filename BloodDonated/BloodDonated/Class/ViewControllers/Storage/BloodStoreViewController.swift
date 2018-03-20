//
//  BloodStoreViewController.swift
//  BloodDonated
//
//  Created by Nigel on 2017/3/12.
//  Copyright © 2017年 Nigel. All rights reserved.
//

import UIKit

fileprivate enum ParseBloodType: Int {
    case area
    case typeA
    case typeB
    case typeO
    case typeAB
}

class BloodStoreViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    fileprivate var bloodInfos = [BloodData?]()
    
    
    fileprivate let bloodXpath = "//*[@id='blood-table']/table[2]"
    fileprivate let lastUpdateTimeXpath = "//*[@id='blood-table']/table[1]"
    fileprivate let html = "http://www.blood.org.tw/Internet/main/index.aspx"
    
    
    fileprivate var lastUpdateTime: String? {
        didSet {
            // 撈完資料, 重整UI
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activityIndicatorView.stopAnimating()
                self.navigationItem.title = self.lastUpdateTime
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorView.startAnimating()
        tableView.rowHeight = 130
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        
        // 爬資料
        DispatchQueue.global(qos: .default).async {
            self.parseBloodInfo()
            self.parseBloodUpdateTime()
        }
    }
}

// MARK:- fileprivate Function
fileprivate extension BloodStoreViewController {
    
    func parseBloodUpdateTime() {
        guard let url = URL(string: html),
            let bloodData = try? Data(contentsOf: url),
            let bloodDoc = Ji(htmlData: bloodData) else { return }
        let updateTimeNode = bloodDoc.xPath(lastUpdateTimeXpath)
        guard let updateTime = updateTimeNode?.first?.childrenWithName("tr").first?.content 
            else { return }
        
        let trimUpdateTime = updateTime.replacingOccurrences(of: "\r\n", with: "").replacingOccurrences(of: " ", with: "")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "最新更新時間：yyyy年MM月dd日HH時mm分"
        let oriDate = trimUpdateTime
        if let date = dateFormatter.date(from: oriDate) {
            dateFormatter.dateFormat = "最後更新: yyyy-MM-dd"
            self.lastUpdateTime = dateFormatter.string(from: date)
        }else {
            self.lastUpdateTime = "更新失敗..."
        }
    }
    
    func parseBloodInfo() {

        guard let url = URL(string: html),
            let bloodData = try? Data(contentsOf: url),
            let bloodDoc = Ji(htmlData: bloodData) else { return }
        let bloodNode = bloodDoc.xPath(bloodXpath)
        guard let bloodNodes = bloodNode?.first?.children else { return }

        
        for (index, bloodNode) in bloodNodes.enumerated() {
            guard let parseType = ParseBloodType.init(rawValue: index) else { return }
            switch parseType {
            case .area:
                for area in areas(node: bloodNode) {
                    let bloodInfo = BloodData()
                    bloodInfo.name = area
                    bloodInfos.append(bloodInfo)
                }
            case .typeA:
                for (index, storageInfo) in bloodStorages(node: bloodNode).enumerated() {
                    bloodInfos[index]?.typeA = BloodStorage(rawValue: storageInfo)
                }
            case .typeB:
                for (index, storageInfo) in bloodStorages(node: bloodNode).enumerated() {
                    bloodInfos[index]?.typeB = BloodStorage(rawValue: storageInfo)
                }
            case .typeO:
                for (index, storageInfo) in bloodStorages(node: bloodNode).enumerated() {
                    bloodInfos[index]?.typeO = BloodStorage(rawValue: storageInfo)
                }
            case .typeAB:
                for (index, storageInfo) in bloodStorages(node: bloodNode).enumerated() {
                    bloodInfos[index]?.typeAB = BloodStorage(rawValue: storageInfo)
                }
            }
        }
    }
    
    // 取得地址資料
    func areas(node: JiNode) -> [String] {
        var parserAreas = [String]()
        for areaNode in node.children where areaNode.content?.count ?? 0 > 0 {
            parserAreas.append(areaNode.content!)
        }
        return parserAreas
    }
    
    func bloodStorages(node: JiNode) -> [String] {
        var stoages = [String]()
        for bloodNode in node.children {
            guard let storage = bloodNode.childrenWithName("img").first?.attributes["src"],
                storage.count > 0  else { continue }
            stoages.append(storage)
        }
        return stoages
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
