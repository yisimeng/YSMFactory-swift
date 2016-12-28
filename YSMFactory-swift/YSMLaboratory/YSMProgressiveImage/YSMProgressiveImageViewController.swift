//
//  YSMProgressiveImageViewController.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2016/12/28.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

import UIKit
import ImageIO

class YSMProgressiveImageViewController: YSMBaseViewController,URLSessionDataDelegate {
    
    fileprivate var imageView:UIImageView!
    
    fileprivate var totalData:Data = Data()
    
    fileprivate var imageSource:CGImageSource = CGImageSourceCreateIncremental(nil)
    
    fileprivate var context:CGContext!
    
    fileprivate var semaphore:DispatchSemaphore = DispatchSemaphore(value: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView(frame: view.bounds)
        view.addSubview(imageView)
        view.addTarget(target: self, action: #selector(start))
        
        context = CGContext(data: &totalData, width: Int(imageView.bounds.width), height: Int(imageView.bounds.height), bitsPerComponent: 8, bytesPerRow: 1280, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        
    }
    
    @objc fileprivate func start() {
        loadImage()
    }
    
    fileprivate func loadImage() {
        guard let url = URL(string: "https://cl.ly/2t1R2l1u0j1P/large_leaves_70mp.jpg") else {
            fatalError("链接错误")
        }
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let task = session.dataTask(with: request)
        task.resume()
    }
    
    fileprivate func refreshImage() {
        autoreleasepool{
            CGImageSourceUpdateData(self.imageSource, self.totalData as CFData, false)
            guard let cgImage = CGImageSourceCreateImageAtIndex(self.imageSource, 0, nil) else {
                return
            }
            let image = UIImage(cgImage: cgImage)
            
            self.semaphore.wait()
            self.imageView.image = image
            print("图片已刷新")
            self.semaphore.signal()
            
        }
    }
    
    fileprivate func drawImage() {
        CGImageSourceUpdateData(self.imageSource, self.totalData as CFData, false)
        guard let cgImage = CGImageSourceCreateImageAtIndex(self.imageSource, 0, nil) else {
            return
        }
        DispatchQueue.main.async {
            self.context.draw(cgImage, in: self.imageView.bounds)
            guard let newCGImage = self.context.makeImage() else {
                return
            }
            let image = UIImage(cgImage: newCGImage)
            self.imageView.image = image
            print("图片已刷新")
            
        }
        
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        totalData.append(data)
        self.refreshImage()
//        drawImage()
    }
}
