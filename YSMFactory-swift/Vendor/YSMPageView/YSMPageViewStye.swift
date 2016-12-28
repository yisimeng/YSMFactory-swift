//
//  YSMPageViewStye.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2016/12/5.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

import UIKit

/* 快速使用代码
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
 */


class YSMPageViewStye {
    
    //titleView的高度
    var titleViewHeight:CGFloat = 44
    //title的字体大小
    var titleFontSize:CGFloat = 14
    //title选中的颜色(RGB)
    var titleSelectColor:UIColor = UIColor(hex: 0x000000, alpha: 1)
    //title的未选中颜色(RGB)
    var titleNormalColor:UIColor = UIColor(hex: 0xff0000, alpha: 1)
    //title颜色是否渐变
    var isTitleColorCrossDissolve = true
    //title是否为自适应
    var isTitleAutoresize:Bool = true
    //title自适应时的间距（前提：isTitleAutoresize = true）
    var titleMargin:CGFloat = 20
    
    //下划线是否显示
    var isBottomLineShow:Bool = true
    //下划线的颜色
    var bottomLineColor:UIColor = .red
    //下划线的高度
    var bottomLineHeight:CGFloat = 2
    
    //contentView滚动动画是否开启
    var isContentScrollAnimated:Bool = false
    
    //titleView跟随contentView变化
    var isTitleFollowAnimated:Bool = true
    
    //PageView的初始默认下标
    var originalIndex:Int = 0
}
