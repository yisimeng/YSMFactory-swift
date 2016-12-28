//
//  YSMImageDecodeViewController.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2016/12/28.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

import UIKit
import ImageIO

////===苹果的实例程序======目前运行不了
//通过上下文绘制出新的图片


//目标图片的最大所占内存
let destImageSizeMB:CGFloat = 120.0
//源图片单位块所占内存
let sourceImageTileSizeMB:CGFloat = 40.0


//1M = 1024KB = 1024*1024B
let bytesPerMB:CGFloat = 1024.0*1024.0
//一个像素占4字节
let bytesPerPixel:CGFloat = 4.0
//1M包含的像素数
let pixelsPerMB:CGFloat = (bytesPerMB/bytesPerPixel)

//目标图片的总像素
let destTotalPixels = destImageSizeMB*pixelsPerMB

//源图单位块的像素总数
let sourceTileTotalPixels = sourceImageTileSizeMB*pixelsPerMB


// MARK: - 目标图片重叠位置的像素高度？
let destSeemOverLap:CGFloat = 2.0


class YSMImageDecodeViewController: UIViewController {
    
    fileprivate var imageView:UIImageView!
    fileprivate var sourceImage:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView(frame: view.bounds)
        view.addSubview(imageView)
        view.addTarget(target: self, action: #selector(start))
    }

    @objc fileprivate func start() {
        guard let path = Bundle.main.path(forResource: "largeImage.jpg", ofType: nil) else {
            fatalError("路径错误")
        }
        
        guard let image = UIImage(contentsOfFile:path) else { fatalError("未读出图片") }
        //获取图片
        sourceImage = image
        
        //图片大小
        let sourceResolution = CGSize(width: image.cgImage!.width, height: image.cgImage!.height)
        
        //图片总像素
        let sourceTotalPixels = sourceResolution.width*sourceResolution.height
        
        //图片总需要的存储空间大小（M）
        //        let sourceTotalMB = sourceTotalPixels/pixelsPerMB
        
        //图片的缩放比例，源图片与目标图片像素总数的比
        let imageScale = destTotalPixels/sourceTotalPixels
        
        //目标图片的宽高
        let destResolution = CGSize(width: sourceResolution.width*imageScale, height: sourceResolution.height*imageScale)
        
        //目标图片一行所占字节总数
        let bytesPreRow = bytesPerPixel*destResolution.width
        
        //在屏幕外创建一个位图上下文存放输出图像的数据，通过不断添加数据，会变得可用
        var destBitmapData:Data = Data()
        guard let destContext = CGContext(data: &destBitmapData, width: Int(destResolution.width), height: Int(destResolution.height), bitsPerComponent: 8, bytesPerRow: Int(bytesPreRow), space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            fatalError("创建上下文失败")
        }
        
        //翻转上下文坐标系为cocoa的坐标系，因为我们要用UIImage(named:)去输入图片
        destContext.translateBy(x: 0, y: destResolution.height)
        destContext.scaleBy(x: 1.0, y: -1.0)
        
        //现在定义从源图片到目标图片的矩形增量块的大小，基于iOS从磁盘读取图片数据的方式，我们使原‘单位块’的宽度等于原图片的宽度,单位块的像素总数=单位块的宽度*单位块的高度
        let sourceTileSize = CGSize(width: sourceResolution.width, height: sourceTileTotalPixels/sourceResolution.width)
        var sourceTile = CGRect(origin: CGPoint(x: 0, y: 0), size: sourceTileSize)
        
        //输出图片的单位块大小的计算方式和原图片的一样，但是要缩放至目标图片的比例
        var destTile = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: destResolution.width, height: sourceTileSize.height*imageScale))
        
        //原图片的重叠像素高度
        let sourceSeemOverLap = (destSeemOverLap/destResolution.height)*sourceResolution.height
        
        //计算组装输出图像所需的读/写操作的数量
        var iterations = Int(sourceResolution.height/sourceTileSize.height)
        var sourceTileImage:CGImage?
        
        
        //如果单位块的高度不能被图片总高度整除，剩下的像素单独再占一行
        let remainder = Int(sourceResolution.height)%Int(sourceTile.height)
        if remainder != 0 {
            iterations += 1
        }
        //原图瓦块减去重叠部分的高度
        let sourceTileHeightMinusOverLap = sourceTile.height
        //源图瓦块的总高度
        sourceTile.size.height += sourceSeemOverLap
        //目标图瓦块的总高度
        destTile.size.height += destSeemOverLap
        
        //开始渐进取图片数据
        for i in 0..<iterations {
            //扫描图片的起始y值
            ///============  有问题 ===============
            //貌似是dest始终是指向source的下一行
            sourceTile.origin.y = CGFloat(i) * sourceTileHeightMinusOverLap + sourceSeemOverLap
            destTile.origin.y = destResolution.height - (CGFloat(i+1) * sourceTileHeightMinusOverLap*imageScale+destSeemOverLap)
            
            //获取rect内上下文的图片引用
            sourceTileImage = sourceImage.cgImage!.cropping(to: sourceTile)!
            
            //如果这是最后一块，则高度可能小于sourceTile的高度
            if i == iterations-1 && remainder != 0{
                var dify = destTile.size.height
                destTile.size.height = CGFloat(sourceTileImage!.height)*imageScale
                dify -= destTile.size.height
                destTile.origin.y += dify
            }
            
            //从sourceImage中读取瓦块部分的像素，并写入destImage
            destContext.draw(sourceTileImage!, in: destTile)
            
            //释放瓦块部分的像素数据（事实上并不会释放我们刚刚绘制的数据）
            sourceTileImage = nil
            //前面创建的sourceTileImage会保持对原图像磁盘和缓存中的引用，因此可以释放掉源图像
            sourceImage = nil
            
            //重新赋值原图像
            sourceImage = image
            //显示绘制图像进度
            //获取现在图片
            guard let destCGImage = destContext.makeImage() else {
                continue
            }
            let destImage = UIImage(cgImage: destCGImage, scale: 1.0, orientation: .downMirrored)
            self.imageView.image = destImage
        }
        
        
    }
}
