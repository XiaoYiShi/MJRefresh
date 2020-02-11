//
//  MJDIYAutoFooter.swift
//  MJRefreshExample
//
//  Created by 史晓义 on 2020/2/4.
//  Copyright © 2020 小码哥. All rights reserved.
//

import UIKit
import MJRefresh

@objc public class MJDIYAutoFooter: MJRefreshAutoFooter
{
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    private lazy var s: UISwitch = {
        let s = UISwitch()
        return s
    }()
    private lazy var loading: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView.init(style: .gray)
        return loading
    }()
//}
//
//extension MJDIYAutoFooter
//{
//
//}
//
////MARK: - 重写方法
//extension MJDIYAutoFooter
//{
    //MARK: - 在这里做一些初始化配置（比如添加子控件）
    override public func prepare() {
        super.prepare()
        
        // 设置控件的高度
        self.mj_h = 50;
        
        // 添加label
        addSubview(label)
                
        // 打酱油的开关
        addSubview(s)
            
        // loading
        addSubview(loading)
    }
    
    //MARK: - 在这里设置子控件的位置和尺寸
    override public func placeSubviews() {
        super.placeSubviews()
        
        self.label.frame = self.bounds
        self.s.center = CGPoint.init(x: self.mj_w - 20, y: self.mj_h - 20)
        
        self.loading.center = CGPoint.init(x: 30, y: self.mj_h * 0.5)
    }
    
    //MARK: - 监听scrollView的contentOffset改变
    override public func scrollViewContentOffsetDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewContentOffsetDidChange(change)
        
    }
    
    
    //MARK: - 监听scrollView的contentSize改变
    override public func scrollViewContentSizeDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewContentSizeDidChange(change)
    }
    
    //MARK: - 监听scrollView的拖拽状态改变
    override public func scrollViewPanStateDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewPanStateDidChange(change)
    }
    
    //MARK: - 监听控件的刷新状态
    override public var state: MJRefreshState {
        get {
            return super.state
        }
        set {
            let oldState = self.state
            if (newValue == oldState) { return }
            super.state = newValue
            
            switch (state) {
            case .idle:
                self.label.text = "赶紧上拉吖(开关是打酱油滴)"
                self.loading.stopAnimating()
                s.setOn(false, animated: true)
                break
            case .refreshing:
                s.setOn(true, animated: true)
                self.label.text = "加载数据中(开关是打酱油滴)"
                self.loading.startAnimating()
                break
            case .noMoreData:
                self.label.text = "木有数据了(开关是打酱油滴)"
                s.setOn(false, animated: true)
                self.loading.stopAnimating()
            default:
                break
            }
        }
    }
}


