//
//  UIColor+Extension.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2016/12/5.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

import UIKit

extension UIColor{
    
    /// RGB颜色
    ///
    /// - Parameters:
    ///   - r: <#r description#>
    ///   - g: <#g description#>
    ///   - b: <#b description#>
    ///   - alpha: <#alpha description#>
    convenience init(r : CGFloat, g : CGFloat, b : CGFloat, alpha : CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    
    /// 通过16进制数值获取颜色
    ///
    /// - Parameters:
    ///   - hex: <#hex description#>
    ///   - alpha: <#alpha description#>
    convenience init(hex : Int , alpha : CGFloat = 1.0) {
        self.init(r : CGFloat((hex & 0xff0000) >> 16) , g : CGFloat((hex & 0xff00) >> 8) , b : CGFloat(hex & 0xff) ,alpha : alpha)
    }
    
    //通过16进制字符串获取颜色
    
    convenience init?(hexString: String, alpha : CGFloat = 1.0) {
        //hex至少是6位，常用的前缀：‘#’，‘##’，‘0x’
        guard hexString.characters.count >= 6 else {
            return nil
        }
        //判断前缀,截取字符串
        var tempHex:String!
        if hexString.hasPrefix("0x") || hexString.hasPrefix("##") {
            tempHex = (hexString as NSString).substring(from: 2)
        }
        if hexString.hasPrefix("#") {
            tempHex = (hexString as NSString).substring(from: 1)
        }
        //将所有小写转换成大写
        tempHex = tempHex.uppercased()
        
        assert(tempHex.characters.count == 6, "hex错误")
        
        //分别取出字符串
        //R
        var range = NSMakeRange(0, 2);
        let RHex = (tempHex as NSString).substring(with: range);
        //G
        range.location = 2;
        let GHex = (tempHex as NSString).substring(with: range);
        //B
        range.location = 4;
        let BHex = (tempHex as NSString).substring(with: range);
        
        //将16进制字符串转数字
        var r : UInt32 = 0 , g : UInt32 = 0, b : UInt32 = 0;
        Scanner(string: RHex).scanHexInt32(&r);
        Scanner(string: GHex).scanHexInt32(&g);
        Scanner(string: BHex).scanHexInt32(&b);
        
        //初始化颜色
        self.init(r : CGFloat(r) , g : CGFloat(g) , b : CGFloat(b) , alpha : alpha)
    }
    
    /// 随机颜色
    ///
    /// - Returns: <#return value description#>
    class func randomColor() -> UIColor{
        return UIColor(r: CGFloat(arc4random_uniform(256)) , g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
    
    /// 分别获取RGB颜色的r,g,b,a
    ///
    /// - Returns: <#return value description#>
    func getRGBComponents() -> (r:CGFloat,g:CGFloat,b:CGFloat,alpha:CGFloat) {
        guard let cmps = self.cgColor.components else {
            fatalError("保证颜色为RGB")
        }
        return (cmps[0] * 255,cmps[1] * 255,cmps[2] * 255, cmps[3])
    }
    
    /// 颜色RGB的差值
    ///
    /// - Parameters:
    ///   - sourceColor: <#sourceColor description#>
    ///   - targetColor: <#targetColor description#>
    /// - Returns: <#return value description#>
    class func getRGBDelta(_ sourceColor:UIColor,_ targetColor:UIColor) -> (rDelta:CGFloat,gDelta:CGFloat,bDelta:CGFloat,aDelta:CGFloat) {
        let sourceRGBCmps = sourceColor.getRGBComponents()
        let targetRGBCmps = targetColor.getRGBComponents()
        return (targetRGBCmps.r-sourceRGBCmps.r, targetRGBCmps.g-sourceRGBCmps.g, targetRGBCmps.b-sourceRGBCmps.b,  targetRGBCmps.alpha-sourceRGBCmps.alpha)
    }
}
