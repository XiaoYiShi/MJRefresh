//
//  MJChiBaoZiHeader.swift
//  MJRefreshExample
//
//  Created by YiCZB on 2020/1/20.
//  Copyright © 2020 小码哥. All rights reserved.
//

import MJRefresh
import UIKit

@objc public class MJChiBaoZiHeader: MJRefreshGifHeader
{
    
    override public func prepare() {
        super.prepare()
        // 设置普通状态的动画图片
        var idleImages = [UIImage]()
        for i in 1...60 {
            let image = UIImage.init(named: String.init(format: "dropdown_anim__000%zd", i))
            idleImages.append(image!)
        }
        setImages(images: idleImages, for: MJRefreshState.idle)
        
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        var refreshingImages = [UIImage]()
        for i in 1...3 {
            let image = UIImage.init(named: String.init(format: "dropdown_loading_0%zd", i))
            refreshingImages.append(image!)
        }
        setImages(images: refreshingImages, for: MJRefreshState.pulling)
        
        // 设置正在刷新状态的动画图片
        setImages(images: refreshingImages, for: MJRefreshState.refreshing)
    }
}
