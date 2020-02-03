//
//  MJRefreshBackNormalFooter.swift
//  MJRefreshFramework
//
//  Created by 史晓义 on 2020/1/28.
//  Copyright © 2020 小码哥. All rights reserved.
//

import UIKit

open class MJRefreshBackNormalFooter: MJRefreshBackStateFooter
{
    //MARK: - 懒加载子控件
    public lazy var arrowView: UIImageView = {
        let arrowView = UIImageView.init(image: Bundle.mj_arrowImage())
        addSubview(arrowView)
        return arrowView
    }()
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView.init(style: .gray)
        loadingView.hidesWhenStopped = true
        addSubview(loadingView)
        return loadingView
    }()
    
}


extension MJRefreshBackNormalFooter
{
    //MARK: - 重写父类的方法
    open override func prepare() {
        super.prepare()
        self.loadingView.style = .gray
    }
    
    open override func placeSubviews() {
        super.placeSubviews()
        // 箭头的中心点
        var arrowCenterX = self.mj_w * 0.5
        if (!self.stateLabel.isHidden) {
            arrowCenterX -= self.labelLeftInset + self.stateLabel.mj_textWidth() * 0.5
        }
        let arrowCenterY = self.mj_h * 0.5
        let arrowCenter = CGPoint.init(x: arrowCenterX, y: arrowCenterY)
        
        // 箭头
        if (self.arrowView.constraints.count == 0) {
            self.arrowView.mj_size = self.arrowView.image?.size ?? .zero
            self.arrowView.center = arrowCenter
        }
        
        // 圈圈
        if (self.loadingView.constraints.count == 0) {
            self.loadingView.center = arrowCenter
        }
        
        self.arrowView.tintColor = self.stateLabel.textColor
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
            if (state == .idle) {
                if (oldState == .refreshing) {
                    self.arrowView.transform = CGAffineTransform(rotationAngle: 0.000001 - .pi)
                    
                    UIView.animate(withDuration: TimeInterval(MJRefreshSlowAnimationDuration), animations: {
                        self.loadingView.alpha = 0.0
                    }) { (finished) in
                        // 防止动画结束后，状态已经不是MJRefreshStateIdle
                        if (self.state != .idle) {return}
                        
                        self.loadingView.alpha = 1.0
                        self.loadingView.stopAnimating()
                        
                        self.arrowView.isHidden = false
                    }
                } else {
                    self.arrowView.isHidden = false
                    self.loadingView.stopAnimating()
                    UIView.animate(withDuration: TimeInterval(MJRefreshFastAnimationDuration)) {
                        self.arrowView.transform = CGAffineTransform(rotationAngle: 0.000001 - .pi)
                    }
                }
            } else if (state == .pulling) {
                self.arrowView.isHidden = false
                self.loadingView.stopAnimating()
                UIView.animate(withDuration: TimeInterval(MJRefreshFastAnimationDuration)) {
                    self.arrowView.transform = .identity
                }
            } else if (state == .refreshing) {
                self.arrowView.isHidden = true
                self.loadingView.startAnimating()
            } else if (state == .noMoreData) {
                self.arrowView.isHidden = true
                self.loadingView.stopAnimating()
            }
        }
    }
    
}

