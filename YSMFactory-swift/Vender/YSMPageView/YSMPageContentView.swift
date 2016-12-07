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
    func contentView(_ contentView:YSMPageContentView, _ targetIndex:Int)
    //设置title的渐变
    func contentView(_ contentView:YSMPageContentView, _ targetIndex:Int, _ progress:CGFloat)
}

class YSMPageContentView: UIView {

    fileprivate var childVCs:[UIViewController]
    fileprivate var parentVC:UIViewController
    fileprivate var style:YSMPageViewStye
    
    weak var delegate : YSMPageContentViewDelegate?
    
    fileprivate var currentOffsetX:CGFloat = 0
    
    //titleView和contentView互为代理，当点击titleView导致content偏移时，content又会通知代理titleView进行偏移
    //当点击title设置content偏移时，禁止content调用代理执行偏移，
    //监听到content将要滑动时，开启content调用代理执行偏移
    fileprivate var isScrollForbid = false
    
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

extension YSMPageContentView:YSMPageTitleViewDelegate{
    func titleView(_ titleView: YSMPageTitleView, _ targetIndex: Int) {
        //禁用调用titleView进行偏移
        isScrollForbid = true
        
        //取到target的indexpath
        let indexPath = IndexPath(row: targetIndex, section: 0)
        //滚动到target的控制器
        collectionView.scrollToItem(at: indexPath, at: .left, animated: style.isContentScrollAnimated)
    }
}

extension YSMPageContentView:UICollectionViewDelegate{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //手动滑动contentView，需要调用titleView去执行操作
        isScrollForbid = false
        //获取当前页的偏移量
        currentOffsetX = scrollView.contentOffset.x
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //判断获取的是否是当前的contentView
        guard scrollView.isEqual(collectionView) else {
            return
        }
        if !decelerate {
            contentDidEndScroll(scrollView)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //停止减速后，设置titleView偏移
        //判断获取的是否是当前的contentView
        guard scrollView.isEqual(collectionView) else {
            return
        }
        contentDidEndScroll(scrollView)
    }
    func contentDidEndScroll(_ scrollView:UIScrollView) {
        guard !isScrollForbid else {
            return
        }
        //计算当前视图的index
        let targetIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        delegate?.contentView(self, targetIndex)
        
        currentOffsetX = scrollView.contentOffset.x
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //判断获取的是否是当前的contentView
        guard scrollView.isEqual(collectionView) else {
            return
        }
        //是否开启title跟随变化
        guard style.isTitleFollowAnimated, !isScrollForbid else {
            return
        }
        //判断偏移是否等于初始偏移
        guard scrollView.contentOffset.x != currentOffsetX else {
            return
        }
        //获取当前page的index
        let currentIndex = Int(currentOffsetX / scrollView.bounds.width)
        
        //targetIndex
        var targetIndex:Int
        
        //progress：移动的百分比
        var progress:CGFloat
        
        //左滑。向左滑动，向上滑动，偏移量数值增加
        if currentOffsetX < scrollView.contentOffset.x{
            //左滑需要判断当前如果为最后一个page，title不需要滚动
            guard currentIndex != childVCs.count-1 else {
                return
            }
            targetIndex = currentIndex+1
        }else{
            //相等在前面已经判断，所以为右滑
            //右滑需判断当前为第一个page，title不需要滚动
            guard currentIndex != 0 else {
                return
            }
            targetIndex = currentIndex-1
        }
        //不管是向左还是向右，progress只记录相对于原来偏移的距离占ScrollView宽度的百分比
        progress = abs(currentOffsetX-scrollView.contentOffset.x)/scrollView.bounds.width
        delegate?.contentView(self, targetIndex, progress)
    }
    
}

