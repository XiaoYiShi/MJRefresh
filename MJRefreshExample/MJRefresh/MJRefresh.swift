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
    
}



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
