//
//  MJRefreshNormalHeader.swift
//  MJRefreshExample
//
//  Created by 史晓义 on 2020/1/24.
//  Copyright © 2020 小码哥. All rights reserved.
//

import UIKit

open class MJRefreshNormalHeader: MJRefreshStateHeader
{
    //MARK: - 懒加载子控件
    open lazy var arrowView: UIImageView = {
        let arrowView = UIImageView.init(image: Bundle.mj_arrowImage())
        addSubview(arrowView)
        return arrowView
    }()
    open lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView.init(style: .gray)
        loadingView.hidesWhenStopped = true
        addSubview(loadingView)
        return loadingView
    }()
}
extension MJRefreshNormalHeader : MJRefreshProtocol_SubViews
{
    //MARK: - 重写父类的方法
    open override func prepare() {
        super.prepare()
        loadingView.style = .gray
    }
    open override func placeSubviews() {
        super.placeSubviews()
        // 箭头的中心点
        var arrowCenterX = self.mj_w * 0.5
        if (!self.stateLabel.isHidden) {
            let stateWidth = self.stateLabel.mj_textWidth()
            var timeWidth:CGFloat = 0.0
            if (!self.lastUpdatedTimeLabel.isHidden) {
                timeWidth = self.lastUpdatedTimeLabel.mj_textWidth()
            }
            let textWidth = max(stateWidth, timeWidth);
            arrowCenterX -= textWidth / 2 + self.labelLeftInset
        }
        let arrowCenterY = self.mj_h * 0.5
        let arrowCenter = CGPoint(x: arrowCenterX, y: arrowCenterY)
        
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
            super.state
        }
        set {
            let oldState = self.state
            if (newValue == oldState) { return }
            super.state = newValue
            
            // 根据状态做事情
            if (state == .idle) {
                if (oldState == .refreshing) {
                    self.arrowView.transform = .identity
                    UIView.animate(withDuration: TimeInterval(MJRefreshSlowAnimationDuration), animations: {
                        self.loadingView.alpha = 0.0
                    }) { (finished) in
                        // 如果执行完动画发现不是idle状态，就直接返回，进入其他状态
                        if (self.state != .idle) { return }
                        
                        self.loadingView.alpha = 1.0
                        
                        self.loadingView.stopAnimating()
                        self.arrowView.isHidden = false
                    }
                } else {
                    self.loadingView.stopAnimating()
                    self.arrowView.isHidden = false
                    UIView.animate(
                        withDuration: TimeInterval(MJRefreshFastAnimationDuration)
                    ) {
                        self.arrowView.transform = .identity
                    }
                }
            } else if (state == .pulling) {
                self.loadingView.stopAnimating()
                self.arrowView.isHidden = false
                UIView.animate(
                    withDuration: TimeInterval(MJRefreshFastAnimationDuration)
                ) {
                    self.arrowView.transform = CGAffineTransform.init(rotationAngle: CGFloat(0.000001 - .pi))
                }
            } else if (state == .refreshing) {
                self.loadingView.alpha = 1.0; // 防止refreshing -> idle的动画完毕动作没有被执行
                self.loadingView.startAnimating()
                self.arrowView.isHidden = true
            }
        }
    }
}
