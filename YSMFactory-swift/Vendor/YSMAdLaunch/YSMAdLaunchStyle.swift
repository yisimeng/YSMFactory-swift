//
//  YSMAdLaunchStyle.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2016/12/9.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

import UIKit


/*快速集成代码
    self.window?.rootViewController = YSMAdViewController(showStyle:YSMAdLaunchStyle(), finished:({
        self.window?.rootViewController = ViewController()
    }))
 */

enum SkipButtonType {
    case none, time, skip, timeSkip
}

class YSMAdLaunchStyle {
    
    //广告时长
    var duration: TimeInterval = 10
    //广告的位置
    var adFrame: CGRect = UIScreen.main.bounds
    
    //跳过按钮的type
    var skipType: SkipButtonType = .timeSkip
    //按钮字号
    var skipFont: UIFont = .systemFont(ofSize: 12)
    //背景颜色
    var skipBackgroundColor: UIColor = .gray
    //按钮位置
    var skipFrame = CGRect(x: UIScreen.main.bounds.width - 70, y: 30, width: 60, height: 25)

    //结束后的动画
    var finishedAnimations: UIViewAnimationOptions = UIViewAnimationOptions.curveEaseInOut
    
}
