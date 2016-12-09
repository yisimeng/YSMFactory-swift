//
//  YSMAdViewController.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2016/12/9.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

import UIKit

class YSMAdViewController: UIViewController {
    
    fileprivate lazy var adImageView :UIImageView = {
        let adImageView = UIImageView(frame: self.style.adFrame)
        adImageView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
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
    fileprivate var timer : DispatchSourceTimer!
    //显示完毕之后的回调
    fileprivate var showFinished:(()->Void)
    
    fileprivate var style:YSMAdLaunchStyle
    
    //指定初始化方法(添加“required”关键字，如果直接用:'VC()',方式创建会报错)
    required init(showStyle style:YSMAdLaunchStyle, finished showFinished:@escaping (()->Void)) {
        self.style = style
        self.showFinished = showFinished
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //准备ui
        prepareUI()
        
        //设置广告图
        adImageView.image = style.adImage
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //开始倒计时
        startTimer(style.duration)
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
    
    //广告显示完毕
    fileprivate func adShowFinished() {
        if !timer.isCancelled {
            self.timer.cancel()
        }
        UIView.transition(with: UIApplication.shared.delegate!.window!!, duration: 0.3, options: style.finishedAnimations, animations: ({
            self.showFinished()
            }), completion: nil)
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

// MARK: - 事件
extension YSMAdViewController{
    @objc fileprivate func skipClick(_ btn:UIButton) {
        guard style.skipType==SkipButtonType.skip || style.skipType==SkipButtonType.timeSkip else {
            return
        }
        adShowFinished()
    }
}

extension YSMAdViewController{
    fileprivate func startTimer(_ count :TimeInterval) {
        var timerCount = count
        //创建定时器
        timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags.strict, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
        //调用方法
        timer.setEventHandler {
            //返回主线程
            DispatchQueue.main.async {
                //修改btn倒计时
                self.setupSkipButtonTitle(timerCount)
                //如果倒计时为0，停止倒计时
                if timerCount <= 0 {
                    self.adShowFinished()
                }
                timerCount -= 1
            }
        }
        //设置开始时间和调用间隔
        timer.scheduleRepeating(deadline: .now(), interval: DispatchTimeInterval.seconds(1))
        //启动倒计时
        timer.resume()
    }
}

