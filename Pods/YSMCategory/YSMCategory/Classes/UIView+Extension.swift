//
//  UIView+Extension.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2016/12/5.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

import UIKit

public let kNavigationBarHeight:CGFloat = 64.0

extension UIView{
    
    
    /// 添加触摸手势
    ///
    /// - Parameters:
    ///   - target: <#target description#>
    ///   - action: <#action description#>
    public func addTarget(target: Any?, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        addGestureRecognizer(tap)
    }
    
    /// 移除所有子视图
    public func removeAllSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
}
