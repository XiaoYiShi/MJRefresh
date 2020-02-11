//
//  MJRefreshComponent.swift
//  MJRefreshFramework
//
//  Created by 史晓义 on 2020/2/6.
//  Copyright © 2020 小码哥. All rights reserved.
//

import UIKit
import os_object

/** 刷新控件的基类 */
@objc open class MJRefreshComponent: UIView
{
    
    //MARK: - 刷新回调
    /** 正在刷新的回调 */
    @objc public var refreshingBlock : MJRefreshComponentRefreshingBlock?
    
    //MARK: - 内部方法
    /// 触发回调（交给子类去调用）
    public func executeRefreshingCallback()
    {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.refreshingBlock?()
            
            self.beginRefreshingCompletionBlock?()
        }
    }
    
    //MARK: - 刷新状态控制
    /** 进入刷新状态 */
    //MARK: - 进入刷新状态
    @objc public func beginRefreshing()
    {
        UIView.animate(withDuration: TimeInterval(MJRefreshFastAnimationDuration)) {
            self.alpha = 1.0
        }
        self.pullingPercent = 1.0
        // 只要正在刷新，就完全显示
        if (self.window != nil) {
            self.state = .refreshing
        } else {
            // 预防正在刷新中时，调用本方法使得header inset回置失败
            if (self.state != .refreshing) {
                self.state = .willRefresh
                // 刷新(预防从另一个控制器回到这个控制器的情况，回来要重新刷新一下)
                self.setNeedsDisplay()
            }
        }
    }
    @objc(beginRefreshingWithCompletionBlock:)
    func beginRefreshingWithCompletionBlock(completionBlock:@escaping ()->Void)
    {
        self.beginRefreshingCompletionBlock = completionBlock
        self.beginRefreshing()
    }
    
    /** 开始刷新后的回调(进入刷新状态后的回调) */
    public var beginRefreshingCompletionBlock : MJRefreshComponentBeginRefreshingCompletionBlock?
    /** 带动画的结束刷新的回调 */
    public var endRefreshingAnimateCompletionBlock : MJRefreshComponentEndRefreshingCompletionBlock?
    /** 结束刷新的回调 */
    public var endRefreshingCompletionBlock : MJRefreshComponentEndRefreshingCompletionBlock?
    /** 结束刷新状态 */
    //MARK: - 结束刷新状态
    @objc public func endRefreshing()
    {
        DispatchQueue.main.async {
            self.state = .idle
        }
    }
    @objc(endRefreshingWithCompletionBlock:)
    func endRefreshingWithCompletionBlock(completionBlock:@escaping ()->Void)
    {
        self.endRefreshingCompletionBlock = completionBlock
        self.endRefreshing()
    }
    
    //MARK: - 是否正在刷新
    /** 是否正在刷新 */
    public var isRefreshing : Bool
    {
        return self.state == .refreshing || self.state == .willRefresh
    }
    
    /** 刷新状态 一般交给子类内部实现 */
    public var state : MJRefreshState = .idle {
        didSet {
            // 加入主队列的目的是等setState:方法调用完毕、设置完文字后再去布局子控件
            DispatchQueue.main.async { [weak self] in
                self?.setNeedsLayout()
            }
        }
    }
    //MARK: - 交给子类去访问
    /** 记录scrollView刚开始的inset */
    public var scrollViewOriginalInset : UIEdgeInsets!
    
    /** 父控件 */
    public private(set) var scrollView : UIScrollView!
    
    //MARK: - 交给子类们去实现
    /** 初始化 */
    open func prepare()
    {
        // 基本属性
        self.autoresizingMask = .flexibleWidth
        self.backgroundColor = .clear
    }
    /** 摆放子控件frame */
    open func placeSubviews() {}
    /** 当scrollView的contentOffset发生改变的时候调用 */
    open func scrollViewContentOffsetDidChange(_ change: [AnyHashable : Any]!) {}
    /** 当scrollView的contentSize发生改变的时候调用 */
    open func scrollViewContentSizeDidChange(_ change: [AnyHashable : Any]!) {}
    /** 当scrollView的拖拽状态发生改变的时候调用 */
    open func scrollViewPanStateDidChange(_ change: [AnyHashable : Any]!) {}
    
    //MARK: - 其他
    
    //MARK: - 根据拖拽进度设置透明度
    /// 拉拽的百分比(交给子类重写)
    open var pullingPercent:CGFloat = 0 {
        didSet {
            if (self.isRefreshing) { return }
            
            if (self.isAutomaticallyChangeAlpha) {
                self.alpha = pullingPercent
            }
        }
    }
    
    //MARK: - 自动切换透明度
    ///根据拖拽比例自动切换透明度
    @objc public var isAutomaticallyChangeAlpha = false {
        didSet {
            if (self.isRefreshing) { return }
            
            if (isAutomaticallyChangeAlpha) {
                self.alpha = self.pullingPercent
            } else {
                self.alpha = 1.0
            }
        }
    }
    
    private var pan : UIPanGestureRecognizer?
    
    //MARK: - 初始化
    public override init(frame: CGRect) {
        super.init(frame: frame)
        // 准备工作
        self.prepare()
        
        // 默认是普通状态
        self.state = .idle
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MJRefreshComponent
{
    
    override open func layoutSubviews() {
        self.placeSubviews()
        super.layoutSubviews()
    }
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        if (self.state == .willRefresh) {
            // 预防view还没显示出来就调用了beginRefreshing
            self.state = .refreshing
        }
    }
}

extension MJRefreshComponent
{
    
    override open func willMove(toSuperview newSuperview: UIView?)
    {
        super.willMove(toSuperview: newSuperview)
        
        // 如果不是UIScrollView，不做任何事情
        guard let scrollView = newSuperview as? UIScrollView else {
            return
        }
        
        // 旧的父控件移除监听
        self.removeObservers()
        
        // 记录UIScrollView
        self.scrollView = scrollView
        // 设置宽度
        self.mj_w = scrollView.mj_w
        // 设置位置
        self.mj_x = -scrollView.mj_insetL
        
        // 设置永远支持垂直弹簧效果
        self.scrollView?.alwaysBounceVertical = true
        // 记录UIScrollView最开始的contentInset
        scrollViewOriginalInset = scrollView.mj_inset
        
        // 添加监听
        self.addObservers()
    }
    
}

//MARK: - KVO监听

extension MJRefreshComponent
{
    private func addObservers()
    {
//        let options:OptionSet = [NSKeyValueObservingOptions.new , NSKeyValueObservingOptions.old]
        self.scrollView?.addObserver(self, forKeyPath: MJRefreshKeyPathContentOffset, options: [NSKeyValueObservingOptions.new , NSKeyValueObservingOptions.old], context: nil)
        self.scrollView?.addObserver(self, forKeyPath: MJRefreshKeyPathContentSize, options: [NSKeyValueObservingOptions.new , NSKeyValueObservingOptions.old], context: nil)
        self.pan = self.scrollView?.panGestureRecognizer
        self.pan?.addObserver(self, forKeyPath: MJRefreshKeyPathPanState, options: [NSKeyValueObservingOptions.new , NSKeyValueObservingOptions.old], context: nil)
    }
    
    private func removeObservers()
    {
        self.superview?.removeObserver(self, forKeyPath: MJRefreshKeyPathContentOffset)
        self.superview?.removeObserver(self, forKeyPath: MJRefreshKeyPathContentSize)
        self.pan?.removeObserver(self, forKeyPath: MJRefreshKeyPathPanState)
        self.pan = nil
    }
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        // 遇到这些情况就直接返回
        if (!self.isUserInteractionEnabled) { return }
        
        // 这个就算看不见也需要处理
        if keyPath == MJRefreshKeyPathContentSize {
            scrollViewContentSizeDidChange(change)
        }
        
        // 看不见
        if (self.isHidden) { return }
        if keyPath == MJRefreshKeyPathContentOffset {
            scrollViewContentOffsetDidChange(change)
        } else if keyPath == MJRefreshKeyPathPanState {
            scrollViewPanStateDidChange(change)
        }
    }
}

