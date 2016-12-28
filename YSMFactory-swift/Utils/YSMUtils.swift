//
//  YSMUtils.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2016/12/20.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

import UIKit

class YSMUtils: NSObject {

}

func printProperties(_ cls:AnyClass!)  {
    var count:UInt32 = 0
    let propertyList = class_copyPropertyList(cls, &count)
    for i in 0..<Int(count) {
        guard let property = propertyList![i] else{
            continue
        }
        let propertyName = String(utf8String: property_getName(property))!
        print("\(propertyName)")
    }
}

