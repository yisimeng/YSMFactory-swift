//
//  YSMCardFlowLayout.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2016/12/20.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

import UIKit

class YSMCardFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let atts = super.layoutAttributesForElements(in: rect)
        guard (atts?.count) != nil else {
            return atts
        }
        for att in atts! {

            recomputeAttributesFrame(att)
        }
        return atts
    }
    
    func recomputeAttributesFrame(_ attributes:UICollectionViewLayoutAttributes) {
        let minY:CGFloat = collectionView!.bounds.minY+collectionView!.contentInset.top+sectionInset.top
        let finalY = max(minY, attributes.frame.origin.y)
        attributes.frame.origin.y = finalY
        attributes.zIndex = attributes.indexPath.row
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
