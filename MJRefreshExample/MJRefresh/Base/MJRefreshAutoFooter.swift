//
//  MJRefreshAutoFooter.swift
//  MJRefreshFramework
//
//  Created by 史晓义 on 2020/2/3.
//  Copyright © 2020 小码哥. All rights reserved.
//

import UIKit

open class MJRefreshAutoFooter: MJRefreshFooter
{
    /// 是否自动刷新(默认为YES)
    @objc public var isAutomaticallyRefresh = false
    
    /// 当底部控件出现多少时就自动刷新(默认为1.0，也就是底部控件完全出现时，才会自动刷新)
    @objc public var triggerAutomaticallyRefreshPercent:CGFloat = 0
    
    /// 是否每一次拖拽只发一次请求
    @objc public var isOnlyRefreshPerDrag = false
    
    /// 一个新的拖拽
    private var isOneNewPan = false
//}
//
//extension MJRefreshAutoFooter
//{
    
    //MARK: - 初始化
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if newSuperview != nil
        { // 新的父控件
            if self.isHidden == false {
                self.scrollView.mj_insetB += self.mj_h
            }
            
            // 设置位置
            self.mj_y = scrollView.mj_contentH
        } else { // 被移除了
            if self.isHidden == false {
                self.scrollView?.mj_insetB -= self.mj_h
            }
        }
    }
//}
//
////MARK: - 实现父类的方法
//extension MJRefreshAutoFooter
//{
    
    open override func prepare() {
        super.prepare()
        // 默认底部控件100%出现时才会自动刷新
        self.triggerAutomaticallyRefreshPercent = 1.0
        
        // 设置为默认状态
        self.isAutomaticallyRefresh = true
        
        // 默认是当offset达到条件就发送请求（可连续）
        self.isOnlyRefreshPerDrag = true
    }
    
    open override func scrollViewContentSizeDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewContentSizeDidChange(change)
        
        // 设置位置
        self.mj_y = self.scrollView.mj_contentH + self.ignoredScrollViewContentInsetBottom
    }
    
    open override func scrollViewContentOffsetDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewContentOffsetDidChange(change)
        
        if (self.state != .idle || !self.isAutomaticallyRefresh || self.mj_y == 0) { return }
        
        if (scrollView.mj_insetT + scrollView.mj_contentH > scrollView.mj_h)
        { // 内容超过一个屏幕
            // 这里的_scrollView.mj_contentH替换掉self.mj_y更为合理
            if (scrollView.mj_offsetY >= scrollView.mj_contentH - scrollView.mj_h + self.mj_h * self.triggerAutomaticallyRefreshPercent + scrollView.mj_insetB - self.mj_h)
            {
                // 防止手松开时连续调用
                let old = change?[NSKeyValueChangeKey.oldKey] as! CGPoint
                let new = change?[NSKeyValueChangeKey.newKey] as! CGPoint
                
                if (new.y <= old.y) {return}
                
                // 当底部刷新控件完全出现时，才刷新
                beginRefreshing()
            }
        }
    }
    
    open override func scrollViewPanStateDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewPanStateDidChange(change)
        
        if (self.state != .idle) { return }
        
        let panState = scrollView.panGestureRecognizer.state
        if (panState == .ended) {// 手松开
            if (scrollView.mj_insetT + scrollView.mj_contentH <= scrollView.mj_h)
            {  // 不够一个屏幕
                if (scrollView.mj_offsetY >= -scrollView.mj_insetT) { // 向上拽
                    beginRefreshing()
                }
            } else { // 超出一个屏幕
                if (scrollView.mj_offsetY >= scrollView.mj_contentH + scrollView.mj_insetB - scrollView.mj_h)
                {
                    beginRefreshing()
                }
            }
        } else if (panState == .began) {
            self.isOneNewPan = true
        }
    }
    
//}
//extension MJRefreshAutoFooter
//{
    
    
    open override func beginRefreshing() {
        if (!self.isOneNewPan && self.isOnlyRefreshPerDrag) { return }
        
        super.beginRefreshing()
        
        self.isOneNewPan = false
    }
    open override var state: MJRefreshState {
        set {
            let oldState = self.state
            if (newValue == oldState) { return }
            super.state = newValue
            
            if state == .refreshing {
                executeRefreshingCallback()
            } else if (state == .noMoreData || state == .idle) {
                if (.refreshing == oldState) {
                    self.endRefreshingCompletionBlock?()
                }
            }
        }
        get {
            return super.state
        }
    }
    
    open override var isHidden: Bool {
        get {
            return super.isHidden
        }
        set {
            let lastHidden = self.isHidden
            super.isHidden = newValue
            
            if (!lastHidden && newValue) {
                self.state = .idle
                
                self.scrollView.mj_insetB -= self.mj_h
            } else if (lastHidden && !newValue) {
                self.scrollView.mj_insetB += self.mj_h
                
                // 设置位置
                self.mj_y = scrollView.mj_contentH
            }
        }
    }
}



