//
//  NSBundle+MJRefresh.swift
//  MJRefreshFramework
//
//  Created by 史晓义 on 2020/2/7.
//  Copyright © 2020 小码哥. All rights reserved.
//

import UIKit

extension Bundle
{
    static var mj_refreshBundle : Bundle? = {
        // 这里不使用mainBundle是为了适配pod 1.x和0.x
        return Bundle.init(path: Bundle.init(for: MJRefreshComponent.self).path(forResource: "MJRefresh", ofType: "bundle") ?? "")
    }()
    
    static var mj_arrowImage: UIImage? = {
        return UIImage.init(contentsOfFile: mj_refreshBundle?.path(forResource: "arrow@2x", ofType: "png") ?? "")?.withRenderingMode(.alwaysTemplate)
    }()
}

extension Bundle
{
    private static var bundle : Bundle? {
        get {
            var language = MJRefreshConfig.defaultConfig.languageCode
            // 如果配置中没有配置语言
            if (language.isEmpty) {
                // （iOS获取的语言字符串比较不稳定）目前框架只处理en、zh-Hans、zh-Hant三种情况，其他按照系统默认处理
                language = Locale.preferredLanguages.first ?? ""
            }
            
            if language.hasPrefix("en")
            {
                language = "en"
            }
            else if language.hasPrefix("zh")
            {
                if language.contains("Hans") {
                    language = "zh-Hans" // 简体中文
                } else { // zh-Hant\zh-HK\zh-TW
                    language = "zh-Hant" // 繁體中文
                }
            }
            else if language.hasPrefix("ko")
            {
                language = "ko"
            }
            else if language.hasPrefix("ru")
            {
                language = "ru"
            }
            else if language.hasPrefix("uk")
            {
                language = "uk"
            } else {
                language = "en"
            }
            
            // 从MJRefresh.bundle中查找资源
            return Bundle.init(path: Bundle.mj_refreshBundle?.path(forResource: language, ofType: "lproj") ?? "")
        }
    }
    
    static func mj_localizedString(forKey key:String, value:String!) -> String! {
        var value = value
        value = bundle?.localizedString(forKey: key, value: value, table: nil)
        return Bundle.main.localizedString(forKey: key, value: value, table: nil)
    }
    
    static func mj_localizedString(forKey key:String) -> String!
    {
        return self.mj_localizedString(forKey: key, value: nil)
    }
}
