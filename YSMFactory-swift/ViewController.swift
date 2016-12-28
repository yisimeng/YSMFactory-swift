//
//  ViewController.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2016/12/5.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController{
    //捕捉会话
    var session:AVCaptureSession?
    //预览图层
    var previewLayer:AVCaptureVideoPreviewLayer?
    
    //movie输出
    let movieOutput = AVCaptureMovieFileOutput()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func start(_ sender: Any) {
        
        guard (session?.isRunning) == nil else {
            return
        }
        
        session = AVCaptureSession()
        
        //设置video输入
        setupVideoInOutput(with: session!)
        //视频输出
        setupVideoOutput(with: session!)
        
        //设置音频输入
        setupAudioInput(with: session!)
        //音频输出
        setupAudioOutput(with: session!)
        
        //设置预览视图
        setupPreviewLayer(with: session!)
        
        //开始捕捉
        session?.startRunning()
        
        //设置文件输出
        setupFileOutput(with: session!)
    }
    
    @IBAction func rotate(_ sender: Any) {
        rotateScene()
    }
    
    @IBAction func stop(_ sender: Any) {
        
        //停止写入
        movieOutput.stopRecording()
        
        //先将预览图层移除
        previewLayer?.removeFromSuperlayer()
        
        //停止剥捕捉
        session?.stopRunning()
        //指针置空
        session = nil
    }
    
    //切换镜头
    private func rotateScene() {
        let inputs = session?.inputs
        //获取当前所有输入设备
        guard let inputDevices = inputs as? [AVCaptureDeviceInput] else {
            return
        }
        //当前的视频输入(position:未指明、前置、后置)
        guard let currentVideoInput = inputDevices.filter({ $0.device.position != .unspecified }).first else {
            return
        }
        //获取摄像头
        let newPosition:AVCaptureDevicePosition = currentVideoInput.device.position == .front ? .back:.front
        
        guard let newVideoInput = creatVideoInput(with: newPosition) else {
            return
        }
        //切换
        session?.beginConfiguration()
        session?.removeInput(currentVideoInput)
        session?.addInput(newVideoInput)
        //继续写入
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/video.mp4"
        let fileUrl = URL(fileURLWithPath: path)
        movieOutput.startRecording(toOutputFileURL: fileUrl, recordingDelegate: self)
        session?.commitConfiguration()
        
    }
}

extension ViewController {
    //获取摄像头
    fileprivate func creatVideoInput(with position:AVCaptureDevicePosition) -> AVCaptureDeviceInput? {
        //获取所有视频设备（前置、后置摄像头）
        guard let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as? [AVCaptureDevice] else {
            return nil
        }
        //获取摄像头
        guard let frontCamera = devices.filter({ return $0.position == position }).first else {
            return nil
        }
        //创建新输入
        guard let newVideoInput = try? AVCaptureDeviceInput(device: frontCamera) else {
            return nil
        }
        return newVideoInput
    }
    
    
    //设置视频输入设备
    fileprivate func setupVideoInOutput(with session:AVCaptureSession) {
        //获取前置摄像头
        guard let input = creatVideoInput(with: .front) else {
            return
        }
        //创建前置摄像头为输入设备
        //添加输入
        if session.canAddInput(input){
            session.addInput(input)
        }
        
    }
    //视频输出
    fileprivate func setupVideoOutput(with session:AVCaptureSession) {
        //创建视频输出
        let output = AVCaptureVideoDataOutput()
        //设置输出代理和线程
        output.setSampleBufferDelegate(self, queue: DispatchQueue.global())
        if session.canAddOutput(output){
            session.addOutput(output)
        }
    }
    
    //音频输入
    fileprivate func setupAudioInput(with session:AVCaptureSession) {
        //获取音频输入设备（只有麦克风）
        guard let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeAudio) as? [AVCaptureDevice] else {
            return
        }
        guard let mic = devices.first else {
            return
        }
        //创建输入设备
        guard let input = try? AVCaptureDeviceInput(device: mic) else {
            return
        }
        if session.canAddInput(input){
            session.addInput(input)
        }
    }
    //音频输出
    fileprivate func setupAudioOutput(with session:AVCaptureSession){
        let output = AVCaptureAudioDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue.global())
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
    }
    
    //文件输出
    fileprivate func setupFileOutput(with session:AVCaptureSession){
        //Movie文件输出
        session.addOutput(movieOutput)
        
        //获取视频连接
        let connection = movieOutput.connection(withMediaType: AVMediaTypeVideo)
        //设置适当的视频稳定模式(默认off)，
        connection?.preferredVideoStabilizationMode = .auto
        //文件路径
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/video.mp4"
        let fileUrl = URL(fileURLWithPath: path)
        
        //开始录制
        movieOutput.startRecording(toOutputFileURL: fileUrl, recordingDelegate: self)
    }
    
    //设置预览视图
    fileprivate func setupPreviewLayer(with session:AVCaptureSession) {
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.frame = CGRect(x: 0, y: 100, width: view.bounds.width, height: view.bounds.height/2)
        view.layer.insertSublayer(previewLayer!, at: 0)
    }
}

extension ViewController:AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate,AVCaptureFileOutputRecordingDelegate{
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        
    }
    
    //写入文件代理
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        print("开始写入")
    }
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        print("停止写入")
    }
}

