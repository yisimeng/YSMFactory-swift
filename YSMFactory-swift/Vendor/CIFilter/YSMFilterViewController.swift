//
//  YSMFilterViewController.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2016/12/30.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

import UIKit

class YSMFilterViewController: YSMBaseViewController {
    
    
    lazy var originImageView : UIImageView = {
        let originImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height/2))
        originImageView.contentMode = .scaleAspectFill
        originImageView.layer.masksToBounds = true
        return originImageView
    }()
    
    lazy var resultImageView : UIImageView = {
        let resultImageView = UIImageView(frame: CGRect(x: 0, y: self.view.bounds.height/2, width: self.view.bounds.width, height: self.view.bounds.height/2))
        resultImageView.contentMode = .scaleAspectFit
        resultImageView.layer.masksToBounds = true
        return resultImageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(originImageView)
        view.addSubview(resultImageView)
        
        
        let originImage:UIImage = UIImage(named: "YSMFilter_man")!
        originImageView.image = originImage
        
        let filterImage = UIImage(named: "YSMFilter_man")!
        let result = addFilter(to: filterImage)
        resultImageView.image = result
    }
}
extension YSMFilterViewController{
    
    //FIXME: 需要传入图片的大小，否则加完滤镜后的大小会改变
    @discardableResult
    fileprivate func addFilter(to image:UIImage) -> UIImage {
        let ciImage = CIImage(image: image)
        
//        let filter = CIFilter(name: "CIZoomBlur")!
//        filter.setValue(ciImage, forKey: "inputImage")
//        let v = CIVector(cgPoint: CGPoint(x: 150, y: 150))
//        filter.setValue(v, forKey: "inputCenter")
//        filter.setValue(20, forKey: "inputAmount")
        
        let filter = CIZoomBlur.defaultFilter()
        filter.inputImage = ciImage
        filter.inputCenter = CGPoint(x: 150, y: 150)
        filter.inputAmount = 18

        
        //FIXME: 滤镜返回ciimage会被缩放
        guard let outputImage = filter.outputImage else {
            print("图片添加滤镜失败")
            return image
        }
        let outImage = UIImage(ciImage: outputImage)
        return outImage
    }
}
