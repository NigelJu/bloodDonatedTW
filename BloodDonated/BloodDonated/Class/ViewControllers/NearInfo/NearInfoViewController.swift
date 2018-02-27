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

fileprivate class NearLocationInfo {
    var allAreaInfos = [[LocationInfo]?]()
}

fileprivate enum DistanceInfo: Int {
    case threeKM
    case fiveKM
    case none
    
    func meterDistance() -> Double {
        
        let KM_DISTANCE: Double = 1000
        
        switch self {
        case .threeKM:
            return 3 * KM_DISTANCE
        case .fiveKM:
            return 5 * KM_DISTANCE
        case .none:
            return 400 * KM_DISTANCE
        }
        
    }
}

fileprivate enum AreaInfo: Int {
    case taipei
    case hsinchu
    case taichung
    case tainan
    case kaoushun
    case haoulain
    
    func fileName() -> String {
        switch self {
        case .taipei:
            return "Taipei"
        case .hsinchu:
            return "Hsinchu"
        case .taichung:
            return "Taichung"
        case .tainan:
            return "Tainan"
        case .kaoushun:
            return "Kaoushun"
        case .haoulain:
            return "Haoulain"
        }
        
    }
}


class NearInfoViewController: UIViewController {

    fileprivate let locationManager = CLLocationManager()
    fileprivate let localInfoManager = LocalLocationManager()
    
    fileprivate var shouldRequestLocationAuthorization = true
    
    fileprivate var nearInfoTableVC: NearInfoTableViewController?
   
    @IBOutlet weak var tableContainerView: UIView!
    
    fileprivate var localInfos = NearLocationInfo()
    
    @IBOutlet weak var distanceSegmentedControl: UISegmentedControl!
    @IBOutlet weak var areaSegmentedControl: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK:- LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
       
        
        // 取得位置資訊
        localInfos.allAreaInfos.append(localInfoManager.locationInfo(withFileName: AreaInfo.taipei.fileName()))
        localInfos.allAreaInfos.append(localInfoManager.locationInfo(withFileName: AreaInfo.hsinchu.fileName()))
        localInfos.allAreaInfos.append(localInfoManager.locationInfo(withFileName: "Taichung"))
        localInfos.allAreaInfos.append(localInfoManager.locationInfo(withFileName: "Tainan"))
        localInfos.allAreaInfos.append(localInfoManager.locationInfo(withFileName: "Kaoushun"))
        localInfos.allAreaInfos.append(localInfoManager.locationInfo(withFileName: "Haoulain"))
        
        
        guard let userLocation = locationManager.location,
            let distanceInfo = DistanceInfo.init(rawValue: distanceSegmentedControl.selectedSegmentIndex)
            else { return }
        
        if let nearInfos = nearAreaLocationInfo(withDistanceKM: 5) {
            setAnnotation(withLocalInfos: nearInfos)
            mapView.showAnnotations(nearAnnotation(currentLocationCoordinate: userLocation, withDistanceMeter: distanceInfo.meterDistance()), animated: true)
        }else{
            updateAnnotation()
        }
        
        
        
        for case let vc as NearInfoTableViewController in self.childViewControllers  {
            nearInfoTableVC = vc
            nearInfoTableVC?.delegate = self
        }

    }
    
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestLocationAuthorization(status: CLLocationManager.authorizationStatus())

    }
    
    
    // MARK:- IBAction
    @IBAction func segmentControlValueChanged(_ sender: Any) {
        updateAnnotation()
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
    func cellDidSelect(cellInfo: Any) {
        print(cellInfo)
        performSegue(withIdentifier: "infoDetail", sender: nil)
    }
    
    
    
}


// MARK:- MKMapViewDelegate
extension NearInfoViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(view.annotation?.title)
    }
    
}

// MARK:- CLLocationManagerDelegate
extension NearInfoViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        requestLocationAuthorization(status: status)
    }
    
}



// MARK:- privateFunction
fileprivate extension NearInfoViewController {
    
    func setMapViewCenter(at coordinate: CLLocationCoordinate2D) {
        let fixedCenter = CLLocationCoordinate2D(latitude: coordinate.latitude , longitude: coordinate.longitude)
        mapView.setCenter(fixedCenter, animated: true)
    }
    
    
    func requestLocationAuthorization(status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse {
            let alertController = UIAlertController(title: "警告", message: "無定位權限, 請至設定中開啟", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "好", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }else if status == .authorizedWhenInUse {
            shouldRequestLocationAuthorization = false
        }
    }
    
    
    func updateAnnotation() {
        guard let distanceInfo = DistanceInfo.init(rawValue: distanceSegmentedControl.selectedSegmentIndex),
            let didSelectInfos = localInfos.allAreaInfos[areaSegmentedControl.selectedSegmentIndex],
            let userLocation = locationManager.location
            else { return }
        
        
        setAnnotation(withLocalInfos: didSelectInfos)
        
        
        mapView.showAnnotations(nearAnnotation(currentLocationCoordinate: userLocation, withDistanceMeter: distanceInfo.meterDistance()), animated: true)
    }
    
    
    func nearAnnotation(currentLocationCoordinate coordinate: CLLocation, withDistanceMeter meter: Double?) -> [MKAnnotation] {
        
        if let meter = meter {
            return mapView.annotations.filter { (anntation) -> Bool in
                return CLLocation(latitude: anntation.coordinate.latitude,
                                  longitude: anntation.coordinate.longitude)
                    .distance(from: coordinate) < meter
            }
            
            
        }
        return mapView.annotations
    }
    
    func nearAreaLocationInfo(withDistanceKM km: Int) -> [LocationInfo]? {
        for areaInfo in localInfos.allAreaInfos {
            for localInfo in areaInfo ?? [] {
                if isNear(withLocationInfo: localInfo, DistanceKM: km) {
                    return areaInfo
                }
            }
        }
        return nil
    }
    
    func setAnnotation(withLocalInfos areaInfos: [LocationInfo]) {
        
        mapView.removeAnnotations(mapView.annotations)
        
        for areaInfo in areaInfos {
            guard let geoCode = areaInfo.geoCode else { continue }
            let geoCodes = geoCode.components(separatedBy: ",")
            guard let lat = Double(geoCodes[0]),
                let lng = Double(geoCodes[1])
                else { continue }
            let coodinate = CLLocationCoordinate2DMake(lat, lng)
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = coodinate
            annotation.title = areaInfo.name
            mapView.addAnnotation(annotation)
            
            
        }
        
        
        
        
    }
    
    func isNear(withLocationInfo localInfo: LocationInfo, DistanceKM km: Int) -> Bool {
        guard let geoCode = localInfo.geoCode else { return false }
        let geoCodes = geoCode.components(separatedBy: ",")
        guard let lat = Double(geoCodes[0]),
            let lng = Double(geoCodes[1]),
            let currentLocation = locationManager.location
            else { return false }
        
        let location = CLLocation(latitude: lat, longitude: lng)
        
        let meter = location.distance(from: currentLocation)
        return meter < Double(km * 1000)
    }
}
