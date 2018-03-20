//
//  NearInfoViewController.swift
//  BloodDonated
//
//  Created by Nigel on 2017/8/1.
//  Copyright © 2017年 Nigel. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AreaLocationInfo {
    // 區域名稱
    var title: String?
    // 各捐血站資料
    var infos: [LocationInfo]?
}


enum DistanceInfo: String {
    case near = "3公里"
    case far = "5公里"
    case none = "不限"
    
    func allValues() -> [DistanceInfo] {
        return [.near, .far, .none]
    }
    
    func meterDistance() -> Double {
        
        let KM_DISTANCE: Double = 1000
        
        switch self {
        case .near:
            return 3 * KM_DISTANCE
        case .far:
            return 5 * KM_DISTANCE
        case .none:
            return 400 * KM_DISTANCE
        }
        
    }
}

fileprivate enum AreaInfo: String {
    case taipei = "Taipei"
    case hsinchu = "Hsinchu"
    case taichung = "Taichung"
    case tainan = "Tainan"
    case kaoushun = "Kaoushun"
    case haoulain = "Haoulain"

    static let allValues = [taipei, hsinchu, taichung, tainan, kaoushun, haoulain]
    
    func title() -> String {
        switch self {
        case .taipei:
            return "台北"
        case .hsinchu:
            return "新竹"
        case .taichung:
            return "台中"
        case .tainan:
            return "台南"
        case .kaoushun:
            return "高雄"
        case .haoulain:
            return "花蓮"
        }
    }

}


class NearInfoViewController: UIViewController {

    fileprivate let locationManager = CLLocationManager()
    fileprivate var shouldRequestLocationAuthorization = true
    fileprivate var nearInfoTableVC: NearInfoTableViewController?

    // 所有捐血站資料
    fileprivate var allAreaInfos = [AreaLocationInfo]()
    // 記錄選取的捐血站資料
    fileprivate var infoRecord: (distance: DistanceInfo, areaSelectIndex: Int) = (.near, AreaInfo.taipei.hashValue)

    @IBOutlet weak var tableContainerView: UIView!
    @IBOutlet weak var distanceSegmentedControl: UISegmentedControl!
    @IBOutlet weak var areaSegmentedControl: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!

    
    // MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
       
        // 基本設置, 取得本機檔案中所有捐血中資料
        for info in AreaInfo.allValues {
            let areaInfo = AreaLocationInfo()
            areaInfo.title = info.title()
            guard let path = Bundle.main.path(forResource: info.rawValue, ofType: "json") else { return }
            let url = URL(fileURLWithPath: path)
            guard let data = try? Data(contentsOf: url) else { return }
            areaInfo.infos = [LocationInfo](data: data)
            allAreaInfos.append(areaInfo)
        }

        // 取得列表VC, 並設置列表預設資料
        for case let vc as NearInfoTableViewController in self.childViewControllers  {
            nearInfoTableVC = vc
            nearInfoTableVC?.delegate = self
        }
        

        // 將選擇的地區設為離自己最近的地區
        updateNearAreaLocationInfo(withDistanceMeter: infoRecord.distance.meterDistance())
        nearInfoTableVC?.infos = (infoRecord.distance.rawValue, allAreaInfos[infoRecord.areaSelectIndex].title, nearLocationInfos() )
        
        // 在地圖上插針
        refreshAnnotations()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestLocationAuthorization(status: CLLocationManager.authorizationStatus())

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // 將條件資訊傳遞給pickerVC
        if let pickerVC = segue.destination as? SelectAreaViewController {
            var titles = [String]()
            // 只需將地區的資料傳給pickerVC
            for info in allAreaInfos {
                titles.append(info.title ?? "")
            }
            pickerVC.pickarInfos = (infoRecord.distance, infoRecord.areaSelectIndex, titles)
          
            // pickerView點選確認後, 更新被點選的資料以及列表的資訊
            pickerVC.okButtonDidSelectClousure = { [weak self] (distanceInfo, didSelectAreaIndex) in
                
                // 更新自身的資料
                self?.infoRecord = (distanceInfo, didSelectAreaIndex)
                
                // 把更新後的資料帶給列表
                guard let distanceInfo = self?.infoRecord.distance,
                    let areaIndex = self?.infoRecord.areaSelectIndex,
                    let title = self?.allAreaInfos[areaIndex].title,
                    let locationInfo = self?.nearLocationInfos() else { return }
                self?.nearInfoTableVC?.infos = (distanceInfo.rawValue, title, locationInfo )
                
                // 更新地圖的pin
                self?.refreshAnnotations()

            }
            return
        }
        
        
        // 詳細資料VC
        if let detailVC = segue.destination as? DetailNearInfoViewController {
            detailVC.info = sender as? LocationInfo
        }
        
    }
    
    // MARK:- IBAction
    
    @IBAction func mapViewDidTap(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = false
        self.tableContainerView.isHidden = true
    }
    
    @IBAction func CenterButtonDidSelect(_ sender: Any) {
        let userLocation = mapView.userLocation.coordinate
        setMapViewCenter(at: userLocation)
    }
    
    @IBAction func ListButtonDIdSelect(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = !(self.tabBarController?.tabBar.isHidden ?? true)
        self.tableContainerView.isHidden = !self.tableContainerView.isHidden
    }
    
}
// MARK:- NearInfoTableViewControllerDelegate
extension NearInfoViewController: NearInfoTableViewControllerDelegate {
    func areaButtonDidTap(sender: UIButton) {
        performSegue(withIdentifier: "areaPicker", sender: nil)
    }
    
    func cellDidSelect(cellInfo: LocationInfo) {
        performSegue(withIdentifier: "infoDetail", sender: cellInfo)
    }
}


// MARK:- MKMapViewDelegate
extension NearInfoViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        self.tabBarController?.tabBar.isHidden = true
        self.tableContainerView.isHidden = false
        
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        nearInfoTableVC?.userLocation = userLocation.location
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print("annotation = \(annotation)")
        return nil
    }
    
}

// MARK:- CLLocationManagerDelegate
extension NearInfoViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        requestLocationAuthorization(status: status)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(locations)
        
    }
}

// MARK:- privateFunction
fileprivate extension NearInfoViewController {
    
    // 將使用者位置重新設定為中心
    func setMapViewCenter(at coordinate: CLLocationCoordinate2D) {
        let fixedCenter = CLLocationCoordinate2D(latitude: coordinate.latitude , longitude: coordinate.longitude)
        mapView.setCenter(fixedCenter, animated: true)
    }
    
    // 取得定位權限
    func requestLocationAuthorization(status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse {
            UIAlertController.alert(title: "警告", message: "無定位權限, 請至設定中開啟" )
                .otherHandle(alertAction: nil)
                .show(currentVC: self)
        }else if status == .authorizedWhenInUse {
            shouldRequestLocationAuthorization = false
        }
    }
    
    
    // 將記錄更新為距離近的捐血站地點
    func updateNearAreaLocationInfo(withDistanceMeter meter: Double) {
        for (index, areaInfo) in allAreaInfos.enumerated() {
            for localInfo in areaInfo.infos ?? [] {
                if isNear(withLocationInfo: localInfo, distanceMeter: meter) {
                    infoRecord.areaSelectIndex = index
                    return
                }
            }
        }
    }
    
    // 取得附近的捐血站資料
    func nearLocationInfos() -> [LocationInfo] {
        var nearLocationInfos = [LocationInfo]()
        for locationInfo in allAreaInfos[infoRecord.areaSelectIndex].infos ?? [] {
            if isNear(withLocationInfo: locationInfo, distanceMeter: infoRecord.distance.meterDistance()) {
                nearLocationInfos.append(locationInfo)
            }
        }
        return nearLocationInfos
    }
 
    // 更新地圖上的pin點
    func refreshAnnotations() {
        
        mapView.removeAnnotations(mapView.annotations)
        
        var annotations = [MKPointAnnotation]()
        for locationInfo in nearLocationInfos() {
            guard let location = locationInfo.location() else { continue }
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = locationInfo.name
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
        
        let userAnnotation = MKPointAnnotation()
        guard let userCoordinate = locationManager.location?.coordinate else {
            mapView.showAnnotations(mapView.annotations, animated: true)
            return
        }
        // 把自己加入, 才會在中間, 畫面才會有呈現使用者位置
        userAnnotation.coordinate = userCoordinate
        annotations.append(userAnnotation)
        mapView.showAnnotations(annotations, animated: true)
        
        // 再把自己刪掉, 不然會多一個pin
        for mapViewAnnotation in mapView.annotations
            where mapViewAnnotation.coordinate.latitude == userCoordinate.latitude
                && mapViewAnnotation.coordinate.longitude == userCoordinate.longitude {
            mapView.removeAnnotation(mapViewAnnotation)
        }
    }
    
    // 是否鄰近所輸入的捐血站
    func isNear(withLocationInfo localInfo: LocationInfo, distanceMeter meter: Double) -> Bool {
        guard let location = localInfo.location(),
            let currentLocation = locationManager.location else { return false }
        let differMeter = location.distance(from: currentLocation)
        return differMeter <= meter
    }
}
