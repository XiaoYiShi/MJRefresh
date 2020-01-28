////
////  MJRefreshHeader.swift
////  MJRefreshExample
////
////  Created by 史晓义 on 2020/1/27.
////  Copyright © 2020 小码哥. All rights reserved.
////
//
//import UIKit
//
//class MJRefreshHeader1 : MJRefreshComponent
//{
//    //MARK: - 构造方法
//    /** 创建header */
//    public class func headerWithRefreshingBlock(refreshingBlock:@escaping MJRefreshComponentRefreshingBlock) -> Self {
//        let cmp = Self()
//        cmp.refreshingBlock = refreshingBlock
//        return cmp
//    }
//    /** 创建header */
//    public class func headerWithRefreshingTarget(target:Any,refreshingAction action:Selector) -> Self {
//        let cmp = Self()
//        cmp.setRefreshingTarget(target, refreshingAction :action)
//        return cmp
//    }
//
//    /** 这个key用来存储上一次下拉刷新成功的时间 */
//    public var lastUpdatedTimeKey = ""
//
//
//    //MARK: - 公共方法
//    /** 上一次下拉刷新成功的时间 */
//    public var lastUpdatedTime : Date? {
//        return UserDefaults.standard.object(forKey: self.lastUpdatedTimeKey) as? Date
//    }
//
//    /** 忽略多少scrollView的contentInset的top */
//    public var ignoredScrollViewContentInsetTop = CGFloat(0) {
//        didSet {
//            self.mj_y = -self.mj_h - ignoredScrollViewContentInsetTop
//        }
//    }
//
//    private var insetTDelta = CGFloat(0)
//
//}
//
//extension MJRefreshHeader1
//{
//    //MARK: - 覆盖父类的方法
//    override func prepare() {
//        super.prepare()
//        // 设置key
//        self.lastUpdatedTimeKey = MJRefreshHeaderLastUpdatedTimeKey
//
//        // 设置高度
//        self.mj_h = MJRefreshHeaderHeight
//    }
//
//    override func placeSubviews() {
//        super.placeSubviews()
//        // 设置y值(当自己的高度发生改变了，肯定要重新调整Y值，所以放到placeSubviews方法中设置y值)
//        self.mj_y = -self.mj_h - self.ignoredScrollViewContentInsetTop
//    }
//
//    override var state: MJRefreshState {
//        get {
//            return super.state
//        }
//        set {
//            let oldState = self.state
//            if (newValue == oldState) { return }
//            super.state = newValue
//
//            // 根据状态做事情
//            if (state == .idle) {
//                if (oldState != .refreshing) { return }
//
//                // 保存刷新时间
//                UserDefaults.standard.set(Date(), forKey: self.lastUpdatedTimeKey)
//                UserDefaults.standard.synchronize()
//
//                // 恢复inset和offset
//                UIView.animate(
//                    withDuration: TimeInterval(MJRefreshSlowAnimationDuration),
//                    animations:
//                {
//                    self.scrollView.mj_insetT += self.insetTDelta;
//
//                    self.endRefreshingAnimateCompletionBlock?()
//
//                    // 自动调整透明度
//                    if (self.isAutomaticallyChangeAlpha) { self.alpha = 0.0 }
//                }) { (finished) in
//                    self.pullingPercent = 0.0
//
//                    self.endRefreshingCompletionBlock?()
//                }
//            } else if (state == .refreshing) {
//                MJRefreshDispatchAsyncOnMainQueue({
//                    [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
//                        if (self.scrollView.panGestureRecognizer.state != UIGestureRecognizerStateCancelled) {
//                            CGFloat top = self.scrollViewOriginalInset.top + self.mj_h;
//                            // 增加滚动区域top
//                            self.scrollView.mj_insetT = top;
//                            // 设置滚动位置
//                            CGPoint offset = self.scrollView.contentOffset;
//                            offset.y = -top;
//                            [self.scrollView setContentOffset:offset animated:NO];
//                        }
//                    } completion:^(BOOL finished) {
//                        [self executeRefreshingCallback];
//                    }];
//                })
//            }
//        }
//    }
//}
//
//extension MJRefreshHeader1
//{
//    private func resetInset() {
//        if (@available(iOS 11.0, *)) {
//        } else {
//            // 如果 iOS 10 及以下系统在刷新时, push 新的 VC, 等待刷新完成后回来, 会导致顶部 Insets.top 异常, 不能 resetInset, 检查一下这种特殊情况
//            if (!self.window) { return; }
//        }
//
//        // sectionheader停留解决
//        CGFloat insetT = - self.scrollView.mj_offsetY > _scrollViewOriginalInset.top ? - self.scrollView.mj_offsetY : _scrollViewOriginalInset.top;
//        insetT = insetT > self.mj_h + _scrollViewOriginalInset.top ? self.mj_h + _scrollViewOriginalInset.top : insetT;
//        self.scrollView.mj_insetT = insetT;
//
//        self.insetTDelta = _scrollViewOriginalInset.top - insetT;
//    }
//
//    override func scrollViewContentOffsetDidChange(_ change: [AnyHashable : Any]!) {
//        super.scrollViewContentOffsetDidChange(change)
//        // 在刷新的refreshing状态
//        if (self.state == .refreshing) {
//            resetInset()
//            return
//        }
//
//        // 跳转到下一个控制器时，contentInset可能会变
//        _scrollViewOriginalInset = self.scrollView.mj_inset
//
//        // 当前的contentOffset
//        CGFloat offsetY = self.scrollView.mj_offsetY;
//        // 头部控件刚好出现的offsetY
//        CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
//
//        // 如果是向上滚动到看不见头部控件，直接返回
//        // >= -> >
//        if (offsetY > happenOffsetY) return;
//
//        // 普通 和 即将刷新 的临界点
//        CGFloat normal2pullingOffsetY = happenOffsetY - self.mj_h;
//        CGFloat pullingPercent = (happenOffsetY - offsetY) / self.mj_h;
//
//        if (self.scrollView.isDragging) { // 如果正在拖拽
//            self.pullingPercent = pullingPercent;
//            if (self.state == MJRefreshStateIdle && offsetY < normal2pullingOffsetY) {
//                // 转为即将刷新状态
//                self.state = MJRefreshStatePulling;
//            } else if (self.state == MJRefreshStatePulling && offsetY >= normal2pullingOffsetY) {
//                // 转为普通状态
//                self.state = MJRefreshStateIdle;
//            }
//        } else if (self.state == MJRefreshStatePulling) {// 即将刷新 && 手松开
//            // 开始刷新
//            [self beginRefreshing];
//        } else if (pullingPercent < 1) {
//            self.pullingPercent = pullingPercent;
//        }
//    }
//}
