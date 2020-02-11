//
//  MJRefreshFooter.swift
//  MJRefreshFramework
//
//  Created by 史晓义 on 2020/2/6.
//  Copyright © 2020 小码哥. All rights reserved.
//

import UIKit

@objc open class MJRefreshFooter: MJRefreshComponent
{
    //MARK: - 构造方法
    /// 创建footer
    @objc(footerWithRefreshingBlock:)
    public class func footerWithRefreshingBlock(refreshingBlock:@escaping MJRefreshComponentRefreshingBlock) -> Self {
        let cmp = Self()
        cmp.refreshingBlock = refreshingBlock
        return cmp
    }
    
    //MARK: - 公共方法
    /// 提示没有更多的数据
    @objc public func endRefreshingWithNoMoreData() {
        DispatchQueue.main.async { [weak self] in
            self?.state = .noMoreData
        }
    }
    /// 重置没有更多的数据（消除没有更多数据的状态）
    @objc public func resetNoMoreData() {
        DispatchQueue.main.async { [weak self] in
            self?.state = .idle
        }
    }
    
    /// 忽略多少scrollView的contentInset的bottom
    @objc public var ignoredScrollViewContentInsetBottom : CGFloat = 0
    override open func prepare() {
        super.prepare()
        // 设置自己的高度
        self.mj_h = MJRefreshFooterHeight
    }
}

//MARK: - 重写父类的方法
extension MJRefreshFooter
{
    
}
