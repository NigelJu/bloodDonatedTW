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
    
    @IBOutlet weak var distanceSegmentedControl: UISegmentedControl!
    @IBOutlet weak var areaSegmentedControl: UISegmentedControl!
    
    fileprivate var localInfos = NearLocationInfo()
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        
        
        localInfos.allAreaInfos.append(localInfoManager.locationInfo(withFileName: AreaInfo.taipei.fileName()))
        localInfos.allAreaInfos.append(localInfoManager.locationInfo(withFileName: "Hsinchu"))
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
        
        
        
        
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            let alertController = UIAlertController(title: "警告", message: "無定位權限, 請至設定中開啟", preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    @IBAction func segmentControlValueChanged(_ sender: Any) {
        updateAnnotation()
    }
    
  
    
    
}

// MARK:- MKMapViewDelegate
extension NearInfoViewController: MKMapViewDelegate {
    
    
}

// MARK:- privateFunction
fileprivate extension NearInfoViewController {
    
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
            let taipeiAnnotation = MKPointAnnotation()
            
            taipeiAnnotation.coordinate = coodinate
            taipeiAnnotation.title = areaInfo.name
            mapView.addAnnotation(taipeiAnnotation)
            
            
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
