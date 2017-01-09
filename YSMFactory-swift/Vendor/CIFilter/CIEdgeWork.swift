//
//  CIEdgeWork.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2016/12/30.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

import UIKit

class CIEdgeWork: YSMFilter {
    
    /// default : 3.0
    var inputRadius:CGFloat? {
        didSet{
            ciFilter.setValue(inputRadius, forKey: "inputRadius")
        }
    }
    
}
