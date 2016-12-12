//
//  YSMClass.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2016/12/9.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

import UIKit

//调用代码
//class ViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        automaticallyAdjustsScrollViewInsets = false
//
//        //创建一个实例
//        let ysm = YSMClass()
//        //设置代理
//        ysm.delegate = self
//        //调用实例的方法
//        //        ysm.invocationProtocol()
//        ysm.invocationExtension()
//
//    }
//}
//
//extension ViewController:YSMProtocol{
//    //协议方法
//    func ysmProtocol() -> Int{
//        return 1
//    }
//
//    //扩展协议方法
//    func ysmExtensionProtocol() -> Int {
//        return 2
//    }
//}




class YSMClass: NSObject {
    
    var delegate:YSMProtocol?
    
    func invocationProtocol() {
        
        let num = delegate?.ysmProtocol()
        
        print("协议传回的值：\(num)")
        
    }
    
    func invocationExtension() {
        let num = delegate?.ysmExtensionProtocol()

        print("扩展协议传值：\(num)")
    }
}



