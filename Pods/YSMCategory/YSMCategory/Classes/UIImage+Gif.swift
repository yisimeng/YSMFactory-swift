//
//  UIImage+Gif.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2016/12/22.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

import UIKit
import ImageIO

extension UIImage{
    
    //gif图片其实是一张张的图片在连续切换，播放gif，需要拿到一张张的图片，和图片显示的时长，一张张替换
    
    public class func gifImage(file path:String) -> UIImage?{
        
        guard let data = NSData(contentsOfFile: path) else {
            return nil
        }
        
        return UIImage.gifImage(with:data as Data)
    }
    
    public class func gifImage(with data:Data) -> UIImage? {
        
        //data转为CGImageSource对象
        guard let imageSource = CGImageSourceCreateWithData(data as CFData,nil) else {
            return nil
        }
        
        //获取图片的张数
        let imageCount = CGImageSourceGetCount(imageSource)
        
        //gif图组
        var imageArray = [UIImage]()
        
        var timeCount:TimeInterval = 0
        //遍历获取所有图片
        for i in 0..<imageCount {
            //根据下标创建图片
            guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else { continue }
            let image = UIImage(cgImage: cgImage)
            imageArray.append(image)
            
            //每张图片的持续时间
            guard let imageInfo = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) as? [String:Any] else { continue }
            guard let gifInfo = imageInfo[kCGImagePropertyGIFDictionary as String] as? [String:Any] else { continue }
            guard let delayTime = gifInfo[kCGImagePropertyGIFDelayTime as String] as? TimeInterval else { continue }
            
            timeCount += delayTime
        }
        
        //将多张图片转化为一张图片
        return UIImage.animatedImage(with: imageArray, duration: timeCount)
        
        //设置imageView显示一组动画
        //        imageView.animationImages = imageArray
        //        imageView.animationDuration = timeCount
        //        imageView.startAnimating()
        
    }
}






