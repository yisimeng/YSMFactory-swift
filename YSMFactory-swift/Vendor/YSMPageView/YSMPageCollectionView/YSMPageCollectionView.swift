//
//  YSMPageCollectionView.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2016/12/15.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

import UIKit

protocol YSMPageCollectionViewDataSource:class {
    func numberOfSections(in pageCollectionView: YSMPageCollectionView) -> Int
    func pageCollectionView(_ pageCollectionView: YSMPageCollectionView, numberOfItemsInSection section: Int) -> Int
    func pageCollectionView(_ pageCollectionView: YSMPageCollectionView,_ collectionView:UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

protocol YSMPageCollectionViewDelegate:class {
    
    func pageCollectionView(_ pageCollectionView: YSMPageCollectionView, didSelectItemAt indexPath: IndexPath)
}


class YSMPageCollectionView: UIView {
    
    fileprivate var titleView:YSMPageTitleView!
    fileprivate var pageControl:UIPageControl!
    fileprivate var collectionView:UICollectionView!
    fileprivate var style : YSMPageViewStye
    fileprivate var titles:[String]
    fileprivate var layout : YSMPageCollectionViewLayout
    
    weak var dataSource:YSMPageCollectionViewDataSource?
    weak var delegate:YSMPageCollectionViewDelegate?
    
    //当前的位置
    fileprivate var currentIndexPath:IndexPath = IndexPath(item: 0, section: 0)
    
    init(frame: CGRect,titles:[String],style:YSMPageViewStye,layout:YSMPageCollectionViewLayout) {
        self.style = style
        self.titles = titles
        self.layout = layout
        super.init(frame: frame)
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension YSMPageCollectionView{
    fileprivate func prepareUI() {
        //初始化titleView
        let titleViewFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: style.titleViewHeight)
        titleView = YSMPageTitleView(frame: titleViewFrame, titles: titles, style: style)
        titleView.backgroundColor = UIColor.randomColor()
        titleView.delegate = self
        addSubview(titleView)
        
        //初始化pageControl
        let pageControlHeight : CGFloat = 20
        pageControl = UIPageControl(frame: CGRect(x: 0, y: bounds.height-pageControlHeight, width: bounds.width, height: pageControlHeight))
        pageControl.numberOfPages = 5
        pageControl.isEnabled = false
        pageControl.backgroundColor = UIColor.randomColor()
        addSubview(pageControl)
        
        collectionView = UICollectionView(frame:CGRect(x: 0, y: titleView.bounds.maxY, width: bounds.width, height: bounds.height-style.titleViewHeight-pageControlHeight) , collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        addSubview(collectionView)
        collectionView.backgroundColor = UIColor.randomColor()
    }
}

extension YSMPageCollectionView:UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSections(in: self) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemNum = dataSource?.pageCollectionView(self, numberOfItemsInSection: section) ?? 0
        //第一个section时，设置pageControl
        if section == 0{
            pageControl.numberOfPages = (itemNum-1)/(layout.col*layout.row)+1
        }
        return itemNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource!.pageCollectionView(self, collectionView, cellForItemAt: indexPath)
    }
}

// MARK: - collectionViewDelegate
extension YSMPageCollectionView:UICollectionViewDelegate{
    
    //点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pageCollectionView(self, didSelectItemAt: indexPath)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewEndScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewEndScroll()
        }
    }
    
    fileprivate func scrollViewEndScroll() {
        // 取出在屏幕中显示的Cell
        let point = CGPoint(x: layout.sectionInset.left + 1 + collectionView.contentOffset.x, y: layout.sectionInset.top + 1)
        guard let indexPath = collectionView.indexPathForItem(at: point) else { return }
        
        // 判断分组是否有发生改变
        if currentIndexPath.section != indexPath.section {
            // 计算出当前section的item个数
            let itemCount = dataSource?.pageCollectionView(self, numberOfItemsInSection: indexPath.section) ?? 0
            //计算当前section的页数
            pageControl.numberOfPages = (itemCount - 1) / (layout.col * layout.row) + 1
            
            // 设置titleView位置=section
            titleView.scrollingTitle(from: currentIndexPath.section, to: indexPath.section, with: 1.0)
            
            // 记录最新indexPath
            currentIndexPath = indexPath
        }
        // 根据当前页第一个item计算出所在section的第几页
        pageControl.currentPage = indexPath.item / (layout.col * layout.row)
    }
}

//点击titleView代理
extension YSMPageCollectionView:YSMPageTitleViewDelegate{
    func titleView(_ titleView:YSMPageTitleView, didSelectIndex targetIndex:Int){
        let indexPath = IndexPath(item: 0, section: targetIndex)
        //滚动到目标位置
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        //直接滚动过去是item是贴边的，需要减去左边界
        collectionView.contentOffset.x -= layout.sectionInset.left
        scrollViewEndScroll()
    }
}

// MARK:- 对外暴露的方法
extension YSMPageCollectionView {
    func register(cell : AnyClass?, identifier : String) {
        collectionView.register(cell, forCellWithReuseIdentifier: identifier)
    }
    
    func register(nib : UINib, identifier : String) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
}
