//
//  YSMBaseViewController.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2016/12/19.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

import UIKit

class YSMBaseViewController: UIViewController,NibLoadable {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.randomColor()
        
        view.addTarget(target: self, action: #selector(tap(_:)))
    }
}

extension YSMBaseViewController{
    func tap(_ gesture:UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
