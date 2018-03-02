//
//  SelectAreaViewController.swift
//  捐血趣
//
//  Created by Nigel on 2018/3/1.
//  Copyright © 2018年 Nigel. All rights reserved.
//

import UIKit


fileprivate enum ConditionType: Int {
    case area
    case distance
}

class SelectAreaViewController: UIViewController {

    var pickarInfos: (distance: DistanceInfo, areaIndex: Int, areaTitles: [String])?
    
    // 由外部決定確認按鈕點選後的行為
    var okButtonDidSelectClousure: ((_ distanceInfo: DistanceInfo, _ didSelectAreaIndex: Int) -> Void)?
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    deinit {
        print("SelectAreaViewController die")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 由外部決定預設選取的值
        guard let distanceIndex = pickarInfos?.distance.hashValue,
            let areaIndex = pickarInfos?.areaIndex else { return }
    
        
        pickerView.selectRow(distanceIndex, inComponent: ConditionType.distance.rawValue, animated: false)
         pickerView.selectRow(areaIndex, inComponent: ConditionType.area.rawValue, animated: false)
        
    }
    
    // MARK:- IBAction
    @IBAction func okButtonDidSelect(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
        guard let info = pickarInfos else { return }
        
        let areaIndex = pickerView.selectedRow(inComponent: ConditionType.area.rawValue)
        let distanceIndex = pickerView.selectedRow(inComponent: ConditionType.distance.rawValue)

        let distance = info.distance.allValues()[distanceIndex]
        okButtonDidSelectClousure?(distance, areaIndex)

    }
    
    @IBAction func cancelButtonDidSelect(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK:- UIPickerViewDataSource, UIDocumentPickerDelegate
extension SelectAreaViewController: UIPickerViewDataSource, UIDocumentPickerDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // 地區
        if component == ConditionType.area.rawValue {
            return pickarInfos?.areaTitles.count ?? 0
        }
        // 距離
        return pickarInfos?.distance.allValues().count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // 地區
        if component == ConditionType.area.rawValue {
            return pickarInfos?.areaTitles[row]
        }
        // 距離
        return pickarInfos?.distance.allValues()[row].rawValue
        
    }
}
