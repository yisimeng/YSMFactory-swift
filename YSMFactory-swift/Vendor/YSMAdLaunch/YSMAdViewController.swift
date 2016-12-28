//
//  YSMAdViewController.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2016/12/9.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

import UIKit

class YSMAdViewController: UIViewController,YSMImageLoadabel {
    
    fileprivate lazy var adImageView :UIImageView = {
        let adImageView = UIImageView(frame: self.style.adFrame)
        adImageView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        adImageView.isUserInteractionEnabled = true
        adImageView.addTarget(target: self, action: #selector(tapAdImageView(_:)))
        return adImageView
    }()
    fileprivate lazy var skipBtn: UIButton = {
        let skipBtn = UIButton(type: UIButtonType.custom)
        skipBtn.backgroundColor = self.style.skipBackgroundColor
        skipBtn.titleLabel?.font = self.style.skipFont
        skipBtn.frame = self.style.skipFrame
        skipBtn.layer.masksToBounds = true
        skipBtn.layer.cornerRadius = skipBtn.frame.height/2
        skipBtn.autoresizingMask = [.flexibleLeftMargin]
        skipBtn.addTarget(self, action: #selector(skipClick(_:)), for: UIControlEvents.touchUpInside)
        return skipBtn
    }()
    
    //倒计时器
    fileprivate var timer : YSMTimer!
    //显示完毕之后的回调
    fileprivate var finished:(()->())
    //点击回调
    fileprivate var tapCallback:(()->())?
    //样式设置
    fileprivate var style:YSMAdLaunchStyle
    
    fileprivate var imageSource:String
    
    //指定初始化方法(添加“required”关键字，如果直接用:'VC()',方式创建会报错)
    required init(showAd source:String ,showStyle styleCallback:((YSMAdLaunchStyle)->()),selected tap:(()->())? = nil, finished showFinished:@escaping (()->())) {
        self.imageSource = source
        self.style = YSMAdLaunchStyle()
        styleCallback(self.style)
        self.finished = showFinished
        self.tapCallback = tap
        super.init(nibName: nil, bundle: nil)
        
        downloadAd(with: imageSource) { (image, path) in
            self.adImageView.image = image
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //准备ui
        prepareUI()
        
        adImageView.image = UIImage(named: "blur")
        
        //设置计时器
        timer = YSMTimer(time: style.duration)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //开始倒计时
        timer.startTimer(callback: { (currentTime) in
            self.setupSkipButtonTitle(currentTime)
        }, finished: {
            self.adShowFinished()
        })
    }
}

extension YSMAdViewController {
    fileprivate func prepareUI()  {
        //添加adImageView
        view.addSubview(adImageView)
        
        //添加跳过按钮
        if style.skipType != .none {
            view.addSubview(skipBtn)
            setupSkipButtonTitle(style.duration)
        }
    }
    
    fileprivate func setupSkipButtonTitle(_ seconds:TimeInterval) {
        var title:String
        switch style.skipType {
        case .skip:
            title = "跳过"
        case .time:
            title = "\(Int(seconds)) S"
        case .timeSkip:
            title = "\(Int(seconds)) 跳过"
        default :
            title = ""
            skipBtn.removeFromSuperview()
        }
        skipBtn.setTitle(title, for: UIControlState.normal)
    }
}

// MARK: - action
extension YSMAdViewController{
    @objc fileprivate func tapAdImageView(_ tap:UITapGestureRecognizer){
        self.tapCallback?()
    }
    
    @objc fileprivate func skipClick(_ btn:UIButton) {
        guard style.skipType==SkipButtonType.skip || style.skipType==SkipButtonType.timeSkip else {
            return
        }
        adShowFinished()
    }
    
    //广告显示完毕
    fileprivate func adShowFinished() {
        timer.stop()
        UIView.transition(with: UIApplication.shared.delegate!.window!!, duration: 0.3, options: style.finishedAnimations, animations: ({
            self.finished()
        }), completion: nil)
    }
}
