//
//  BloodStoreCellTableViewCell.swift
//  BloodDonated
//
//  Created by Nigel on 2017/3/12.
//  Copyright © 2017年 Nigel. All rights reserved.
//

import UIKit

/*
    庫存vc的cell
*/

class BloodStoreCellTableViewCell: UITableViewCell {

    @IBOutlet var bloodInfoStackView: UIStackView!  // 名稱 / 血量庫存
   
    
    @IBOutlet var areaLabel: UILabel!
    @IBOutlet var typeOImageView: UIImageView!
    @IBOutlet var typeBImageView: UIImageView!
    @IBOutlet var typeABImageView: UIImageView!
    @IBOutlet var typeAImageView: UIImageView!
}
