//
//  YSMPageTitleView.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2016/12/5.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

import UIKit

protocol YSMPageTitleViewDelegate : class {
    func titleView(_ titleView:YSMPageTitleView, didSelectIndex targetIndex:Int)
}

class YSMPageTitleView: UIView {
    
    weak var delegate:YSMPageTitleViewDelegate?
    
    fileprivate var titles : [String]
    fileprivate var style : YSMPageViewStye
    
    
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.bounces = true
        scrollView.scrollsToTop = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    fileprivate var titleLabels = [UILabel]()
    
    fileprivate lazy var bottomLine:UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.bottomLineColor
        bottomLine.frame.origin.y = self.bounds.height - self.style.bottomLineHeight
        bottomLine.frame.size.height = self.style.bottomLineHeight
        return bottomLine
    }()
    
    fileprivate var currentIndex:Int = 0
    
    init(frame: CGRect, titles:[String], style:YSMPageViewStye) {
        self.titles = titles
        self.style = style
        super.init(frame: frame)
        
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - prepareUI
extension YSMPageTitleView{
    fileprivate func prepareUI() {
        //添加scrollView
        addSubview(scrollView)
        
        //添加title
        setupTitleLabels()
        
        //titleLabelFrame
        setupTitleLabelsFrame()
        
        //添加下划线
        if style.isBottomLineShow {
            setupBottomLine()
        }
        
        //自适应时 设置scrollView的contentSize为最后一个label的right+titleMargin的一半
        if style.isTitleAutoresize {
            scrollView.contentSize = CGSize(width: titleLabels.last!.frame.maxX + style.titleMargin * 0.5, height: bounds.height)
        }
        //设置默认选中
        let currentLabel = titleLabels[currentIndex]
        currentLabel.textColor = style.titleSelectColor
    }
    fileprivate func setupTitleLabels() {
        for (index,title) in titles.enumerated() {
            let label = UILabel()
            label.text = title
            label.font = UIFont.systemFont(ofSize: style.titleFontSize)
            label.textAlignment = .center
            //默认第一个label为选中
            label.textColor = style.titleNormalColor
            label.tag = index
            scrollView.addSubview(label)
            titleLabels.append(label)
            
            //添加触摸手势
            let tap = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            label.addGestureRecognizer(tap)
            label.isUserInteractionEnabled = true
        }
    }
    fileprivate func setupTitleLabelsFrame() {
        let labelCount = titleLabels.count
        let y:CGFloat = 0,h:CGFloat = bounds.height
        for (index, label) in titleLabels.enumerated() {
            var x:CGFloat, w:CGFloat
            if style.isTitleAutoresize{
                //获取title宽度
                w = (titles[index] as NSString).boundingRect(with: CGSize(width:CGFloat(MAXFLOAT), height: 0), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: style.titleFontSize)], context: nil).width
                if index == 0 {
                    x = style.titleMargin * 0.5
                }else{
                    //获取上一个label的right值
                    let lastLabel = titleLabels[index-1]
                    x = lastLabel.frame.maxX + style.titleMargin
                }
            }else{
                w = bounds.width/CGFloat(labelCount)
                x = CGFloat(index) * w
            }
            label.frame = CGRect(x: x, y: y, width: w, height: h)
        }
    }
    
    fileprivate func setupBottomLine() {
        scrollView.addSubview(bottomLine)
        //设置下划线的位置
        if style.isBottomLineShow {
            let bottomLineX = titleLabels.first!.frame.minX
            let bottomLineW = titleLabels.first!.frame.width
            bottomLine.frame.origin.x = bottomLineX
            bottomLine.frame.size.width = bottomLineW
        }
    }
}

// MARK: - action
extension YSMPageTitleView{
    @objc fileprivate func titleLabelClick(_ tap:UITapGestureRecognizer){
        // 0.获取当前Label
        guard let targetLabel = tap.view as? UILabel else { return }
        
        // 1.如果是重复点击同一个Title,那么直接返回
        if targetLabel.tag == currentIndex { return }
        
        // 2.获取之前的Label
        let currentLabel = titleLabels[currentIndex]

        //修改颜色
        targetLabel.textColor = style.titleSelectColor
        currentLabel.textColor = style.titleNormalColor
        
        //保存最新label的下标值
        currentIndex = targetLabel.tag
        
        //通知代理滚动
        delegate?.titleView(self, didSelectIndex: currentIndex)
        
        //调整label居中
        adjustCurrentLabelCentered(currentIndex)
        
        //设置下划线跟随
        if style.isBottomLineShow {
            UIView.animate(withDuration: 0.15, animations: {
                let x = targetLabel.frame.minX
                let w = targetLabel.frame.width
                self.bottomLine.frame = CGRect(x: x, y: self.bottomLine.frame.origin.y, width: w, height: self.bottomLine.frame.height)
            })
        }
    }
    
    func scrollingTitle(from sourceIndex:Int, to targetIndex:Int, with progress:CGFloat) {
        //获取当前和目标label
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        //设置文字渐变
        if style.isTitleColorCrossDissolve {
            let delatColor = UIColor.getRGBDelta(style.titleNormalColor,style.titleSelectColor)
            let normalColorCmps = style.titleNormalColor.getRGBComponents()
            let selectColorCmps = style.titleSelectColor.getRGBComponents()
            sourceLabel.textColor = UIColor(r: selectColorCmps.r-delatColor.rDelta*progress, g: selectColorCmps.g-delatColor.gDelta*progress, b: selectColorCmps.b-delatColor.bDelta*progress, alpha: selectColorCmps.alpha-delatColor.aDelta*progress)
            targetLabel.textColor = UIColor(r: normalColorCmps.r+delatColor.rDelta*progress, g: normalColorCmps.g+delatColor.gDelta*progress, b: normalColorCmps.b+delatColor.bDelta*progress, alpha: normalColorCmps.alpha+delatColor.aDelta*progress)
        }
        
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveTotalW = targetLabel.frame.width - sourceLabel.frame.width
        //设置下划线偏移
        if style.isBottomLineShow {
            UIView.animate(withDuration: 0.2, animations: { 
                self.bottomLine.frame.size.width = sourceLabel.frame.width + moveTotalW * progress
                self.bottomLine.frame.origin.x = sourceLabel.frame.origin.x + moveTotalX * progress
            })
        }
    }
    //调整label居中
    func adjustCurrentLabelCentered(_ targetIndex:Int) {
        //设置选中label居中
        guard style.isTitleAutoresize else {
            return
        }
        let currentLabel = titleLabels[targetIndex]
        //当label居中时，ScrollView的左边界到屏幕左边的距离就是偏移量
        var offsetX = currentLabel.center.x - bounds.width * 0.5
        //当偏移小于0时，ScrollView的左边界会在原边界的右边
        if offsetX < 0{
            offsetX = 0
        }
        //当偏移量大于（scrollView.contentSize.width-scrollView.bounds.width）时，右边界会在原右边界的左边
        if offsetX > scrollView.contentSize.width-scrollView.bounds.width {
            offsetX = scrollView.contentSize.width-scrollView.bounds.width
        }
        //设置偏移
        self.scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        //保存当前下标
        currentIndex = targetIndex
    }
}

