//
//  YSMFlowLayout.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2016/12/7.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

import UIKit

// MARK: - 问题： 当item增加的时候，之前已经计算过的frame，不需要再重新计算了


//数据源
protocol YSMWaterFallLayoutDataSource : class{
    //外部使用，需传入瀑布流列数
    func numberOfRows(in layout:YSMFlowLayout) -> Int
    //设置item的高度 (猜测可以给UICollectionViewDataSource协议进行扩展，写到扩展中,遇到扩展协议的问题)
    func layout(_ layout:YSMFlowLayout, heightForRowAt indexPath: IndexPath) -> CGFloat
}

// MARK: - 属性
class YSMFlowLayout: UICollectionViewFlowLayout {
    //数据源
    weak var dataSource : YSMWaterFallLayoutDataSource?
    //所有布局数组
    fileprivate lazy var layoutAttributesArray:[UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    //列数由数据源传入，默认为2
    fileprivate lazy var rows :Int = {
        return self.dataSource?.numberOfRows(in: self) ?? 2
    }()
    //item的宽度
    fileprivate lazy var itemW : CGFloat = 0
    
    //每列的height 初始都为0
    fileprivate lazy var totalHeights : [CGFloat] = Array(repeating: self.sectionInset.top, count: self.rows)
}

// MARK: - 重写父类
extension YSMFlowLayout {
    //内容大小
    override var collectionViewContentSize: CGSize{
        return CGSize(width: 0, height: totalHeights.max()! + sectionInset.bottom)
    }
    override func prepare() {
        super.prepare()
        //item的最终布局是由UICollectionViewLayoutAttributes决定的
        //获取分区的个数
        let sectionCount = self.collectionView!.numberOfSections
        
        //cell的宽度 = collectionView的宽度-左边界-右边界-行间隔*间隔数
        itemW = (self.collectionView!.bounds.width - sectionInset.left - sectionInset.right - minimumInteritemSpacing*CGFloat((rows - 1)))/CGFloat(rows)
        //这里由于是直接设置所有的item的位置，所以当添加新数据后，应该重置totalHeights
        totalHeights = Array(repeating: self.sectionInset.top, count: self.rows)
        
        for section in 0..<sectionCount{
            //获取当前分区item的个数
            let itemCount = self.collectionView!.numberOfItems(inSection: section)
            //给每一个cell创建UICollectionViewLayoutAttributes
            for item in 0..<itemCount {
                //获取item的indexPath
                let indexPath = IndexPath(item: item, section: section)
                //根据indexPath创建布局
                let attributes = self.layoutAttributesForItem(at: indexPath)
                //添加到布局数组中
                self.layoutAttributesArray.append(attributes)
            }
            //设置完成一个分区之后，下一个分区的y轴起始位置相同
            //获取最长高度
            let maxHeight = totalHeights.max()!
            //设置起始位置
            totalHeights = Array(repeating: maxHeight+sectionInset.top, count: rows)
        }
    }
    //获取区域内的布局属性数组
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributesArray
    }
    
    //根据indexPath创建每一个布局
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        //根据indexPath创建对应的UICollectionViewLayoutAttributes
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        //获取item的高度
        guard let itemH = dataSource?.layout(self, heightForRowAt: indexPath) else {
            fatalError("必须遵守YSMWaterFallLayoutDataSource，并传入item的height")
        }
        //当前最小的高度
        let minHeight = totalHeights.min()!
        //y值为最短列底部+行间距
        let itemY = minHeight+minimumLineSpacing
        //当前最小高度所在的列数
        let minHeightCol = totalHeights.index(of: minHeight)!
        //x值为左边距+前面列的每一列的宽度+每一个列间距的宽度
        let itemX = sectionInset.left+(itemW+minimumInteritemSpacing)*CGFloat(minHeightCol)
        attributes.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
        //刷新当前列的高度 = 当前高度+item的高度+行间距
        totalHeights[minHeightCol] = minHeight + itemH + minimumLineSpacing
        return attributes
    }
}
