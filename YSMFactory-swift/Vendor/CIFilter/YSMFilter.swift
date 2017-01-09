//
//  YSMFilter.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2016/12/30.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

import UIKit
import ImageIO

protocol Filterable {
}

extension Filterable where Self : YSMFilter {
    
    static func defaultFilter(_ name : String? = nil) -> Self {
        let filterName = name == nil ? "\(self)" : name!
        guard let filter = CIFilter(name: filterName) else {
            fatalError("不存在滤镜：\(self)")
        }
        let ysm_Filter = self.init(filter)
        return ysm_Filter
    }
    
}


class YSMFilter: Filterable {
    
    var ciFilter:CIFilter!
    
    fileprivate let context:CIContext = CIContext(options: [:])
    
    var inputImage:CIImage? {
        didSet{
            ciFilter.setValue(inputImage, forKey: kCIInputImageKey)
        }
    }
    
    var outputImage:CIImage? {
        guard let outCIImage = ciFilter.outputImage else { return nil }
        
        guard let cgImage = self.context.createCGImage(outCIImage, from: outCIImage.extent) else {return nil}
        
        let outputImage = CIImage(cgImage: cgImage)
        
        return outputImage
    }
    
    required init(_ ciFilter : CIFilter) {
        self.ciFilter = ciFilter
    }
}
