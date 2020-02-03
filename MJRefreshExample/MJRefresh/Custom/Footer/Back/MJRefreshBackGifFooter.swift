//
//  MJRefreshBackGifFooter.swift
//  MJRefreshExample
//
//  Created by 史晓义 on 2020/1/30.
//  Copyright © 2020 小码哥. All rights reserved.
//

import UIKit

open class MJRefreshBackGifFooter: MJRefreshBackStateFooter
{
    public lazy var gifView: UIImageView = {
        let gifView = UIImageView()
        addSubview(gifView)
        return gifView
    }()
    
    /// 所有状态对应的动画图片
    private var stateImages = [MJRefreshState:[UIImage]]()
    /// 所有状态对应的动画时间
    private var stateDurations = [MJRefreshState:TimeInterval]()
}

/// 设置state状态下的动画图片images 动画持续时间duration
extension MJRefreshBackGifFooter : MJRefreshProtocol_Gif
{
    public func setImages(images: [UIImage], duration: TimeInterval, for state: MJRefreshState) {
        
        self.stateImages[state] = images
        self.stateDurations[state] = duration
        
        /// 根据图片设置控件的高度 
        if let image = images.first,
            image.size.height > self.mj_h
        {
            self.mj_h = image.size.height
        }
    }
    
}

extension MJRefreshBackGifFooter
{
    
    //MARK: - 实现父类的方法
    open override func prepare() {
        super.prepare()
        // 初始化间距
        self.labelLeftInset = 20
    }
    open override var pullingPercent: CGFloat {
        didSet {
            if self.state != MJRefreshState.idle { return }
            guard let images = self.stateImages[MJRefreshState.idle], images.count > 0 else {
                return
            }
            self.gifView.stopAnimating()
            var index = CGFloat(images.count) * pullingPercent
            if index >= CGFloat(images.count) { index = CGFloat(images.count) - 1 }
            self.gifView.image = images[Int(index)]
        }
    }
    open override func placeSubviews() {
        super.placeSubviews()
        if (self.gifView.constraints.count != 0) {return}

        self.gifView.frame = self.bounds
        if (self.stateLabel.isHidden) {
            self.gifView.contentMode = .center
        } else {
            self.gifView.contentMode = .right
            self.gifView.mj_w = self.mj_w * 0.5 - self.labelLeftInset - self.stateLabel.mj_textWidth() * 0.5
        }
    }
    open override var state: MJRefreshState {
        get {
            return super.state
        }
        set {
            let oldState = self.state
            if (newValue == oldState) { return }
            super.state = newValue
            
            // 根据状态做事情
            
            if (state == .pulling || state == .refreshing) {
                guard let images = self.stateImages[state],images.count > 0 else {
                    return
                }
                
                self.gifView.isHidden = false
                self.gifView.stopAnimating()
                
                if (images.count == 1) { // 单张图片
                    self.gifView.image = images.last
                } else { // 多张图片
                    self.gifView.animationImages = images
                    self.gifView.animationDuration = self.stateDurations[state] ?? 0
                    self.gifView.startAnimating()
                }
            } else if (state == .idle) {
                self.gifView.isHidden = false
            } else if (state == .noMoreData) {
                self.gifView.isHidden = true
            }
        }
    }
}

