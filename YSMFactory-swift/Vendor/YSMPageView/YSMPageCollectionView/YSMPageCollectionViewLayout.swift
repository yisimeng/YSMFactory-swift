//
//  YSMPageCollectionViewLayout.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2016/12/15.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

import UIKit

class YSMPageCollectionViewLayout: UICollectionViewFlowLayout {
    
    var row : Int = 2
    var col : Int = 4
    
    fileprivate var attributes : [UICollectionViewLayoutAttributes] =  [UICollectionViewLayoutAttributes]()
    fileprivate var itemW :CGFloat = 0.0
    fileprivate var itemH :CGFloat = 0.0
    fileprivate var maxWidth :CGFloat = 0.0
    override func prepare() {
        
        //获取item的宽高
        itemW = (self.collectionView!.bounds.width - sectionInset.left - sectionInset.right - CGFloat((col-1))*minimumInteritemSpacing)/CGFloat(col)
        itemH = (self.collectionView!.bounds.height - sectionInset.top - sectionInset.bottom - CGFloat((row-1))*minimumInteritemSpacing)/CGFloat(row)
        
        //获取section的个数
        let sectionCount = collectionView!.numberOfSections
        //总页数
        var pageCount : Int = 0
        for section in 0..<sectionCount{
            //获取item的个数
            let itemCount = collectionView!.numberOfItems(inSection: section)
            //遍历创建布局
            for item in 0..<itemCount {
                let indexPath = IndexPath(item: item, section: section)
                let att = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                //所在页
                let page = indexPath.item/Int(col*row)
                //该页的第几个
                let index = indexPath.item%Int(col*row)
                //该页所在列数
                let itemCol = index%col
                //该页所在行数
                let itemRow = index/col
                //x值,特别注意：要加上前面所有组的页数*width
                let x : CGFloat = sectionInset.left + collectionView!.bounds.width*CGFloat(page+pageCount) + (itemW + minimumInteritemSpacing)*CGFloat(itemCol)
                let y : CGFloat = sectionInset.top + (itemH + minimumLineSpacing)*CGFloat(itemRow)
                
                att.frame = CGRect(x: x, y: y, width: itemW, height: itemH)
                attributes.append(att)
            }
            //计算页数
            pageCount += (itemCount-1)/(row*col)+1
        }
        //宽度
        maxWidth = CGFloat(pageCount)*collectionView!.bounds.width
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes
    }
    override var collectionViewContentSize: CGSize{
        return CGSize(width: maxWidth, height: 0)
    }
}

