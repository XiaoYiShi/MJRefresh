//
//  MJDIYHeader.swift
//  MJRefreshExample
//
//  Created by 史晓义 on 2020/2/6.
//  Copyright © 2020 小码哥. All rights reserved.
//

import MJRefresh
import UIKit

@objc public class MJDIYHeader: MJRefreshHeader
{
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .init(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    lazy var s: UISwitch = {
        let s = UISwitch()
        return s
    }()
    lazy var logo: UIImageView = {
        let logo = UIImageView.init(image: UIImage.init(named: "Logo"))
        logo.contentMode = .scaleAspectFit
        return logo
    }()
    lazy var loading: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView.init(style: .gray)
        return loading
    }()
//}
//
////MARK: - 重写方法
//extension MJDIYHeader
//{
    //MARK: - 在这里做一些初始化配置（比如添加子控件）
    override public func prepare() {
        super.prepare()
        // 设置控件的高度
        self.mj_h = 50
        
        // 添加label
        addSubview(label)
        
        // 打酱油的开关
        addSubview(s)
        
        // logo
        addSubview(logo)
        
        // loading
        addSubview(loading)
    }
    
    //MARK: - 在这里设置子控件的位置和尺寸
    override public func placeSubviews() {
        super.placeSubviews()
        self.label.frame = self.bounds
        self.logo.bounds = CGRect.init(x: 0, y: 0, width: self.bounds.size.width, height: 100)
        self.logo.center = CGPoint.init(x: self.mj_w * 0.5, y: -self.logo.mj_h + 20)
        self.loading.center = CGPoint.init(x: self.mj_w - 30, y: self.mj_h * 0.5)
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
                self.loading.stopAnimating()
                self.s.setOn(false, animated: true)
                self.label.text = "赶紧下拉吖(开关是打酱油滴)"
            case .pulling:
                self.loading.stopAnimating()
                self.s.setOn(true, animated: true)
                self.label.text = "赶紧放开我吧(开关是打酱油滴)"
            case .refreshing:
                self.s.setOn(true, animated: true)
                self.label.text = "加载数据中(开关是打酱油滴)"
                self.loading.startAnimating()
            default:
                break
            }
        }
    }
    
    //MARK: - 监听拖拽比例（控件被拖出来的比例）
    override public var pullingPercent: CGFloat {
        didSet {
            // 1.0 0.5 0.0
            // 0.5 0.0 0.5
            let red = 1.0 - pullingPercent * 0.5
            let green = 0.5 - 0.5 * pullingPercent
            let blue = 0.5 * pullingPercent
            self.label.textColor = UIColor.init(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}
