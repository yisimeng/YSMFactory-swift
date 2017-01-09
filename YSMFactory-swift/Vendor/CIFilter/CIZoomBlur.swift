//
//  CIZoomBlur.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2017/1/6.
//  Copyright © 2017年 忆思梦. All rights reserved.
//

import UIKit

/// Simulates the effect of zooming the camera while capturing the image.
class CIZoomBlur: YSMFilter {
    /// A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
    /// Default value: [150 150]
    var inputCenter:CGPoint = CGPoint(x: 150, y: 150) {
        didSet{
            let v = CIVector(cgPoint: inputCenter)
            ciFilter.setValue(v, forKey: "inputCenter")
        }
    }
    
    /// An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Amount.
    /// Default value: 10.00
    var inputAmount:Double = 10.00 {
        didSet{
            ciFilter.setValue(inputAmount, forKey: "inputAmount")
        }
    }
}
