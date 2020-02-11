//
//  MJRefreshBackFooter.swift
//  MJRefreshFramework
//
//  Created by 史晓义 on 2020/2/4.
//  Copyright © 2020 小码哥. All rights reserved.
//

import UIKit

open class MJRefreshBackFooter: MJRefreshFooter
{
    private var lastRefreshCount = 0
    private var lastBottomDelta = CGFloat(0)
//}
//extension MJRefreshBackFooter
//{
    //MARK: - 初始化
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        scrollViewContentSizeDidChange(nil)
    }
    
    //MARK - 实现父类的方法
    override open func scrollViewContentOffsetDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewContentOffsetDidChange(change)
        
        // 如果正在刷新，直接返回
        if self.state == .refreshing { return }
        
        scrollViewOriginalInset = self.scrollView.mj_inset
        
        // 当前的contentOffset
        let currentOffsetY = self.scrollView.mj_offsetY
        // 尾部控件刚好出现的offsetY
        let happenOffsetY = self.happenOffsetY
        // 如果是向下滚动到看不见尾部控件，直接返回
        if (currentOffsetY <= happenOffsetY) { return }
        
        let pullingPercent = (currentOffsetY - happenOffsetY) / self.mj_h
        
        // 如果已全部加载，仅设置pullingPercent，然后返回
        if (self.state == .noMoreData) {
            self.pullingPercent = pullingPercent
            return
        }
        
        if (self.scrollView.isDragging) {
            self.pullingPercent = pullingPercent
            // 普通 和 即将刷新 的临界点
            let normal2pullingOffsetY = happenOffsetY + self.mj_h
            
            if self.state == .idle,
                currentOffsetY > normal2pullingOffsetY
            {
                // 转为即将刷新状态
                self.state = .pulling
            } else if self.state == .pulling,
                    currentOffsetY <= normal2pullingOffsetY
            {
                // 转为普通状态
                self.state = .idle
            }
        } else if (self.state == .pulling) {// 即将刷新 && 手松开
            // 开始刷新
            beginRefreshing()
        } else if (pullingPercent < 1) {
            self.pullingPercent = pullingPercent
        }
    }
    
    override open func scrollViewContentSizeDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewContentSizeDidChange(change)
        // 内容的高度
        let contentHeight = (self.scrollView?.mj_contentH ?? 0) + self.ignoredScrollViewContentInsetBottom
        // 表格的高度
        let scrollHeight = (self.scrollView?.mj_h ?? 0) - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom + self.ignoredScrollViewContentInsetBottom
        // 设置位置和尺寸
        self.mj_y = max(contentHeight, scrollHeight)
    }
    
    override open var state: MJRefreshState {
        set {
            let oldState = self.state
            if (newValue == oldState) { return }
            super.state = newValue
                
                // 根据状态来设置属性
            if (state == .noMoreData || state == .idle) {
                    // 刷新完毕
                if (.refreshing == oldState) {
                    UIView.animate(withDuration: TimeInterval(MJRefreshSlowAnimationDuration), animations: {
                        self.scrollView.mj_insetB -= self.lastBottomDelta
                        
                        self.endRefreshingAnimateCompletionBlock?()
                        
                        // 自动调整透明度
                        if self.isAutomaticallyChangeAlpha { self.alpha = 0.0 }
                    }) { (finished) in
                        self.pullingPercent = 0.0
                        
                        self.endRefreshingCompletionBlock?()
                    }
                    
                }
                    
                let deltaH = self.heightForContentBreakView
                    // 刚刷新完毕
                if .refreshing == oldState,
                    deltaH > 0,
                    self.scrollView.mj_totalDataCount() != self.lastRefreshCount
                {
                        self.scrollView.mj_offsetY = self.scrollView.mj_offsetY
                }
            } else if (state == .refreshing) {
                    // 记录刷新前的数量
                self.lastRefreshCount = self.scrollView.mj_totalDataCount()
                UIView.animate(withDuration: TimeInterval(MJRefreshFastAnimationDuration), animations: {
                    var bottom = self.mj_h + self.scrollViewOriginalInset.bottom
                    let deltaH = self.heightForContentBreakView
                    if (deltaH < 0) { // 如果内容高度小于view的高度
                        bottom -= deltaH
                    }
                    self.lastBottomDelta = bottom - self.scrollView.mj_insetB
                    self.scrollView.mj_insetB = bottom
                    self.scrollView.mj_offsetY = self.happenOffsetY + self.mj_h
                }) { (finished) in
                    self.executeRefreshingCallback()
                }
            }
        }
        get {
            return super.state
        }
    }
}

//MARK: - 私有方法
extension MJRefreshBackFooter
{
    //MARK: - 获得scrollView的内容 超出 view 的高度
    private var heightForContentBreakView : CGFloat {
        let h = (self.scrollView?.frame.size.height ?? 0) - self.scrollViewOriginalInset.bottom - self.scrollViewOriginalInset.top
        return (self.scrollView?.contentSize.height ?? 0) - h
    }
    //MARK: - 刚好看到上拉刷新控件时的contentOffset.y
    private var happenOffsetY : CGFloat {
        let deltaH = heightForContentBreakView
        if (deltaH > 0) {
            return deltaH - self.scrollViewOriginalInset.top
        } else {
            return -self.scrollViewOriginalInset.top
        }
    }
}


