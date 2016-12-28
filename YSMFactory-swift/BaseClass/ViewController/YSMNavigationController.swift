//
//  YSMNavigationController.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2016/12/19.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

import UIKit

class YSMNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let targets = interactivePopGestureRecognizer!.value(forKey:  "_targets") as? [NSObject] else { return }
        let targetObjc = targets[0]
        let target = targetObjc.value(forKey: "target")
        let action = Selector(("handleNavigationTransition:"))
        let pan = UIPanGestureRecognizer(target: target, action: action)
        view.addGestureRecognizer(pan)
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count != 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }

}
