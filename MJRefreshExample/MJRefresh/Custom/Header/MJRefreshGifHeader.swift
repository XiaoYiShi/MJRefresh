//
//  MJRefreshGifHeader.swift
//  MJRefreshExample
//
//  Created by YiCZB on 2020/1/20.
//  Copyright © 2020 小码哥. All rights reserved.
//

import UIKit

//MARK: - GifHeader
open class MJRefreshGifHeader: MJRefreshStateHeader
{
    open lazy var gifView: UIImageView = {
        let _gifView = UIImageView()
        addSubview(_gifView)
        return _gifView
    }()
    
    /// 所有状态对应的动画图片
    private var stateImages = [MJRefreshState:[UIImage]]()
    /// 所有状态对应的动画时间
    private var stateDurations = [MJRefreshState:TimeInterval]()
}

//MARK: - 公共方法
extension MJRefreshGifHeader : MJRefreshProtocol_Gif
{
    open func setImages(images: [UIImage], for state: MJRefreshState) {
        setImages(images: images, duration: Double(images.count) * 0.1, for: state)
    }
    
    open func setImages(images: [UIImage], duration: TimeInterval, for state: MJRefreshState) {
        stateImages[state] = images
        stateDurations[state] = duration
        
        // 根据图片设置控件的高度
        if let image = images.first,
            image.size.height > self.mj_h
        {
            self.mj_h = image.size.height
        }
    }
}

//MARK: - 实现父类的方法
extension MJRefreshGifHeader
{
    
    open override func prepare() {
        super.prepare()
        // 初始化间距
        self.labelLeftInset = 20
    }
    
    open override var pullingPercent: CGFloat{
        didSet {
            if self.state != MJRefreshState.idle { return }
            guard let images = self.stateImages[MJRefreshState.idle], images.count > 0 else {
                return
            }
            
            // 停止动画
            self.gifView.stopAnimating()
            
            // 设置当前需要显示的图片
            var index = CGFloat(images.count) * pullingPercent
            if index >= CGFloat(images.count) { index = CGFloat(images.count) - 1 }
            self.gifView.image = images[Int(index)]
        }
    }
    open override func placeSubviews() {
        super.placeSubviews()
        if (self.gifView.constraints.count != 0){ return }
        
        self.gifView.frame = self.bounds
        
        if (self.stateLabel.isHidden && self.lastUpdatedTimeLabel.isHidden)
        {
            self.gifView.contentMode = .center
        } else {
            self.gifView.contentMode = .right
            
            let stateWidth = self.stateLabel.mj_textWidth()
            var timeWidth:CGFloat = 0.0
            if (!self.lastUpdatedTimeLabel.isHidden) {
                timeWidth = self.lastUpdatedTimeLabel.mj_textWidth()
            }
            let textWidth = max(stateWidth, timeWidth)
            self.gifView.mj_w = self.mj_w * 0.5 - textWidth * 0.5 - self.labelLeftInset
        }
    }
    open override var state: MJRefreshState {
        set {
            let oldState = self.state
            if (newValue == oldState) { return }
            super.state = newValue
            
            // 根据状态做事情
            if (state == .pulling || state == .refreshing)
            {
                guard let images = self.stateImages[state], images.count != 0 else {
                    return
                }
                
                self.gifView.stopAnimating()
                if (images.count == 1) { // 单张图片
                    self.gifView.image = images.last
                } else { // 多张图片
                    self.gifView.animationImages = images
                    self.gifView.animationDuration = self.stateDurations[state] ?? 0
                    self.gifView.startAnimating()
                }
            } else if (state == .idle) {
                self.gifView.stopAnimating()
            }
        }
        get {
            return super.state
        }
    }
}
