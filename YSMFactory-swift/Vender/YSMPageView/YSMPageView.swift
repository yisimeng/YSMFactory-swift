//
//  YSMPageView.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2016/12/5.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

import UIKit

class YSMPageView: UIView {
    
    fileprivate var titles:[String]
    fileprivate var childVCs:[UIViewController]
    fileprivate var parentVC:UIViewController
    fileprivate var style:YSMPageViewStye
    
    fileprivate lazy var titleView :YSMPageTitleView = {
        let titleViewFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.style.titleViewHeight)
        let titleView = YSMPageTitleView(frame: titleViewFrame, titles: self.titles, style:self.style)
        titleView.backgroundColor = UIColor.randomColor()
        return titleView
    }()
    
    fileprivate lazy var contentView :YSMPageContentView = {
        let contentViewFrame = CGRect(x: 0, y: self.style.titleViewHeight, width: self.bounds.width, height: self.bounds.height - self.style.titleViewHeight)
        let contentView = YSMPageContentView(frame: contentViewFrame, childVCs: self.childVCs, parentVC: self.parentVC, style:self.style)
        return contentView
    }()
    
    init(frame: CGRect ,titles : [String] , viewControllers:[UIViewController] ,parentController:UIViewController, style:YSMPageViewStye) {
        
        assert(titles.count == viewControllers.count, "title与控制器的数目不符")
        assert(viewControllers.count > 0, "至少要有一个控制器")
        
        self.titles = titles;
        self.childVCs = viewControllers;
        self.parentVC = parentController;
        self.style = style;
        
        super.init(frame: frame)
        
        prepareUI();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - prepareUI
extension YSMPageView{
    fileprivate func prepareUI() {
        addSubview(titleView)
        addSubview(contentView)
        
        //设置contentView为titleview的代理，当点击title时，contentView跟随滚动
        titleView.delegate = contentView
        //设置titleView为contentView的代理，当手动滑动content时，title滚动
        contentView.delegate = titleView
    }
}



