//
//  CIMotionBlur.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2017/1/6.
//  Copyright © 2017年 忆思梦. All rights reserved.
//

import UIKit

class CIMotionBlur: YSMFilter {
    
    /// An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius.
    ///Default value: 20.00
    var inputRadius:CGFloat = 20 {
        didSet{
            ciFilter.setValue(inputRadius, forKey: "inputRadius")
        }
    }
    
    /// An NSNumber object whose attribute type is CIAttributeTypeAngle and whose display name is Angle.
    /// Default value: 0.00
    var inputAngle:Double = 0 {
        didSet{
            ciFilter.setValue(inputAngle, forKey: "inputAngle")
        }
    }
}
