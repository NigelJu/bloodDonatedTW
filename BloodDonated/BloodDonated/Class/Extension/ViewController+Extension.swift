//
//  ViewController+Extension.swift
//  捐血趣
//
//  Created by Nigel on 2018/2/22.
//  Copyright © 2018年 Nigel. All rights reserved.
//

import UIKit

extension UIViewController {
    func currentViewController() -> UIViewController? {
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.currentViewController()
        }
        if let tab = self as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.currentViewController()
            }
            return tab.currentViewController()
        }
        return self
    }
}

extension UIApplication {
    func currentViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.currentViewController()
    }
}
