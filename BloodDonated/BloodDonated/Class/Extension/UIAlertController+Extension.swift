//
//  UIAlertController+Extension.swift
//  捐血趣
//
//  Created by Nigel on 2018/2/27.
//  Copyright © 2018年 Nigel. All rights reserved.
//

import UIKit

typealias AlertActionType = (UIAlertAction?)->()
extension UIAlertController{
    
    
    
    class func alert(title: String? = "提示", message: String?, style: UIAlertControllerStyle = .alert)-> UIAlertController  {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        return alertController
    }
    
    func cancleHandle(title:String? = "取消",style:UIAlertActionStyle = .cancel,alertAction:AlertActionType?) -> UIAlertController {
        
        let alert = UIAlertAction(title: title, style: style) { (action) in
            if alertAction != nil{
                alertAction!(action)
            }
        }
        self.addAction(alert)
        return self
    }
    
    func otherHandle(title:String? = "確定",style: UIAlertActionStyle = .default,alertAction:AlertActionType?) -> UIAlertController {
        let alert = UIAlertAction(title: title, style: style) { (action) in
            if alertAction != nil{
                alertAction!(action)
            }
        }
        self.addAction(alert)
        return self
    }
    
    func show(currentVC: UIViewController)  {
        
        currentVC.present(self, animated: true, completion: nil)
        
    }
    
}


