//
//  MJChiBaoZiFooter2.swift
//  MJRefreshExample
//
//  Created by 史晓义 on 2020/1/31.
//  Copyright © 2020 小码哥. All rights reserved.
//

import UIKit
import MJRefresh
@objc public class MJChiBaoZiFooter2: MJRefreshBackGifFooter
{
    override public func prepare() {
        super.prepare()
        // 设置普通状态的动画图片
        var idleImages = [UIImage]()
        for i in 1...60 {
            let image = UIImage.init(named: String.init(format: "dropdown_anim__000%zd", i))
            idleImages.append(image!)
        }
        
        setImages(images: idleImages, for: .idle)
        
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        var refreshingImages = [UIImage]()
        for i in 1...3 {
            let image = UIImage.init(named: String.init(format: "dropdown_loading_0%zd", i))
            refreshingImages.append(image!)
        }
        setImages(images: refreshingImages, for: .pulling)
        
        // 设置正在刷新状态的动画图片
        setImages(images: refreshingImages, for: .refreshing)
    }
}

