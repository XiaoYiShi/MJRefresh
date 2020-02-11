//
//  MJChiBaoZiFooter.swift
//  MJRefreshExample
//
//  Created by 史晓义 on 2020/2/2.
//  Copyright © 2020 小码哥. All rights reserved.
//

import MJRefresh
import UIKit

@objc public class MJChiBaoZiFooter: MJRefreshAutoGifFooter
{
    override public func prepare() {
        super.prepare()
        // 设置正在刷新状态的动画图片
        var refreshingImages = [UIImage]()
        for i in 1...3 {
            let image = UIImage.init(named: String.init(format: "dropdown_loading_0%zd", i))
            refreshingImages.append(image!)
        }
        setImages(images: refreshingImages, for: .refreshing)
    }
}
