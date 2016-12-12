//
//  YSMProtocol.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2016/12/9.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

import UIKit

protocol YSMProtocol: NSObjectProtocol {
    
    func ysmProtocol() -> Int
    
}




//协议扩展
extension YSMProtocol{
    //必须要写大括号
//    func ysmExtensionProtocol() -> Int
    
    func ysmExtensionProtocol() -> Int {
        return 0
    }
    
}
