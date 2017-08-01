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
    var taipeiInfos: [LocationInfo]?
    var hsinchuInfos: [LocationInfo]?
    var kaoushunInfos: [LocationInfo]?
    var taichunInfos: [LocationInfo]?
    var tainanInfos: [LocationInfo]?
    var haoulanInfos: [LocationInfo]?
}

class NearInfoViewController: UIViewController {

    fileprivate let locationManager = CLLocationManager()
    fileprivate let localInfoManager = LocalLocationManager()
    
    fileprivate var localInfos = NearLocationInfo()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        locationManager.requestWhenInUseAuthorization()
        
        
        localInfos.taipeiInfos = localInfoManager.locationInfo(withFileName: "Taipei")
        localInfos.hsinchuInfos = localInfoManager.locationInfo(withFileName: "Hsinchu")
        localInfos.kaoushunInfos = localInfoManager.locationInfo(withFileName: "Kaoushun")
        localInfos.taichunInfos = localInfoManager.locationInfo(withFileName: "Taichung")
        localInfos.tainanInfos = localInfoManager.locationInfo(withFileName: "Tainan")
        localInfos.haoulanInfos = localInfoManager.locationInfo(withFileName: "Haoulain")
        
        setNearestAnnotation(withDistanceKM: 5)
        
      
        
//        for taipeiInfo in localInfos.taipeiInfos ?? [] {
//            if let geoCode = taipeiInfo.geoCode {
//                let geoCodes = geoCode.components(separatedBy: ",")
//                guard let lat = Double(geoCodes[0]),
//                    let lng = Double(geoCodes[1])
//                    else { continue }
//                let coodinate = CLLocationCoordinate2DMake(lat, lng)
//                let taipeiAnnotation = MKPointAnnotation()
//
//                taipeiAnnotation.coordinate = coodinate
//                taipeiAnnotation.title = taipeiInfo.name
//                mapView.addAnnotation(taipeiAnnotation)
//            }
//           
//        }

        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            let alertController = UIAlertController(title: "警告", message: "無定位權限, 請至設定中開啟", preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    @IBAction func distanceSegmentControlValueChanged(_ sender: Any) {
    }
    
    @IBAction func areaSegmentControlValueChanged(_ sender: Any) {
    }
    
    
}

// MARK:- MKMapViewDelegate
extension NearInfoViewController: MKMapViewDelegate {


}

// MARK:- privateFunction
fileprivate extension NearInfoViewController {
    
    func findNearLocationInfo(withDistanceKM km: Int) -> [LocationInfo]? {
        
        return nil
    }
    
    func setNearestAnnotation(withDistanceKM km: Int) {
        if let hsinchuInfos = localInfos.hsinchuInfos {
            for localInfo in hsinchuInfos
                where isNear(withLocationInfo: localInfo, DistanceKM: km) {
                    
                 
                   
            }
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
