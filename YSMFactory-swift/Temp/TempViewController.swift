//
//  TempViewController.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2016/12/19.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

import UIKit

class TempViewController: YSMBaseViewController {
    
    
    /// hehe
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let atask = delay(5.0) {
            print("呵呵")
        }
        
        let t = DispatchTime.now()+2
        DispatchQueue.main.asyncAfter(deadline: t) {
            cancel(atask)
        }
        
    }
}















