//
//  MJRefreshAutoNormalFooter.swift
//  MJRefreshExample
//
//  Created by 史晓义 on 2020/1/31.
//  Copyright © 2020 小码哥. All rights reserved.
//

import UIKit

open class MJRefreshAutoNormalFooter: MJRefreshAutoStateFooter
{
    /// 菊花的样式
    public var activityIndicatorViewStyle : UIActivityIndicatorView.Style
    {
        get {
            return loadingView.style
        }
        set {
            loadingView.style = newValue
        }
    }
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView.init()
        loadingView.hidesWhenStopped = true
        addSubview(loadingView)
        return loadingView
    }()
//}
//
////MARK: - 重写父类的方法
//extension MJRefreshAutoNormalFooter
//{
    override open func prepare() {
        super.prepare()
        self.activityIndicatorViewStyle = .gray
    }
    
    override open func placeSubviews() {
        super.placeSubviews()
        if (self.loadingView.constraints.count != 0) { return }
        
        // 圈圈
        var loadingCenterX = self.mj_w * 0.5
        if (!self.isRefreshingTitleHidden) {
            loadingCenterX -= self.stateLabel.mj_textWidth * 0.5 + self.labelLeftInset
        }
        let loadingCenterY = self.mj_h * 0.5
        self.loadingView.center = CGPoint(x: loadingCenterX, y: loadingCenterY)
    }
    override open var state: MJRefreshState {
        get {
            return super.state
        }
        set {
            let oldState = self.state
            if (newValue == oldState) { return }
            super.state = newValue
            
            // 根据状态做事情
            if (state == .noMoreData || state == .idle) {
                self.loadingView.stopAnimating()
            } else if (state == .refreshing) {
                self.loadingView.startAnimating()
            }
        }
    }

}
