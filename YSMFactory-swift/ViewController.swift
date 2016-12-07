//
//  ViewController.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2016/12/5.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        
        
        let pageViewFrame = CGRect(x: 0, y: kNavigationBarHeight, width: view.bounds.width, height: view.bounds.height-kNavigationBarHeight)
        let titles = ["第一","第二二第三","第五","第三第三","第五","第四第第五第五","第五","第六","第四第第五第五","第五","第六"]
        var childVCs = [UIViewController]()
        for _ in 0..<titles.count {
            let viewController = UIViewController()
            viewController.view.backgroundColor = UIColor.randomColor()
            childVCs.append(viewController)
        }
        let style = YSMPageViewStye()
        let pageView = YSMPageView(frame: pageViewFrame, titles: titles, viewControllers: childVCs, parentController: self, style: style)
        view.addSubview(pageView)
        
    }
}

