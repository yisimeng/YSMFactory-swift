//
//  UIView+Extension.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2016/12/5.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

import UIKit

let kNavigationBarHeight:CGFloat = 64.0

extension UIView{
    
    /// 移除所有子视图
    func removeAllSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
}
