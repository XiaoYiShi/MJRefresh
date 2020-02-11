//
//  UIScrollView+MJRefresh.swift
//  MJRefreshFramework
//
//  Created by 史晓义 on 2020/2/5.
//  Copyright © 2020 小码哥. All rights reserved.
//

import UIKit

//MARK: - header
public extension UIScrollView
{
    private static var MJRefreshHeaderKey = 0
    
    /// 下拉刷新控件
    @objc var mj_header: MJRefreshHeader? {
        get {
            return objc_getAssociatedObject(self, &UIScrollView.MJRefreshHeaderKey) as? MJRefreshHeader
        }
        set {
            if (newValue != self.mj_header) {
                // 删除旧的，添加新的
                self.mj_header?.removeFromSuperview()
                if newValue != nil {
                    self.insertSubview(newValue!, at: 0)
                }
                // 存储新的
                objc_setAssociatedObject(self, &UIScrollView.MJRefreshHeaderKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
    }
}


//MARK: - footer
public extension UIScrollView
{
    private static var MJRefreshFooterKey = 0
    
    /// 上拉刷新控件
    @objc var mj_footer: MJRefreshFooter? {
        get {
            return objc_getAssociatedObject(self, &UIScrollView.MJRefreshFooterKey) as? MJRefreshFooter
        }
        set {
            if (newValue != self.mj_footer) {
                // 删除旧的，添加新的
                self.mj_footer?.removeFromSuperview()
                if newValue != nil {
                    self.insertSubview(newValue!, at: 0)
                }
                // 存储新的
                objc_setAssociatedObject(self, &UIScrollView.MJRefreshFooterKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
    }
}

//MARK: - other
extension UIScrollView
{
    func mj_totalDataCount() -> Int
    {
        var totalCount = 0
        if let tableView = self as? UITableView
        {
            for section in 0..<tableView.numberOfSections {
                totalCount += tableView.numberOfRows(inSection: section)
            }
        }
        else if let collectionView = self as? UICollectionView
        {
            for section in 0..<collectionView.numberOfSections {
                totalCount += collectionView.numberOfItems(inSection: section)
            }
        }
        return totalCount
    }
}

extension UIScrollView
{
    var mj_offsetX: CGFloat {
        get {
            return self.contentOffset.x
        }
        set {
            var offset = self.contentOffset
            offset.x = newValue
            self.contentOffset = offset
        }
    }
    
    var mj_offsetY: CGFloat {
        get {
            return self.contentOffset.y
        }
        set {
            var offset = self.contentOffset
            offset.y = newValue
            self.contentOffset = offset
        }
    }
    
    var mj_contentW: CGFloat {
        get {
            return self.contentSize.width
        }
        set {
            var size = self.contentSize
            size.width = newValue
            self.contentSize = size
        }
    }
    
    var mj_contentH: CGFloat {
        get {
            return self.contentSize.height
        }
        set {
            var size = self.contentSize
            size.height = newValue
            self.contentSize = size
        }
    }
}

extension UIScrollView
{
    @available(iOS 11.0, *)
    private static var respondsToAdjustedContentInset_ : Bool {
        return self.instancesRespond(to: #selector(getter: adjustedContentInset))
    }
    
    var mj_inset: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            if (UIScrollView.respondsToAdjustedContentInset_) {
                return self.adjustedContentInset;
            }
        }
        return self.contentInset
    }
    
    var mj_insetT: CGFloat {
        get {
            return self.mj_inset.top
        }
        set {
            var inset = self.contentInset
            inset.top = newValue
            
            if #available(iOS 11.0, *) {
                if (UIScrollView.respondsToAdjustedContentInset_) {
                    inset.top -= (self.adjustedContentInset.top - self.contentInset.top)
                }
            }
            self.contentInset = inset
        }
    }
    
    var mj_insetB: CGFloat {
        get {
            return self.mj_inset.bottom
        }
        set {
            var inset = self.contentInset
                inset.bottom = newValue
            if #available(iOS 11.0, *) {
                if (UIScrollView.respondsToAdjustedContentInset_) {
                    inset.bottom -= (self.adjustedContentInset.bottom - self.contentInset.bottom)
                }
            }
            
            self.contentInset = inset
        }
    }

    var mj_insetL: CGFloat {
        get {
            return self.mj_inset.left
        }
        set {
            
            var inset = self.contentInset
                inset.left = newValue
            if #available(iOS 11.0, *) {
                if (UIScrollView.respondsToAdjustedContentInset_) {
                    inset.left -= (self.adjustedContentInset.left - self.contentInset.left)
                }
            }
            
            self.contentInset = inset
        }
    }
    
    var mj_insetR: CGFloat {
        get {
            return self.mj_inset.right
        }
        set {
            var inset = self.contentInset
                inset.right = newValue
            if #available(iOS 11.0, *) {
                if (UIScrollView.respondsToAdjustedContentInset_) {
                    inset.right -= (self.adjustedContentInset.right - self.contentInset.right)
                }
            }
            self.contentInset = inset
        }
    }
    
}

