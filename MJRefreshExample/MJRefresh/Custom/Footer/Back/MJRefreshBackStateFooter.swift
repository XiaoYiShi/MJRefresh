//
//  MJRefreshBackStateFooter.swift
//  MJRefreshExample
//
//  Created by 史晓义 on 2020/1/31.
//  Copyright © 2020 小码哥. All rights reserved.
//

import UIKit

open class MJRefreshBackStateFooter: MJRefreshBackFooter
{
    /// 文字距离圈圈、箭头的距离
    public var labelLeftInset = CGFloat(0)
    
    /// 显示刷新状态的label
    public lazy var stateLabel: UILabel = {
        let stateLabel = UILabel.mj_()!
        addSubview(stateLabel)
        return stateLabel
    }()
    
    /// 所有状态对应的文字
    private var stateTitles = [MJRefreshState:String]()
}
//MARK: - 公共方法
extension MJRefreshBackStateFooter
{
    /// 设置state状态下的文字
    @objc(setTitle:forState:)
    public func set(title:String,for state:MJRefreshState) {
        if (title.isEmpty) { return }
        self.stateTitles[state] = title
        self.stateLabel.text = self.stateTitles[self.state]
    }
    
    /// 获取state状态下的title
    @objc(titleForState:)
    public func title(for state:MJRefreshState) -> String {
        return self.stateTitles[state] ?? ""
    }
}
//MARK: - 重写父类的方法
extension MJRefreshBackStateFooter
{
    open override func prepare() {
        super.prepare()
        
        // 初始化间距
        self.labelLeftInset = MJRefreshLabelLeftInset
        
        // 初始化文字
        set(title: Bundle.mj_localizedString(forKey: MJRefreshBackFooterIdleText), for: .idle)
        set(title: Bundle.mj_localizedString(forKey: MJRefreshBackFooterPullingText), for: .pulling)
        set(title: Bundle.mj_localizedString(forKey: MJRefreshBackFooterRefreshingText), for: .refreshing)
        set(title: Bundle.mj_localizedString(forKey: MJRefreshBackFooterNoMoreDataText), for: .noMoreData)
    }
    
    open override func placeSubviews() {
        super.placeSubviews()
        if (self.stateLabel.constraints.count != 0) { return }
        
        // 状态标签
        self.stateLabel.frame = self.bounds
    }
    
    open override var state: MJRefreshState {
        get {
            return super.state
        }
        set {
            let oldState = self.state
            if (newValue == oldState) { return }
            super.state = newValue
            
            // 设置状态文字
            self.stateLabel.text = self.stateTitles[state]
        }
    }
}

