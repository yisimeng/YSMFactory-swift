//
//  ViewController.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2016/12/5.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

import UIKit
import HandyJSON

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        
        let pageViewFrame = CGRect(x: 0, y: kNavigationBarHeight, width: view.bounds.width, height: view.bounds.height-kNavigationBarHeight)
        let titles = ["第一","第二二第二","第三","第四第四","第五","第六第第六第六","第七","第八","第九第第九第九","第十","第十一"]
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

