//
//  MJRefresh.swift
//  MJRefreshExample
//
//  Created by YiCZB on 2020/1/20.
//  Copyright © 2020 小码哥. All rights reserved.
//

import UIKit



public struct MJRefresh
{

//    /** 刷新控件的状态 */
//    public enum State:Int {
//        /** 普通闲置状态 */
//        case idle = 1
//        /** 松开就可以进行刷新的状态 */
//        case pulling = 2
//        /** 正在刷新中的状态 */
//        case refreshing = 3
//        /** 即将刷新的状态 */
//        case willRefresh = 4
//        /** 所有数据加载完毕，没有更多的数据了 */
//        case noMoreData = 5
//    }
}
///** 进入刷新状态的回调 */
//typealias MJRefreshComponentRefreshingBlock = (()->Void)
///** 开始刷新后的回调(进入刷新状态后的回调) */
//typealias MJRefreshComponentBeginRefreshingCompletionBlock = (()->Void)
///** 结束刷新后的回调 */
//typealias MJRefreshComponentEndRefreshingCompletionBlock = (()->Void)


//MARK: - MJRefreshProtocol

//Gif刷新使用的传参协议
public protocol MJRefreshProtocol_Gif
{
    /** 设置state状态下的动画图片images 动画持续时间duration*/
    func setImages(images:[UIImage],duration:TimeInterval,for state:MJRefreshState)
    func setImages(images:[UIImage],for state:MJRefreshState)
}
extension MJRefreshProtocol_Gif
{
    public func setImages(images: [UIImage], for state: MJRefreshState) {
        setImages(images: images, duration: Double(images.count) * 0.1, for: state)
    }
}


public protocol MJRefreshProtocol_SubViews
{
    func prepare()
    func placeSubviews()
    var state: MJRefreshState { get set }
}

//MARK: - 交给子类们去实现
//protocol MJRefreshProtocol_SubClassFunc {
//    /// 初始化
//    func prepare()
//    /// 摆放子控件frame
//    func placeSubviews()
//    /// 当scrollView的contentOffset发生改变的时候调用
//    func scrollViewContentOffsetDidChange(_ change: [AnyHashable : Any]!)
//    /// 当scrollView的contentSize发生改变的时候调用
//    func scrollViewContentSizeDidChange(_ change: [AnyHashable : Any]!)
//    /// 当scrollView的拖拽状态发生改变的时候调用
//    func scrollViewPanStateDidChange(_ change: [AnyHashable : Any]!)
//}

// 文字颜色
let MJRefreshLabelTextColor = UIColor.init(red: 90/255.0, green: 90/255.0, blue: 90/255.0, alpha: 1.0)
// 字体大小
let MJRefreshLabelFont = UIFont.boldSystemFont(ofSize: 14)

extension UILabel
{
    static func mj_label() -> Self
    {
        let label = Self()
        label.font = MJRefreshLabelFont;
        label.textColor = MJRefreshLabelTextColor
        label.autoresizingMask = .flexibleWidth
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }
    
    /// get
    var mj_textWidth: CGFloat {
        var stringWidth:CGFloat = 0
        let size = CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        if self.text?.count ?? 0 > 0 {
            stringWidth = NSString.init(string: self.text ?? "").boundingRect(
                with: size,
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                attributes: [NSAttributedString.Key.font : self.font ?? UIFont.systemFont(ofSize: 0)],
                context: nil
                ).size.width
        }
        return stringWidth
    }
}



let MJRefreshLabelLeftInset:CGFloat = 25
let MJRefreshHeaderHeight:CGFloat = 54.0
let MJRefreshFooterHeight:CGFloat = 44.0
let MJRefreshFastAnimationDuration:CGFloat = 0.25
let MJRefreshSlowAnimationDuration:CGFloat = 0.4

let MJRefreshKeyPathContentOffset = "contentOffset"
let MJRefreshKeyPathContentInset = "contentInset"
let MJRefreshKeyPathContentSize = "contentSize"
let MJRefreshKeyPathPanState = "state"

let MJRefreshHeaderLastUpdatedTimeKey = "MJRefreshHeaderLastUpdatedTimeKey"

let MJRefreshHeaderIdleText = "MJRefreshHeaderIdleText"
let MJRefreshHeaderPullingText = "MJRefreshHeaderPullingText"
let MJRefreshHeaderRefreshingText = "MJRefreshHeaderRefreshingText"

let MJRefreshAutoFooterIdleText = "MJRefreshAutoFooterIdleText"
let MJRefreshAutoFooterRefreshingText = "MJRefreshAutoFooterRefreshingText"
let MJRefreshAutoFooterNoMoreDataText = "MJRefreshAutoFooterNoMoreDataText"

let MJRefreshBackFooterIdleText = "MJRefreshBackFooterIdleText"
let MJRefreshBackFooterPullingText = "MJRefreshBackFooterPullingText"
let MJRefreshBackFooterRefreshingText = "MJRefreshBackFooterRefreshingText"
let MJRefreshBackFooterNoMoreDataText = "MJRefreshBackFooterNoMoreDataText"

let MJRefreshHeaderLastTimeText = "MJRefreshHeaderLastTimeText"
let MJRefreshHeaderDateTodayText = "MJRefreshHeaderDateTodayText"
let MJRefreshHeaderNoneLastDateText = "MJRefreshHeaderNoneLastDateText"

