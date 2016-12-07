//
//  YSMPageTitleView.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2016/12/5.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

import UIKit

protocol YSMPageTitleViewDelegate : class {
    func titleView(_ titleView:YSMPageTitleView, _ targetIndex:Int)
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
        delegateNeedselect(currentIndex)
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
        let label = tap.view as! UILabel
        selectTitleLabel(index: label.tag)
        delegateNeedselect(label.tag)
    }
    
    fileprivate func delegateNeedselect(_ index:Int){
        delegate?.titleView(self, index)
    }
    
    fileprivate func selectTitleLabel(index targetIndex:Int){
        //判断点击的是当前的label直接返回
        guard targetIndex != currentIndex else {
            return
        }
        //取出现在和点击的label
        let currentLabel = titleLabels[currentIndex]
        let targetLabel = titleLabels[targetIndex]
        //修改颜色
        currentLabel.textColor = style.titleNormalColor
        targetLabel.textColor = style.titleSelectColor
        //切换当前的index
        currentIndex = targetIndex
        
        //设置选中label居中
        if style.isTitleAutoresize {
            //当label居中时，ScrollView的左边界到屏幕左边的距离就是偏移量
            var offsetX = targetLabel.center.x - bounds.width * 0.5
            //当偏移小于0时，ScrollView的左边界会在原边界的右边
            if offsetX < 0{
                offsetX = 0
            }
            //当偏移量大于（scrollView.contentSize.width-scrollView.bounds.width）时，右边界会在原右边界的左边
            if offsetX > scrollView.contentSize.width-scrollView.bounds.width {
                offsetX = scrollView.contentSize.width-scrollView.bounds.width
            }
            scrollView.contentOffset = CGPoint(x: offsetX, y: 0)
        }
        
        //设置下划线跟随
        if style.isBottomLineShow {
            UIView.animate(withDuration: 0.2, animations: {
                self.bottomLine.frame.origin.x = targetLabel.frame.minX
                self.bottomLine.frame.size.width = targetLabel.frame.width
            })
        }

    }
}

extension YSMPageTitleView:YSMPageContentViewDelegate {
    //内容已经滚动，需要改变currentIndex
    func contentView(_ contentView: YSMPageContentView, _ targetIndex: Int) {
        selectTitleLabel(index: targetIndex)
    }
    
    func contentView(_ contentView: YSMPageContentView, _ targetIndex: Int, _ progress: CGFloat) {
        //获取当前和target的label
        let currentLabel = titleLabels[currentIndex]
        let targetLabel = titleLabels[targetIndex]
        
        //设置文字颜色渐变
        if style.isTitleColorCrossDissolve {
            let delatColor = UIColor.getRGBDelta(style.titleSelectColor, style.titleNormalColor)
            let normalColorCmps = style.titleSelectColor.getRGBComponents()
            let selectColorCmps = style.titleNormalColor.getRGBComponents()
            targetLabel.textColor = UIColor(r: selectColorCmps.r-delatColor.rDelta*progress, g: selectColorCmps.g-delatColor.gDelta*progress, b: selectColorCmps.b-delatColor.bDelta*progress, alpha: selectColorCmps.alpha-delatColor.aDelta*progress)
            currentLabel.textColor = UIColor(r: normalColorCmps.r+delatColor.rDelta*progress, g: normalColorCmps.g+delatColor.gDelta*progress, b: normalColorCmps.b+delatColor.bDelta*progress, alpha: normalColorCmps.alpha+delatColor.aDelta*progress)
        }
        
        //下划线渐变
        if style.isBottomLineShow {
            //x坐标的差值
            let diffX = targetLabel.frame.minX - currentLabel.frame.minX
            //宽度的差值
            let diffW = targetLabel.frame.width - currentLabel.frame.width
            //变化后的x值
            let targetX = currentLabel.frame.minX + diffX*progress
            //变化后的宽度
            let targetW = currentLabel.frame.width + diffW*progress
            bottomLine.frame = CGRect(x: targetX, y: bottomLine.frame.minY, width: targetW, height: bottomLine.frame.height)
        }
    }
}
