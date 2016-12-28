//
//  YSMBaseProtocol.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2016/12/20.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

import UIKit

protocol YSMPropertyProtocol {
    
}

protocol NibLoadable {
}

extension NibLoadable where Self : UIView {
    static func loadFromNib(_ nibname : String? = nil) -> Self {
        let loadName = nibname == nil ? "\(self)" : nibname!
        return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
    }
}
