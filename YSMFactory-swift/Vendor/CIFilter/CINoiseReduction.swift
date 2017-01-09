//
//  CINoiseReduction.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2017/1/6.
//  Copyright © 2017年 忆思梦. All rights reserved.
//

import UIKit

/// Small changes in luminance below that value are considered noise and get a noise reduction treatment, which is a local blur. Changes above the threshold value are considered edges, so they are sharpened.
class CINoiseReduction: YSMFilter {
    
    /// An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Noise Level.
    /// Default value: 0.02
    var inputNoiseLevel:CGFloat = 0.02 {
        didSet{
            ciFilter.setValue(inputNoiseLevel, forKey: "inputNoiseLevel")
        }
    }
    
    /// An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Sharpness.
    /// Default value: 0.40
    var inputSharpness:Double = 0.40 {
        didSet{
            ciFilter.setValue(inputSharpness, forKey: "inputSharpness")
        }
    }
}
