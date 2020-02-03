//
//  MJRefreshStateHeader.swift
//  MJRefreshExample
//
//  Created by 史晓义 on 2020/1/24.
//  Copyright © 2020 小码哥. All rights reserved.
//

import UIKit

open class MJRefreshStateHeader: MJRefreshHeader
{
    //MARK: - 刷新时间相关
    /// 利用这个block来决定显示的更新时间文字
    public var lastUpdatedTimeText : ((_ lastUpdatedTime:Date?)->String)?
    
    /// 显示上一次刷新时间的label
    @objc public lazy var lastUpdatedTimeLabel: UILabel = {
        let _lastUpdatedTimeLabel = UILabel.mj_()!
        addSubview(_lastUpdatedTimeLabel)
        return _lastUpdatedTimeLabel
    }()
    
    //MARK: - 状态相关
    /// 文字距离圈圈、箭头的距离
    public var labelLeftInset = CGFloat(0)
    /// 显示刷新状态的label
    @objc public lazy var stateLabel: UILabel = {
        let _stateLabel = UILabel.mj_()!
        addSubview(_stateLabel)
        return _stateLabel
    }()
    
    //MARK: - 公共方法
    
    /// 设置state状态下的文字
    @objc(setTitle:forState:)
    public func setTitle(_ title:String,for state:MJRefreshState)
    {
        if (title.isEmpty) { return }
        self.stateTitles[state] = title
        self.stateLabel.text = self.stateTitles[self.state]
    }
    
    /// 所有状态对应的文字
    private var stateTitles = [MJRefreshState:String]()
}


extension MJRefreshStateHeader
{
    
    //MARK: - key的处理
    open override var lastUpdatedTimeKey: String! {
        didSet {
            
            // 如果label隐藏了，就不用再处理
            if (self.lastUpdatedTimeLabel.isHidden) { return }
            
            let lastUpdatedTime = UserDefaults.standard.object(forKey: lastUpdatedTimeKey) as? Date
            
            
            // 如果有block
            if (self.lastUpdatedTimeText != nil) {
                self.lastUpdatedTimeLabel.text = self.lastUpdatedTimeText?(lastUpdatedTime)
                return
            }
            
            if let lastUpdatedTime = lastUpdatedTime {
                // 1.获得年月日
                let calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
                let unitFlags:Set<Calendar.Component> = [.year,.month,.day,.hour,.minute]
                let cmp1 = calendar.dateComponents(unitFlags, from: lastUpdatedTime)
                let cmp2 = calendar.dateComponents(unitFlags, from: Date())
                
                // 2.格式化日期
                let formatter = DateFormatter()
                var isToday = false
                
                if cmp1.day == cmp2.day { // 今天
                    formatter.dateFormat = " HH:mm"
                    isToday = true
                } else if cmp1.year == cmp2.year { // 今年
                    formatter.dateFormat = "MM-dd HH:mm"
                } else {
                    formatter.dateFormat = "yyyy-MM-dd HH:mm"
                }
                let time = formatter.string(from: lastUpdatedTime)
                
                // 3.显示日期
                self.lastUpdatedTimeLabel.text = String.init(
                    format: "%@%@%@",
                    Bundle.mj_localizedString(forKey: MJRefreshHeaderLastTimeText),
                    isToday ? Bundle.mj_localizedString(forKey: MJRefreshHeaderDateTodayText) : "",
                    time
                )
            } else {
                self.lastUpdatedTimeLabel.text = String.init(
                    format: "%@%@",
                    Bundle.mj_localizedString(forKey: MJRefreshHeaderLastTimeText),
                    Bundle.mj_localizedString(forKey: MJRefreshHeaderNoneLastDateText)
                )
            }
        }
    }
}

extension MJRefreshStateHeader
{
    //MARK: - 覆盖父类的方法
    open override func prepare() {
        super.prepare()
        // 初始化间距
        self.labelLeftInset = MJRefreshLabelLeftInset
        
        // 初始化文字
        setTitle(Bundle.mj_localizedString(forKey: MJRefreshHeaderIdleText), for: .idle)
        setTitle(Bundle.mj_localizedString(forKey: MJRefreshHeaderPullingText), for: .pulling)
        setTitle(Bundle.mj_localizedString(forKey: MJRefreshHeaderRefreshingText), for: .refreshing)
    }
    
    open override func placeSubviews() {
        super.placeSubviews()
        
        if (self.stateLabel.isHidden) { return }
        
        let noConstrainsOnStatusLabel = self.stateLabel.constraints.count == 0
        
        if (self.lastUpdatedTimeLabel.isHidden) {
            // 状态
            if noConstrainsOnStatusLabel {
                self.stateLabel.frame = self.bounds
            }
        } else {
            let stateLabelH = self.mj_h * 0.5
            // 状态
            if noConstrainsOnStatusLabel {
                self.stateLabel.mj_x = 0
                self.stateLabel.mj_y = 0
                self.stateLabel.mj_w = self.mj_w
                self.stateLabel.mj_h = stateLabelH
            }
            
            // 更新时间
            if self.lastUpdatedTimeLabel.constraints.count == 0 {
                self.lastUpdatedTimeLabel.mj_x = 0
                self.lastUpdatedTimeLabel.mj_y = stateLabelH
                self.lastUpdatedTimeLabel.mj_w = self.mj_w
                self.lastUpdatedTimeLabel.mj_h = self.mj_h - self.lastUpdatedTimeLabel.mj_y
            }
        }
    }
    open override var state: MJRefreshState {
        set {
            let oldState = self.state
            if (newValue == oldState) { return }
            super.state = newValue
            
            // 设置状态文字
            self.stateLabel.text = self.stateTitles[state]
            
            // 重新设置key（重新显示时间）
            let lastUpdatedTimeKey = self.lastUpdatedTimeKey
            self.lastUpdatedTimeKey = lastUpdatedTimeKey
        }
        get {
            return super.state
        }
    }
    
}
