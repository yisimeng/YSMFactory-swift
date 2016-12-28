//
//  YSMTimer.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2016/12/26.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

import Foundation

struct YSMTimer {

    //倒计时器
    fileprivate var timer : DispatchSourceTimer!
    fileprivate var timeCount :TimeInterval = 0
    
    init(time count :TimeInterval) {
        timeCount = count
    }
    mutating func startTimer(callback:@escaping ((TimeInterval)->()),finished:@escaping (()->())) {
        var currentTime = timeCount
        //创建定时器
        timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags.strict, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
        //调用方法
        timer.setEventHandler {
            //返回主线程
            DispatchQueue.main.async {
                callback(currentTime)
                //如果倒计时为0，停止倒计时
                if currentTime <= 0 {
                    finished()
                }
                currentTime -= 1
            }
        }
        //设置开始时间和调用间隔
        timer.scheduleRepeating(deadline: .now(), interval: DispatchTimeInterval.seconds(1))
        //启动倒计时
        timer.resume()
    }
    func stop() {
        if !timer.isCancelled {
            timer.cancel()
        }
    }
    
}
