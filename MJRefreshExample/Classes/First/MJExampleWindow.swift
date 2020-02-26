//
//  MJExampleWindow.swift
//  MJRefreshExample
//
//  Created by 史晓义 on 2020/2/23.
//  Copyright © 2020 小码哥. All rights reserved.
//

import UIKit

@objc class MJExampleWindow: UIWindow {
    
    
    static var window_ : UIWindow?
    @objc class func show() {
        window_ = UIWindow()
        let width:CGFloat = 150
        let x:CGFloat = UIScreen.main.bounds.size.width - width - 10
        var y:CGFloat = 0
        
        if #available(iOS 11.0, *) {
            let safeInsets = UIApplication.shared.windows.first?.safeAreaInsets
            y = safeInsets?.top ?? 0
        } else {
            // Fallback on earlier versions
        }
                
        window_?.frame = CGRect.init(x: x, y: y, width: width, height: 25)
        window_?.windowLevel = .alert
        window_?.isHidden = false
        window_?.alpha = 0.5
        window_?.rootViewController = MJTempViewController()
        window_?.backgroundColor = .clear
    }
}
