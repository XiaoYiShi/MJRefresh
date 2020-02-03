//
//  MJRefreshAutoStateFooter.swift
//  MJRefreshFramework
//
//  Created by 史晓义 on 2020/2/2.
//  Copyright © 2020 小码哥. All rights reserved.
//

import UIKit

open class MJRefreshAutoStateFooter: MJRefreshAutoFooter
{
    /// 文字距离圈圈、箭头的距离
    public var labelLeftInset = CGFloat(0)
    
    /// 显示刷新状态的label
    @objc public lazy var stateLabel: UILabel = {
        let stateLabel = UILabel.mj_()!
        addSubview(stateLabel)
        return stateLabel
    }()
    
    /// 隐藏刷新状态的文字
    @objc public var isRefreshingTitleHidden = false
    
    /// 所有状态对应的文字
    private var stateTitles = [MJRefreshState:String]()
}

extension MJRefreshAutoStateFooter
{
    //MARK: - 公共方法
    /// 设置state状态下的文字
    @objc(setTitle:forState:)
    public func set(title:String,for state:MJRefreshState) {
        if (title.isEmpty) { return }
        self.stateTitles[state] = title
        self.stateLabel.text = self.stateTitles[self.state]
    }
    
    //MARK: - 私有方法
    @objc private func stateLabelClick() {
        if (self.state == .idle) {
            self.beginRefreshing()
        }
    }
    open override func beginRefreshing() {
        super.beginRefreshing()
    }
}
//MARK: - 重写父类的方法
extension MJRefreshAutoStateFooter
{
    override open func prepare() {
        super.prepare()
        // 初始化间距
        self.labelLeftInset = MJRefreshLabelLeftInset;
        
        // 初始化文字
        set(title: Bundle.mj_localizedString(forKey: MJRefreshAutoFooterIdleText), for: .idle)
        set(title: Bundle.mj_localizedString(forKey: MJRefreshAutoFooterRefreshingText), for: .refreshing)
        set(title: Bundle.mj_localizedString(forKey: MJRefreshAutoFooterNoMoreDataText), for: .noMoreData)
        
        // 监听label
        self.stateLabel.isUserInteractionEnabled = true
        self.stateLabel.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(stateLabelClick)))
    }
    
    override open func placeSubviews() {
        super.placeSubviews()
        if (self.stateLabel.constraints.count != 0) {return}
        
        // 状态标签
        self.stateLabel.frame = self.bounds
    }
    
    override open var state: MJRefreshState {
        get {
            return super.state
        }
        set {
            let oldState = self.state
            if (newValue == oldState) { return }
            super.state = newValue
            
            if self.isRefreshingTitleHidden,
                state == .refreshing
            {
                self.stateLabel.text = nil
            } else {
                self.stateLabel.text = self.stateTitles[state]
            }
        }
    }
}


