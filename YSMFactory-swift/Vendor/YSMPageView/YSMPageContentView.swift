//
//  YSMPageContentView.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2016/12/5.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

import UIKit

private let kConllectionViewCellId = "kConllectionViewCellId"

//只是使用自定义的代理方法，可以不遵守NSObjectProcotol
protocol YSMPageContentViewDelegate : class {
    //content停止滚动，通知title偏移
    func contentViewDidEndScroll(_ contentView:YSMPageContentView, _ targetIndex :Int)
    //设置title的渐变
    func contentView(_ contentView:YSMPageContentView, from currentIndex:Int,scrollingTo targetIndex:Int, _ progress:CGFloat)
}

class YSMPageContentView: UIView {

    fileprivate var childVCs:[UIViewController]
    fileprivate var parentVC:UIViewController
    fileprivate var style:YSMPageViewStye
    
    weak var delegate : YSMPageContentViewDelegate?
    
    fileprivate var startOffsetX:CGFloat = 0
    
    fileprivate var endIndex :Int = 0
    
    //titleView和contentView互为代理，当点击titleView导致content偏移时，content又会通知代理titleView进行偏移
    //当点击title设置content偏移时，禁止content调用代理执行偏移，
    //监听到content将要滑动时，开启content调用代理执行偏移
    fileprivate var isScrollForbidDelegate = false
    
    fileprivate lazy var collectionView :UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0;
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kConllectionViewCellId)
        
        return collectionView
    }()
    
    init(frame: CGRect, childVCs:[UIViewController], parentVC:UIViewController, style:YSMPageViewStye) {
        self.childVCs = childVCs
        self.parentVC = parentVC
        self.style = style
        super.init(frame: frame)
        
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - prepareUI
extension YSMPageContentView{
    fileprivate func prepareUI() {
        //将控制器添加到父控制器中
        for childVC in childVCs {
            parentVC.addChildViewController(childVC)
        }
        
        addSubview(collectionView)
    }
}

// MARK: - dataSource
extension YSMPageContentView:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kConllectionViewCellId, for: indexPath)
        //先清空contentView
        cell.contentView.removeAllSubviews()
        //将子控制器的view添加到cell的contentView中
        let childVC = childVCs[indexPath.row]
        childVC.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVC.view)
        
        return cell
    }
}

extension YSMPageContentView {
    //修改当前页下标
    func set(currentIndex: Int) {
        //禁用调用代理进行偏移
        isScrollForbidDelegate = true

        //取到目标的索引
        let targetIndexPath = IndexPath(item: currentIndex, section: 0)
        //设置contentView滚动
        collectionView.scrollToItem(at: targetIndexPath, at: .left, animated: style.isContentScrollAnimated)
    }
}

extension YSMPageContentView:UICollectionViewDelegate{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //手动滑动contentView，需要调用titleView去执行操作
        isScrollForbidDelegate = false
        //获取当前页的偏移量
        startOffsetX = scrollView.contentOffset.x
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.contentViewDidEndScroll(self,endIndex)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetIndex = Int(targetContentOffset.pointee.x/scrollView.frame.width)
        endIndex = targetIndex
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //是否开启title跟随变化
        guard style.isTitleFollowAnimated, !isScrollForbidDelegate else {
            return
        }
        //判断偏移是否等于初始偏移
        guard scrollView.contentOffset.x != startOffsetX else {
            return
        }
        // 定义获取需要的数据
        var progress : CGFloat = 0
        var currentIndex : Int = 0
        var targetIndex : Int = 0
        
        // 判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        // 左滑
        if currentOffsetX > startOffsetX {
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            // 计算currentIndex
            currentIndex = Int(currentOffsetX / scrollViewW)
            
            //左滑需要判断当前如果为最后一个page，title不需要滚动
            guard currentIndex != childVCs.count-1 else {
                return
            }
            targetIndex = currentIndex+1
        }else {
            // 右滑
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            
            // 取整原则，右滑会导致（currentOffsetX/scrollViewW）小于当前的index，所以是目标的下标
            targetIndex = Int(currentOffsetX / scrollViewW)
            
            //右滑需判断当前为第一个page，title不需要滚动
            guard targetIndex > -1 else {
                return
            }
            currentIndex = targetIndex + 1
        }

        delegate?.contentView(self, from: currentIndex, scrollingTo: targetIndex, progress)
    }
    
}

