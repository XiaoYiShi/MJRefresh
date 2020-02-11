//
//  MJRefreshConfig.swift
//  MJRefreshFramework
//
//  Created by 史晓义 on 2020/2/10.
//  Copyright © 2020 小码哥. All rights reserved.
//

import UIKit

class MJRefreshConfig: NSObject
{
    /// 默认使用的语言版本, 默认为 nil. 将随系统的语言自动改变
    var languageCode = ""
    /// @return Singleton Config instance
    static let defaultConfig = MJRefreshConfig()
    
}
