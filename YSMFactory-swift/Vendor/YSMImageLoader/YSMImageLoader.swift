//
//  YSMImageLoader.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2016/12/26.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

import UIKit

//"http://hangge.com/blog/images/logo.png"

protocol YSMImageLoadabel:class {
    
}

extension YSMImageLoadabel{
    
    func downloadAd(with urlString:String , completion:@escaping ((UIImage?,String?)->())){
        //下载地址
        guard let url = URL(string: urlString) else {
            return
        }
        let request = URLRequest(url: url)
        let session = URLSession.shared
        //下载任务
        let downloadTask = session.downloadTask(with: request, completionHandler: { (location:URL?, response:URLResponse?, error:Error?) in
            
            guard let tempPath = location?.path else {
                completion(nil,location?.path)
                return
            }
            //拷贝到用户目录
            let adCachePath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/adImage"
            //保存到document中
            do {
                try FileManager.default.moveItem(atPath: tempPath, toPath: adCachePath)
            }
            catch{
                fatalError("移动文件失败:\(error)")
            }
            let image = UIImage.gifImage(file: adCachePath)
            completion(image,adCachePath)
        })
        //使用resume方法启动任务
        downloadTask.resume()
    }
}
