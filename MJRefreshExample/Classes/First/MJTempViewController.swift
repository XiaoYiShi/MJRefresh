//
//  MJTempViewController.swift
//  MJRefreshExample
//
//  Created by 史晓义 on 2020/2/26.
//  Copyright © 2020 小码哥. All rights reserved.
//

import UIKit

class MJTempViewController: UIViewController {
    
    //MARK: - 单例
    public static let sharedInstance = MJTempViewController()
    
    public var statusBarStyle : UIStatusBarStyle = .lightContent {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    public var statusBarHidden : Bool = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    
    //MARK: - 初始化
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        
        let control = UISegmentedControl.init(items: ["示例1", "示例2", "示例3"])
        control.tintColor = .orange
        control.frame = self.view.bounds
        
        control.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(contorlSelect(_:)), for: .valueChanged)
        self.view.addSubview(control)
    }
    
    //私有
    @objc private func contorlSelect(_ control:UISegmentedControl)
    {
        let keyWindow = UIApplication.shared.keyWindow
        if #available(iOS 13.0, *) {
            keyWindow?.rootViewController = keyWindow?.rootViewController?.storyboard?.instantiateViewController(
                identifier: String.init(format: "%zd", control.selectedSegmentIndex)
            )
        } else {
        }
        
        if (control.selectedSegmentIndex == 0) {
            self.statusBarStyle = .lightContent
            self.statusBarHidden = false
        } else if (control.selectedSegmentIndex == 1) {
            self.statusBarHidden = true
        } else if (control.selectedSegmentIndex == 2) {
            self.statusBarStyle = .default
            self.statusBarHidden = false
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return self.statusBarHidden
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.statusBarStyle
    }
}
