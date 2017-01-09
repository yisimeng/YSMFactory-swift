//
//  CIMaskedVariableBlur.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2016/12/30.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

import UIKit

class CIMaskedVariableBlur: YSMFilter {

    /// default : 10.0
    var inputRadius:CGFloat? {
        didSet{
            ciFilter.setValue(inputRadius, forKey: "inputRadius")
        }
    }
    
    var inputMask:CIImage? {
        didSet{
            ciFilter.setValue(inputMask, forKey: "inputMask")
        }
    }
    
    
}
