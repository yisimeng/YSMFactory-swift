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

// MARK: - 延时方法
//定义类型
typealias Task = (_ cancel : Bool) -> Void

func delay(_ time : TimeInterval, task :@escaping()->()) -> Task? {
    func dispatch_later(block: @escaping ()->()){
        let t = DispatchTime.now()+time
        DispatchQueue.main.asyncAfter(deadline: t, execute: block)
        print("1")
    }
    
    var closure: (()->Void)? = task
    var result:Task?
    print("2")
    let delayedClosure:Task = {cancel in
        if let internalClosure = closure {
            if (cancel == false){
                DispatchQueue.main.async(execute: internalClosure)
            }
        }
        closure = nil
        result = nil
        print("3")
    }
    
    result = delayedClosure
    
    dispatch_later {
        if let delayedClosure = result{
            delayedClosure(false)
            print("4")
        }
    }
    
    return result
}
func cancel(_ task: Task?){
    task?(true)
}
